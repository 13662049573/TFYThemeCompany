//
//  NSObject+CrashKVO.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSObject+CrashKVO.h"
#import "NSObject+Crash.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "TFYCrashExceptionProxy.h"

static const char TFYCrashDeallocKVOKey;

@interface TFYCrashKVOObjectItem : NSObject

@property(nonatomic,readwrite,assign)NSObject* observer;
@property(nonatomic,readwrite,assign)NSObject* whichObject;
@property(nonatomic,readwrite,copy)NSString* keyPath;
@property(nonatomic,readwrite,assign)NSKeyValueObservingOptions options;
@property(nonatomic,readwrite,assign)void* context;

@end

@implementation TFYCrashKVOObjectItem

- (BOOL)isEqual:(TFYCrashKVOObjectItem*)object{
    // check object nil
    if (!self.observer || !self.whichObject || !self.keyPath
        || !object.observer || !object.whichObject || !object.keyPath) {
        return NO;
    }
    if ([self.observer isEqual:object.observer] && [self.whichObject isEqual:object.whichObject] && [self.keyPath isEqualToString:object.keyPath]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash{
    return [self.observer hash] ^ [self.whichObject hash] ^ [self.keyPath hash];
}

- (void)dealloc{
    self.observer = nil;
    self.whichObject = nil;
    self.context = nil;
    if (self.keyPath) {
        [self.keyPath release];
    }
    [super dealloc];
}

@end


@interface TFYCrashKVOObjectContainer : NSObject

@property(nonatomic,readwrite,retain)NSMutableSet* kvoObjectSet;
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property(nonatomic,readwrite,retain)dispatch_semaphore_t kvoLock;
#else
@property(nonatomic,readwrite,assign)dispatch_semaphore_t kvoLock;
#endif

- (void)checkAddKVOItemExist:(TFYCrashKVOObjectItem*)item existResult:(void (^)(void))existResult;

@end

@implementation TFYCrashKVOObjectContainer

- (void)checkAddKVOItemExist:(TFYCrashKVOObjectItem*)item existResult:(void (^)(void))existResult{
    dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
    if (!item) {
        dispatch_semaphore_signal(self.kvoLock);
        return;
    }
    BOOL exist = [self.kvoObjectSet containsObject:item];
    if (!exist) {
        if (existResult) {
            existResult();
        }
        [self.kvoObjectSet addObject:item];
    }
    dispatch_semaphore_signal(self.kvoLock);
}

- (void)lockObjectSet:(void (^)(NSMutableSet *kvoObjectSet))objectSet {
    if (objectSet) {
        dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
        objectSet(self.kvoObjectSet);
        dispatch_semaphore_signal(self.kvoLock);
    }
}

- (dispatch_semaphore_t)kvoLock{
    if (!_kvoLock) {
        _kvoLock = dispatch_semaphore_create(1);
        return _kvoLock;
    }
    return _kvoLock;
}

- (void)dealloc{
    [self.kvoObjectSet release];
    dispatch_release(self.kvoLock);
    [super dealloc];
}

- (void)cleanKVOData{
    dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
    for (TFYCrashKVOObjectItem* item in self.kvoObjectSet) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        if (item.observer) {
            @try {
                ((void(*)(id,SEL,id,NSString*))objc_msgSend)(item.whichObject,@selector(crashhookRemoveObserver:forKeyPath:),item.observer,item.keyPath);
            }@catch (NSException *exception) {
            }
            item.observer = nil;
            item.whichObject = nil;
            item.keyPath = nil;
        }
        #pragma clang diagnostic pop
    }
    [self.kvoObjectSet removeAllObjects];
    dispatch_semaphore_signal(self.kvoLock);
}

- (NSMutableSet*)kvoObjectSet{
    if(_kvoObjectSet){
        return _kvoObjectSet;
    }
    _kvoObjectSet = [[NSMutableSet alloc] init];
    return _kvoObjectSet;
}

@end
@implementation NSObject (CrashKVO)

+ (void)tfy_crashswizzleKVOCrash {
    [self tfy_crashswizzleInstanceMethod:self.class originSelector:@selector(addObserver:forKeyPath:options:context:) swizzleSelector:@selector(crashhookAddObserver:forKeyPath:options:context:)];
    [self tfy_crashswizzleInstanceMethod:self.class originSelector:@selector(removeObserver:forKeyPath:) swizzleSelector:@selector(crashhookRemoveObserver:forKeyPath:)];
    [self tfy_crashswizzleInstanceMethod:self.class originSelector:@selector(removeObserver:forKeyPath:context:) swizzleSelector:@selector(crashhookRemoveObserver:forKeyPath:context:)];
    [self tfy_crashswizzleInstanceMethod:self.class originSelector:@selector(observeValueForKeyPath:ofObject:change:context:) swizzleSelector:@selector(crashhookObserveValueForKeyPath:ofObject:change:context:)];
}

- (void)crashhookAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    if ([self ignoreKVOInstanceClass:observer]) {
        [self crashhookAddObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }

    if (!observer || keyPath.length == 0) {
        return;
    }

    // Record the kvo relation
    TFYCrashKVOObjectItem* item = [[TFYCrashKVOObjectItem alloc] init];
    item.observer = observer;
    item.keyPath = keyPath;
    item.options = options;
    item.context = context;
    item.whichObject = self;

    // Observer current self
    TFYCrashKVOObjectContainer* objectContainer = objc_getAssociatedObject(self,&TFYCrashDeallocKVOKey);
    if (!objectContainer) {
        objectContainer = [TFYCrashKVOObjectContainer new];
        objc_setAssociatedObject(self, &TFYCrashDeallocKVOKey, objectContainer, OBJC_ASSOCIATION_RETAIN);
        [objectContainer release];
    }

    [objectContainer checkAddKVOItemExist:item existResult:^{
        [self crashhookAddObserver:observer forKeyPath:keyPath options:options context:context];
    }];

    // Observer observer
    TFYCrashKVOObjectContainer* observerContainer = objc_getAssociatedObject(observer,&TFYCrashDeallocKVOKey);
    if (!observerContainer) {
        observerContainer = [TFYCrashKVOObjectContainer new];
        objc_setAssociatedObject(observer, &TFYCrashDeallocKVOKey, observerContainer, OBJC_ASSOCIATION_RETAIN);
        [observerContainer release];
    }
    [observerContainer checkAddKVOItemExist:item existResult:nil];

    [item release];
    
    [self tfy_crashswizzleDeallocIfNeeded:self.class];
    [self tfy_crashswizzleDeallocIfNeeded:observer.class];
}

- (void)crashhookRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void*)context{
    if ([self ignoreKVOInstanceClass:observer]) {
        [self crashhookRemoveObserver:observer forKeyPath:keyPath context:context];
        return;
    }
    [self removeObserver:observer forKeyPath:keyPath];
}

