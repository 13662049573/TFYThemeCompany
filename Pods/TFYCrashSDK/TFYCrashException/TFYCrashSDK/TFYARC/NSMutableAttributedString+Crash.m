//
//  NSMutableAttributedString+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSMutableAttributedString+Crash.h"
#import "NSObject+Crash.h"
#import <objc/runtime.h>
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSMutableAttributedString_MutableAttributedStringHook)

@implementation NSMutableAttributedString (Crash)

+ (void)tfy_crashswizzleNSMutableAttributedString {
    NSMutableAttributedString* instanceObject = [NSMutableAttributedString new];
    Class cls =  object_getClass(instanceObject);
    
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(initWithString:) swizzleSelector:@selector(crashhookInitWithString:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(initWithString:attributes:) swizzleSelector:@selector(crashhookInitWithString:attributes:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(addAttribute:value:range:) swizzleSelector:@selector(crashhookAddAttribute:value:range:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(addAttributes:range:) swizzleSelector:@selector(crashhookAddAttributes:range:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(setAttributes:range:) swizzleSelector:@selector(crashhookSetAttributes:range:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(removeAttribute:range:) swizzleSelector:@selector(crashhookRemoveAttribute:range:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(deleteCharactersInRange:) swizzleSelector:@selector(crashhookDeleteCharactersInRange:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(replaceCharactersInRange:withString:) swizzleSelector:@selector(crashhookReplaceCharactersInRange:withString:)];
    [self tfy_crashswizzleInstanceMethod:cls originSelector:@selector(replaceCharactersInRange:withAttributedString:) swizzleSelector:@selector(crashhookReplaceCharactersInRange:withAttributedString:)];
}

- (id)crashhookInitWithString:(NSString*)str{
    if (str){
        return [self crashhookInitWithString:str];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSMutableAttributedString initWithString parameter nil");
    return nil;
}

- (id)crashhookInitWithString:(NSString*)str attributes:(nullable NSDictionary*)attributes{
    if (str){
        return [self crashhookInitWithString:str attributes:attributes];
    }
    crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString initWithString:attributes: str:%@ attributes:%@",str,attributes]);
    return nil;
}

- (void)crashhookAddAttribute:(id)name value:(id)value range:(NSRange)range{
    if (!range.length) {
        [self crashhookAddAttribute:name value:value range:range];
    }else if (value){
        if (range.location + range.length <= self.length) {
            [self crashhookAddAttribute:name value:value range:range];
        }else{
            crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString addAttribute:value:range: name:%@ value:%@ range:%@",name,value,NSStringFromRange(range)]);
        }
    }else {
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSMutableAttributedString addAttribute:value:range: value nil");
    }
}
- (void)crashhookAddAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range{
    if (!range.length) {
        [self crashhookAddAttributes:attrs range:range];
    }else if (attrs){
        if (range.location + range.length <= self.length) {
            [self crashhookAddAttributes:attrs range:range];
        }else{
            crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString addAttributes:range: attrs:%@ range:%@",attrs,NSStringFromRange(range)]);
        }
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSMutableAttributedString addAttributes:range: value nil");
    }
}

- (void)crashhookSetAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    if (!range.length) {
        [self crashhookSetAttributes:attrs range:range];
    } else {
        if (range.location + range.length <= self.length) {
            [self crashhookSetAttributes:attrs range:range];
        }else{
            crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString setAttributes:range: attrs:%@ range:%@",attrs,NSStringFromRange(range)]);
        }
    }
}

- (void)crashhookRemoveAttribute:(id)name range:(NSRange)range {
    if (!range.length) {
        [self crashhookRemoveAttribute:name range:range];
    }else if (name){
        if (range.location + range.length <= self.length) {
            [self crashhookRemoveAttribute:name range:range];
        }else {
            crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString removeAttribute:range: name:%@ range:%@",name,NSStringFromRange(range)]);
        }
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSMutableAttributedString removeAttribute:range: attrs nil");
    }
}

- (void)crashhookDeleteCharactersInRange:(NSRange)range {
    if (range.location + range.length <= self.length) {
        [self crashhookDeleteCharactersInRange:range];
    }else {
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString deleteCharactersInRange: range:%@",NSStringFromRange(range)]);
    }
}
- (void)crashhookReplaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    if (str){
        if (range.location + range.length <= self.length) {
            [self crashhookReplaceCharactersInRange:range withString:str];
        }else{
            crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString replaceCharactersInRange:withString string:%@ range:%@",str,NSStringFromRange(range)]);
        }
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSMutableAttributedString replaceCharactersInRange:withString: string nil");
    }
}
- (void)crashhookReplaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)str {
    if (str){
        if (range.location + range.length <= self.length) {
            [self crashhookReplaceCharactersInRange:range withAttributedString:str];
        }else{
            crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableAttributedString replaceCharactersInRange:withString string:%@ range:%@",str,NSStringFromRange(range)]);
        }
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardNSStringContainer,@"NSMutableAttributedString replaceCharactersInRange:withString: attributedString nil");
    }
}

@end
