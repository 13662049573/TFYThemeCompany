//
//  NSMutableDictionary+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSMutableDictionary+Crash.h"
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSMutableDictionary_MutableDictionaryHook)

@implementation NSMutableDictionary (Crash)

+ (void)tfy_crashswizzleNSMutableDictionary {
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(setObject:forKey:) swizzleSelector: @selector(crashhookSetObject:forKey:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(removeObjectForKey:) swizzleSelector:@selector(crashhookRemoveObjectForKey:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(setObject:forKeyedSubscript:) swizzleSelector:@selector(crashhookSetObject:forKeyedSubscript:)];
}

- (void)crashhookSetObject:(id)object forKey:(id)key {
    if (object && key) {
        [self crashhookSetObject:object forKey:key];
    } else {
        crashhandleCrashException(TFYCrashExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSMutableDictionary setObject invalid object:%@ and key:%@",object,key],self);
    }
}

- (void)crashhookRemoveObjectForKey:(id)key {
    if (key) {
        [self crashhookRemoveObjectForKey:key];
    } else {
        crashhandleCrashException(TFYCrashExceptionGuardDictionaryContainer,@"NSMutableDictionary removeObjectForKey nil key",self);
    }
}

- (void)crashhookSetObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        [self crashhookSetObject:object forKeyedSubscript:key];
    } else {
        crashhandleCrashException(TFYCrashExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSMutableDictionary setObject object:%@ and forKeyedSubscript:%@",object,key],self);
    }
}

@end
