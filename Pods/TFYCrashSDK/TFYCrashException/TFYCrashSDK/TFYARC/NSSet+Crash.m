//
//  NSSet+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSSet+Crash.h"
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSSet_SetHook)

@implementation NSSet (Crash)

+ (void)tfy_crashswizzleNSSet {
    [NSSet tfy_crashswizzleClassMethod:@selector(setWithObject:) withSwizzleMethod:@selector(crashhookSetWithObject:)];
}

+ (instancetype)crashhookSetWithObject:(id)object{
    if (object){
        return [self crashhookSetWithObject:object];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,@"NSSet setWithObject nil object");
    return nil;
}

@end
