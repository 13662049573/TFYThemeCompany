//
//  NSObject+CrashSelector.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSObject+CrashSelector.h"
#import "NSObject+Crash.h"
#import <objc/runtime.h>
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSObject_UnrecognizedSelectorHook)

@implementation NSObject (CrashSelector)

+ (void)tfy_crashswizzleUnrecognizedSelector {
    [self tfy_crashswizzleClassMethod:self.class originSelector:@selector(methodSignatureForSelector:) swizzleSelector:@selector(classMethodSignatureForSelectorSwizzled:)];
    [self tfy_crashswizzleClassMethod:self.class originSelector:@selector(forwardInvocation:) swizzleSelector:@selector(forwardClassInvocationSwizzled:)];
    
    [self tfy_crashswizzleInstanceMethod:self.class originSelector:@selector(methodSignatureForSelector:) swizzleSelector:@selector(methodSignatureForSelectorSwizzled:)];
    [self tfy_crashswizzleInstanceMethod:self.class originSelector:@selector(forwardInvocation:) swizzleSelector:@selector(forwardInvocationSwizzled:)];
}

+ (NSMethodSignature*)classMethodSignatureForSelectorSwizzled:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self classMethodSignatureForSelectorSwizzled:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

- (NSMethodSignature*)methodSignatureForSelectorSwizzled:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self methodSignatureForSelectorSwizzled:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

+ (NSMethodSignature *)checkObjectSignatureAndCurrentClass:(Class)currentClass{
    IMP originIMP = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    IMP currentClassIMP = class_getMethodImplementation(currentClass, @selector(methodSignatureForSelector:));
    if (originIMP != currentClassIMP){
        return nil;
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}

- (void)forwardInvocationSwizzled:(NSInvocation*)invocation{
    NSString* message = [NSString stringWithFormat:@"Unrecognized instance class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)];
    crashhandleCrashException(TFYCrashExceptionGuardUnrecognizedSelector,message);
}

+ (void)forwardClassInvocationSwizzled:(NSInvocation*)invocation{
    NSString* message = [NSString stringWithFormat:@"Unrecognized static class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)];
    crashhandleCrashException(TFYCrashExceptionGuardUnrecognizedSelector,message);
}


@end
