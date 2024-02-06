//
//  NSObject+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSObject+Crash.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const char DeallocNSObjectKey;
typedef IMP (^TFYCrashSWizzleImpProvider)(void);

static const char TFYCrashSwizzledDeallocKey;

// 一个类不需要dealloc swizzled，如果它或超类已经被swizzled
__attribute__((overloadable)) BOOL tfy_crashrequiresDeallocSwizzle(Class class)
{
    BOOL swizzled = NO;
    
    for ( Class currentClass = class; !swizzled && currentClass != nil; currentClass = class_getSuperclass(currentClass) ) {
        swizzled = [objc_getAssociatedObject(currentClass, &TFYCrashSwizzledDeallocKey) boolValue];
    }
    
    return !swizzled;
}

@interface TFYCrashSwizzleObject()
@property (nonatomic,readwrite,copy) TFYCrashSWizzleImpProvider impProviderBlock;
@property (nonatomic,readwrite,assign) SEL selector;
@end

@implementation TFYCrashSwizzleObject

- (TFYCrashSwizzleOriginalIMP)getOriginalImplementation{
    NSAssert(_impProviderBlock,nil);
    return (TFYCrashSwizzleOriginalIMP)_impProviderBlock();
}

@end

@interface TFYCrashDeallocStub : NSObject
@property (nonatomic,readwrite,copy) void(^deallocBlock)(void);
@end

@implementation TFYCrashDeallocStub

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
    self.deallocBlock = nil;
}

@end

@implementation NSObject (Crash)

void __TFY_SWIZZLE_BLOCK(Class classToSwizzle,SEL selector,TFYCrashSwizzledIMPBlock impBlock){
    Method method = class_getInstanceMethod(classToSwizzle, selector);
    
    __block IMP originalIMP = NULL;
    
    TFYCrashSWizzleImpProvider originalImpProvider = ^IMP{
        
        IMP imp = originalIMP;
        
        if (NULL == imp){
            Class superclass = class_getSuperclass(classToSwizzle);
            imp = method_getImplementation(class_getInstanceMethod(superclass,selector));
        }
        return imp;
    };
    
    TFYCrashSwizzleObject* swizzleInfo = [TFYCrashSwizzleObject new];
    swizzleInfo.selector = selector;
    swizzleInfo.impProviderBlock = originalImpProvider;
    
    id newIMPBlock = impBlock(swizzleInfo);
    
    const char* methodType = method_getTypeEncoding(method);
    
    IMP newIMP = imp_implementationWithBlock(newIMPBlock);
    
    originalIMP = class_replaceMethod(classToSwizzle, selector, newIMP, methodType);
}

+ (void)tfy_crashswizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector{
    [self tfy_crashswizzleClassMethod:self.class originSelector:originSelector swizzleSelector:swizzleSelector];
}

- (void)tfy_crashswizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector{
    [self tfy_crashswizzleInstanceMethod:self.class originSelector:originSelector swizzleSelector:swizzleSelector];
}

- (void)tfy_crashswizzleInstanceMethod:(SEL)originSelector withSwizzledBlock:(TFYCrashSwizzledIMPBlock)swizzledBlock{
    __TFY_SWIZZLE_BLOCK(self.class, originSelector, swizzledBlock);
}

- (void)tfy_crashswizzleClassMethod:(Class)cls originSelector:(SEL)originSelector swizzleSelector:(SEL)swizzleSelector {
    if (!cls) {
        return;
    }
    Method originalMethod = class_getClassMethod(cls, originSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzleSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            swizzleSelector,
                            class_replaceMethod(metacls,
                                                originSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

- (void)tfy_crashswizzleInstanceMethod:(Class)cls originSelector:(SEL)originSelector swizzleSelector:(SEL)swizzleSelector
{
    if (!cls) {
        return;
    }
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, originSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzleSelector);
    
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            swizzleSelector,
                            class_replaceMethod(cls,
                                                originSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
    
}

- (void)tfy_crashswizzleDeallocIfNeeded:(Class)class {
    static SEL deallocSEL = NULL;
    static SEL cleanupSEL = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deallocSEL = sel_getUid("dealloc");
        cleanupSEL = sel_getUid("tfy_cleanKVO");
    });
    
    @synchronized (class) {
        if ( !tfy_crashrequiresDeallocSwizzle(class) ) {
            return;
        }
        
        objc_setAssociatedObject(class, &TFYCrashSwizzledDeallocKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    Method dealloc = NULL;
    
    unsigned int count = 0;
    Method* method = class_copyMethodList(class, &count);
    for (unsigned int i = 0; i < count; i++) {
        if (method_getName(method[i]) == deallocSEL) {
            dealloc = method[i];
            break;
        }
    }
    
    if ( dealloc == NULL ) {
        Class superclass = class_getSuperclass(class);
        
        class_addMethod(class, deallocSEL, imp_implementationWithBlock(^(__unsafe_unretained id self) {
            
            ((void(*)(id, SEL))objc_msgSend)(self, cleanupSEL);
            
            struct objc_super superStruct = (struct objc_super){ self, superclass };
            ((void (*)(struct objc_super*, SEL))objc_msgSendSuper)(&superStruct, deallocSEL);
            
        }), method_getTypeEncoding(dealloc));
    }else{
        __block IMP deallocIMP = method_setImplementation(dealloc, imp_implementationWithBlock(^(__unsafe_unretained id self) {
            ((void(*)(id, SEL))objc_msgSend)(self, cleanupSEL);
            
            ((void(*)(id, SEL))deallocIMP)(self, deallocSEL);
        }));
    }
}

- (void)tfy_deallocBlock:(void(^)(void))block{
    @synchronized(self){
        NSMutableArray* blockArray = objc_getAssociatedObject(self, &DeallocNSObjectKey);
        if (!blockArray) {
            blockArray = [NSMutableArray array];
            objc_setAssociatedObject(self, &DeallocNSObjectKey, blockArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        TFYCrashDeallocStub *stub = [TFYCrashDeallocStub new];
        stub.deallocBlock = block;
        
        [blockArray addObject:stub];
    }
}


@end
