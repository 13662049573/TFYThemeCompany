//
//  NSAttributedString+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSAttributedString+Crash.h"
#import "NSObject+Crash.h"
#import <objc/runtime.h>
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSAttributedString_AttributedStringHook)

@implementation NSAttributedString (Crash)

+ (void)tfy_crashswizzleNSAttributedString {
    NSAttributedString* instanceObject = [NSAttributedString new];
    Class cls =  object_getClass(instanceObject);
    
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(initWithString:) swizzleSelector:@selector(crashhookInitWithString:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(attributedSubstringFromRange:) swizzleSelector:@selector(crashhookAttributedSubstringFromRange:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(attribute:atIndex:effectiveRange:) swizzleSelector:@selector(crashhookAttribute:atIndex:effectiveRange:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(enumerateAttribute:inRange:options:usingBlock:) swizzleSelector:@selector(crashhookEnumerateAttribute:inRange:options:usingBlock:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(enumerateAttributesInRange:options:usingBlock:) swizzleSelector:@selector(crashhookEnumerateAttributesInRange:options:usingBlock:)];
}

- (id)crashhookInitWithString:(NSString*)str{
    if (str){
        return [self crashhookInitWithString:str];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSAttributedString initWithString parameter nil");
    return nil;
}

- (id)crashhookAttribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range{
    if (location < self.length){
        return [self crashhookAttribute:attrName atIndex:location effectiveRange:range];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSAttributedString attribute:atIndex:effectiveRange: attrName:%@ location:%tu",attrName,location]);
    return nil;
}

- (NSAttributedString *)crashhookAttributedSubstringFromRange:(NSRange)range{
    if (range.location + range.length <= self.length) {
        return [self crashhookAttributedSubstringFromRange:range];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSAttributedString attributedSubstringFromRange range:%@",NSStringFromRange(range)]);
    return nil;
}

- (void)crashhookEnumerateAttribute:(NSString *)attrName inRange:(NSRange)range options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(id _Nullable, NSRange, BOOL * _Nonnull))block{
    if (range.location + range.length <= self.length) {
        [self crashhookEnumerateAttribute:attrName inRange:range options:opts usingBlock:block];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSAttributedString enumerateAttribute attrName:%@ range:%@",attrName,NSStringFromRange(range)]);
    }
}

- (void)crashhookEnumerateAttributesInRange:(NSRange)range options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(NSDictionary<NSString*,id> * _Nonnull, NSRange, BOOL * _Nonnull))block{
    
    if (range.location == NSNotFound && range.length == 0) {
        [self crashhookEnumerateAttributesInRange:range options:opts usingBlock:block];
        return;
    }
    if (range.location + range.length <= self.length && range.location != NSNotFound) {
        [self crashhookEnumerateAttributesInRange:range options:opts usingBlock:block];
    } else {
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSAttributedString enumerateAttributesInRange range:%@",NSStringFromRange(range)]);
    }
}


@end
