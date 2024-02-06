//
//  NSDictionary+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSDictionary+Crash.h"
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSDictionary_DictionaryHook)

@implementation NSDictionary (Crash)

+ (void)tfy_crashswizzleNSDictionary {
    [NSDictionary tfy_crashswizzleClassMethod:@selector(dictionaryWithObject:forKey:) withSwizzleMethod:@selector(crashhookDictionaryWithObject:forKey:)];
    [NSDictionary tfy_crashswizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withSwizzleMethod:@selector(crashhookDictionaryWithObjects:forKeys:count:)];
}

+ (instancetype)crashhookDictionaryWithObject:(id)object forKey:(id)key
{
    if (object && key) {
        return [self crashhookDictionaryWithObject:object forKey:key];
    }
    crashhandleCrashException(TFYCrashExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSDictionary dictionaryWithObject invalid object:%@ and key:%@",object,key]);
    return nil;
}

+ (instancetype)crashhookDictionaryWithObjects:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt
{
    NSInteger index = 0;
    id ks[cnt];
    id objs[cnt];
    for (NSInteger i = 0; i < cnt ; ++i) {
        if (keys[i] && objects[i]) {
            ks[index] = keys[i];
            objs[index] = objects[i];
            ++index;
        }else{
            crashhandleCrashException(TFYCrashExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSDictionary dictionaryWithObjects invalid keys:%@ and object:%@",keys[i],objects[i]]);
        }
    }
    return [self crashhookDictionaryWithObjects:objs forKeys:ks count:index];
}

@end
