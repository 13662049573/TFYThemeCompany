//
//  NSMutableSet+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSMutableSet+Crash.h"
#import "NSObject+Crash.h"
#import <objc/runtime.h>
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSMutableSet_MutableSetHook)

@implementation NSMutableSet (Crash)

+ (void)tfy_crashswizzleNSMutableSet {
    NSMutableSet* instanceObject = [NSMutableSet new];
    Class cls =  object_getClass(instanceObject);
    
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(addObject:) swizzleSelector:@selector(crashhookAddObject:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(removeObject:) swizzleSelector:@selector(crashhookRemoveObject:)];
}

- (void)crashhookAddObject:(id)object {
    if (object) {
        [self crashhookAddObject:object];
    } else {
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,@"NSSet addObject nil object");
    }
}

- (void)crashhookRemoveObject:(id)object {
    if (object) {
        [self crashhookRemoveObject:object];
    } else {
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,@"NSSet removeObject nil object");
    }
}

@end
