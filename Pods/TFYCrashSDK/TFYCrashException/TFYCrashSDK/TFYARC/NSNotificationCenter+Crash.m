//
//  NSNotificationCenter+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSNotificationCenter+Crash.h"
#import <objc/runtime.h>
#import "NSObject+Crash.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSNotificationCenter_ClearNotification)

@implementation NSNotificationCenter (Crash)

+ (void)tfy_crashswizzleNSNotificationCenter {
    [self tfy_crashswizzleInstanceMethod:@selector(addObserver:selector:name:object:) withSwizzledBlock:^id(TFYCrashSwizzleObject *swizzleInfo) {
        return ^(__unsafe_unretained id self,id observer,SEL aSelector,NSString* aName,id anObject){
            [self crashprocessAddObserver:observer selector:aSelector name:aName object:anObject swizzleInfo:swizzleInfo];
        };
    }];
}

- (void)crashprocessAddObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject swizzleInfo:(TFYCrashSwizzleObject*)swizzleInfo{
    
    if (!observer) {
        return;
    }
    
    if ([observer isKindOfClass:NSObject.class]) {
        __unsafe_unretained typeof(observer) unsafeObject = observer;
        [observer tfy_deallocBlock:^{
            [[NSNotificationCenter defaultCenter] removeObserver:unsafeObject];
        }];
    }
    
    void(*originIMP)(__unsafe_unretained id,SEL,id,SEL,NSString*,id);
    originIMP = (__typeof(originIMP))[swizzleInfo getOriginalImplementation];
    if (originIMP != NULL) {
        originIMP(self,swizzleInfo.selector,observer,aSelector,aName,anObject);
    }
}


@end