- (void)crashhookRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    if ([self ignoreKVOInstanceClass:observer]) {
        [self crashhookRemoveObserver:observer forKeyPath:keyPath];
        return;
    }

    if (!observer) {
        return;
    }

    TFYCrashKVOObjectContainer* objectContainer = objc_getAssociatedObject(self, &TFYCrashDeallocKVOKey);
    if (!objectContainer) {
        return;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objectContainer lockObjectSet:^(NSMutableSet *kvoObjectSet) {
            TFYCrashKVOObjectItem* targetItem = [[TFYCrashKVOObjectItem alloc] init];
            targetItem.observer = observer;
            targetItem.whichObject = self;
            targetItem.keyPath = keyPath;

            TFYCrashKVOObjectItem* resultItem = nil;
            NSSet *set = [kvoObjectSet copy];
            for (TFYCrashKVOObjectItem* item in set) {
                if ([item isEqual:targetItem]) {
                    resultItem = item;
                    break;
                }
            }
            if (resultItem) {
                @try {
                    [self crashhookRemoveObserver:observer forKeyPath:keyPath];
                }@catch (NSException *exception) {
                }
                //Clean the reference
                resultItem.observer = nil;
                resultItem.whichObject = nil;
                resultItem.keyPath = nil;
                [kvoObjectSet removeObject:resultItem];
            }
            [targetItem release];
            [set release];
        }];
    });
}

- (void)crashhookObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([self ignoreKVOInstanceClass:object]) {
        [self crashhookObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }

    @try {
        [self crashhookObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
    } @catch (NSException *exception) {
        crashhandleCrashException(TFYCrashExceptionGuardKVOCrash, exception.description);
    }
}


- (BOOL)ignoreKVOInstanceClass:(id)object{

    if (!object) {
        return NO;
    }

    //Ignore ReactiveCocoa
    if (object_getClass(object) == objc_getClass("RACKVOProxy")) {
        return YES;
    }

    //Ignore AMAP
    NSString* className = NSStringFromClass(object_getClass(object));
    if ([className hasPrefix:@"AMap"]) {
        return YES;
    }

    return NO;
}

- (void)tfy_cleanKVO{
    TFYCrashKVOObjectContainer* objectContainer = objc_getAssociatedObject(self, &TFYCrashDeallocKVOKey);
    if (objectContainer) {
        [objectContainer cleanKVOData];
    }
}

@end
