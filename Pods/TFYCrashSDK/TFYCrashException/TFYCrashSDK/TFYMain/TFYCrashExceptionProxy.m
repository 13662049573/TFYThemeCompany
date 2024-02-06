//
//  TFYCrashExceptionProxy.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/24.
//

#import "TFYCrashExceptionProxy.h"
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import "TFYLogTool.h"

__attribute__((overloadable)) void crashhandleCrashException(NSString* exceptionMessage){
    [[TFYCrashExceptionProxy shareExceptionProxy] crashhandleCrashException:exceptionMessage extraInfo:@{}];
}

__attribute__((overloadable)) void crashhandleCrashException(NSString* exceptionMessage,NSDictionary* extraInfo){
    [[TFYCrashExceptionProxy shareExceptionProxy] crashhandleCrashException:exceptionMessage extraInfo:extraInfo];
}

__attribute__((overloadable)) void crashhandleCrashException(TFYCrashExceptionGuardCategory exceptionCategory, NSString* exceptionMessage,NSDictionary* extraInfo){
    [[TFYCrashExceptionProxy shareExceptionProxy] crashhandleCrashException:exceptionMessage exceptionCategory:exceptionCategory extraInfo:extraInfo];
}

__attribute__((overloadable)) void crashhandleCrashException(TFYCrashExceptionGuardCategory exceptionCategory, NSString* exceptionMessage){
    [[TFYCrashExceptionProxy shareExceptionProxy] crashhandleCrashException:exceptionMessage exceptionCategory:exceptionCategory extraInfo:nil];
}

/**
 Get application base address,the application different base address after started
 
 @return base address
 */
uintptr_t get_load_address(void) {
    const struct mach_header *exe_header = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            exe_header = header;
            break;
        }
    }
    return (uintptr_t)exe_header;
}

/**
 Address Offset

 @return slide address
 */
uintptr_t get_slide_address(void) {
    uintptr_t vmaddr_slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    
    return (uintptr_t)vmaddr_slide;
}

@interface TFYCrashExceptionProxy (){
    NSMutableSet* _currentClassesSet;
    NSMutableSet* _blackClassesSet;
    NSInteger _currentClassSize;
    dispatch_semaphore_t _classArrayLock;//Protect _blackClassesSet and _currentClassesSet atomic
    dispatch_semaphore_t _swizzleLock;//Protect swizzle atomic
}

@end

@implementation TFYCrashExceptionProxy

+(instancetype)shareExceptionProxy{
    static dispatch_once_t onceToken;
    static id exceptionProxy;
    dispatch_once(&onceToken, ^{
        exceptionProxy = [[self alloc] init];
    });
    return exceptionProxy;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _blackClassesSet = [NSMutableSet new];
        _currentClassesSet = [NSMutableSet new];
        _currentClassSize = 0;
        _classArrayLock = dispatch_semaphore_create(1);
        _swizzleLock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)crashhandleCrashException:(NSString *)exceptionMessage exceptionCategory:(TFYCrashExceptionGuardCategory)exceptionCategory extraInfo:(NSDictionary *)info{
    if (!exceptionMessage) {
        return;
    }
    
    NSArray* callStack = [NSThread callStackSymbols];
    NSString* callStackString = [NSString stringWithFormat:@"%@",callStack];
    
    uintptr_t loadAddress =  get_load_address();
    uintptr_t slideAddress =  get_slide_address();
    
    NSString* exceptionResult = [NSString stringWithFormat:@"%ld\n%ld\n%@\n%@",loadAddress,slideAddress,exceptionMessage,callStackString];
    
    
    if ([self.delegate respondsToSelector:@selector(crashhandleCrashException:extraInfo:)]){
        [self.delegate crashhandleCrashException:exceptionResult extraInfo:info];
    }
    
    if ([self.delegate respondsToSelector:@selector(crashhandleCrashException:exceptionCategory:extraInfo:)]) {
        [self.delegate crashhandleCrashException:exceptionResult exceptionCategory:exceptionCategory extraInfo:info];
    }
    
#ifdef DEBUG
    TFYWLogError(@"================================TFYCrashException Start==================================");
    TFYWLogError(@"TFYCrashException Type:%ld",(long)exceptionCategory);
    TFYWLogError(@"TFYCrashException Description:%@",exceptionMessage);
    TFYWLogError(@"TFYCrashException Extra info:%@",info);
    TFYWLogError(@"TFYCrashException CallStack:%@",callStack);
    TFYWLogError(@"================================TFYCrashException End====================================");
    if (self.exceptionWhenTerminate) {
        NSAssert(NO, @"");
    }
#endif
}

- (void)crashhandleCrashException:(NSString *)exceptionMessage extraInfo:(nullable NSDictionary *)info{
    [self crashhandleCrashException:exceptionMessage exceptionCategory:TFYCrashExceptionGuardNone extraInfo:info];
}

- (void)setIsProtectException:(BOOL)isProtectException{
    dispatch_semaphore_wait(_swizzleLock, DISPATCH_TIME_FOREVER);
    if (_isProtectException != isProtectException) {
        _isProtectException = isProtectException;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        
        if(self.exceptionGuardCategory & TFYCrashExceptionGuardArrayContainer){
            [NSArray performSelector:@selector(tfy_crashswizzleNSArray)];
            [NSMutableArray performSelector:@selector(tfy_crashswizzleNSMutableArray)];
            [NSSet performSelector:@selector(tfy_crashswizzleNSSet)];
            [NSMutableSet performSelector:@selector(tfy_crashswizzleNSMutableSet)];
        }
        if(self.exceptionGuardCategory & TFYCrashExceptionGuardDictionaryContainer){
            [NSDictionary performSelector:@selector(tfy_crashswizzleNSDictionary)];
            [NSMutableDictionary performSelector:@selector(tfy_crashswizzleNSMutableDictionary)];
        }
        if(self.exceptionGuardCategory & TFYCrashExceptionGuardUnrecognizedSelector){
            [NSObject performSelector:@selector(tfy_crashswizzleUnrecognizedSelector)];
        }
        
        if (self.exceptionGuardCategory & TFYCrashExceptionGuardKVOCrash) {
            [NSObject performSelector:@selector(tfy_crashswizzleKVOCrash)];
        }
        
        if (self.exceptionGuardCategory & TFYCrashExceptionGuardNSTimer) {
            [NSTimer performSelector:@selector(tfy_crashswizzleNSTimer)];
        }
        
        if (self.exceptionGuardCategory & TFYCrashExceptionGuardNSNotificationCenter) {
            [NSNotificationCenter performSelector:@selector(tfy_crashswizzleNSNotificationCenter)];
        }
        
        if (self.exceptionGuardCategory & TFYCrashExceptionGuardNSStringContainer) {
            [NSString performSelector:@selector(tfy_crashswizzleNSString)];
            [NSMutableString performSelector:@selector(tfy_crashswizzleNSMutableString)];
            [NSAttributedString performSelector:@selector(tfy_crashswizzleNSAttributedString)];
            [NSMutableAttributedString performSelector:@selector(tfy_crashswizzleNSMutableAttributedString)];
        }
        #pragma clang diagnostic pop
    }
    dispatch_semaphore_signal(_swizzleLock);
}

- (void)setExceptionGuardCategory:(TFYCrashExceptionGuardCategory)exceptionGuardCategory{
    if (_exceptionGuardCategory != exceptionGuardCategory) {
        _exceptionGuardCategory = exceptionGuardCategory;
    }
}


@end
