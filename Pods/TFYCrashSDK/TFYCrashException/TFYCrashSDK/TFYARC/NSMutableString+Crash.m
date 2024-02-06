//
//  NSMutableString+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSMutableString+Crash.h"
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSMutableString_MutableStringHook)

@implementation NSMutableString (Crash)

+ (void)tfy_crashswizzleNSMutableString {
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFString") originSelector: @selector(appendString:) swizzleSelector:@selector(crashhookAppendString:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFString") originSelector: @selector(insertString:atIndex:) swizzleSelector:@selector(crashhookInsertString:atIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFString") originSelector: @selector(deleteCharactersInRange:) swizzleSelector:@selector(crashhookDeleteCharactersInRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFString") originSelector: @selector(substringFromIndex:) swizzleSelector:@selector(crashhookSubstringFromIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFString") originSelector: @selector(substringToIndex:) swizzleSelector:@selector(crashhookSubstringToIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFString") originSelector: @selector(substringWithRange:) swizzleSelector:@selector(crashhookSubstringWithRange:)];
}

- (void)crashhookAppendString:(NSString *)aString{
    if (aString){
        [self crashhookAppendString:aString];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString appendString value:%@ parameter nil",self]);
    }
}

- (void)crashhookInsertString:(NSString *)aString atIndex:(NSUInteger)loc{
    if (aString && loc <= self.length) {
        [self crashhookInsertString:aString atIndex:loc];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString insertString:atIndex: value:%@ paremeter string:%@ atIndex:%tu",self,aString,loc]);
    }
}

- (void)crashhookDeleteCharactersInRange:(NSRange)range{
    if (range.location + range.length <= self.length){
        [self crashhookDeleteCharactersInRange:range];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString deleteCharactersInRange value:%@ range:%@",self,NSStringFromRange(range)]);
    }
}

- (NSString *)crashhookSubstringFromIndex:(NSUInteger)from{
    if (from <= self.length) {
        return [self crashhookSubstringFromIndex:from];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString substringFromIndex value:%@ from:%tu",self,from]);
    return nil;
}

- (NSString *)crashhookSubstringToIndex:(NSUInteger)to{
    if (to <= self.length) {
        return [self crashhookSubstringToIndex:to];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString substringToIndex value:%@ to:%tu",self,to]);
    return self;
}

- (NSString *)crashhookSubstringWithRange:(NSRange)range{
    if (range.location + range.length <= self.length) {
        return [self crashhookSubstringWithRange:range];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString substringWithRange value:%@ range:%@",self,NSStringFromRange(range)]);
    return nil;
}

@end
