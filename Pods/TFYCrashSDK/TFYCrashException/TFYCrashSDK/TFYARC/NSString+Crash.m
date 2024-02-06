//
//  NSString+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSString+Crash.h"
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSString_StringHook)

@implementation NSString (Crash)

+ (void)tfy_crashswizzleNSString {
    [NSString tfy_crashswizzleClassMethod:@selector(stringWithUTF8String:) withSwizzleMethod:@selector(crashhookStringWithUTF8String:)];
    [NSString tfy_crashswizzleClassMethod:@selector(stringWithCString:encoding:) withSwizzleMethod:@selector(crashhookStringWithCString:encoding:)];
    
    //NSPlaceholderString
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"NSPlaceholderString") originSelector:@selector(initWithCString:encoding:) swizzleSelector:@selector(crashhookInitWithCString:encoding:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"NSPlaceholderString") originSelector:@selector(initWithString:) swizzleSelector:@selector(crashhookInitWithString:)];
    
    //_NSCFConstantString
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFConstantString") originSelector:@selector(substringFromIndex:) swizzleSelector:@selector(crashhookSubstringFromIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFConstantString") originSelector:@selector(substringToIndex:) swizzleSelector:@selector(crashhookSubstringToIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFConstantString") originSelector:@selector(substringWithRange:) swizzleSelector:@selector(crashhookSubstringWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFConstantString") originSelector:@selector(rangeOfString:options:range:locale:) swizzleSelector:@selector(crashhookRangeOfString:options:range:locale:)];
    
    
    //NSTaggedPointerString
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"NSTaggedPointerString") originSelector:@selector(substringFromIndex:) swizzleSelector:@selector(crashhookSubstringFromIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"NSTaggedPointerString") originSelector:@selector(substringToIndex:) swizzleSelector:@selector(crashhookSubstringToIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"NSTaggedPointerString") originSelector:@selector(substringWithRange:) swizzleSelector:@selector(crashhookSubstringWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"NSTaggedPointerString") originSelector:@selector(rangeOfString:options:range:locale:) swizzleSelector:@selector(crashhookRangeOfString:options:range:locale:)];
}

+ (NSString*)crashhookStringWithUTF8String:(const char *)nullTerminatedCString{
    if (NULL != nullTerminatedCString) {
        return [self crashhookStringWithUTF8String:nullTerminatedCString];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSString stringWithUTF8String NULL char pointer");
    return nil;
}

+ (nullable instancetype)crashhookStringWithCString:(const char *)cString encoding:(NSStringEncoding)enc
{
    if (NULL != cString){
        return [self crashhookStringWithCString:cString encoding:enc];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSString stringWithCString:encoding: NULL char pointer");
    return nil;
}

- (nullable instancetype)crashhookInitWithString:(id)cString{
    if (nil != cString){
        return [self crashhookInitWithString:cString];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSString initWithString nil parameter");
    return nil;
}

- (nullable instancetype)crashhookInitWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding{
    if (NULL != nullTerminatedCString){
        return [self crashhookInitWithCString:nullTerminatedCString encoding:encoding];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSString initWithCString:encoding NULL char pointer");
    return nil;
}

- (NSString *)crashhookSubstringFromIndex:(NSUInteger)from{
    if (from <= self.length) {
        return [self crashhookSubstringFromIndex:from];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString substringFromIndex value:%@ from:%tu",self,from]);
    return nil;
}

- (NSString *)crashhookSubstringToIndex:(NSUInteger)to{
    if (to <= self.length) {
        return [self crashhookSubstringToIndex:to];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString substringToIndex value:%@ from:%tu",self,to]);
    return self;
}

- (NSString *)crashhookSubstringWithRange:(NSRange)range{
    if (range.location + range.length <= self.length) {
        return [self crashhookSubstringWithRange:range];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString substringWithRange value:%@ range:%@",self,NSStringFromRange(range)]);
    return nil;
}
- (NSRange)crashhookRangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)range locale:(nullable NSLocale *)locale{
    if (searchString){
        if (range.location + range.length <= self.length) {
            return [self crashhookRangeOfString:searchString options:mask range:range locale:locale];
        }
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString rangeOfString:options:range:locale: value:%@ range:%@",self,NSStringFromRange(range)]);
        return NSMakeRange(NSNotFound, 0);
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString rangeOfString:options:range:locale: searchString nil value:%@ range:%@",self,NSStringFromRange(range)]);
        return NSMakeRange(NSNotFound, 0);
    }
}

@end
