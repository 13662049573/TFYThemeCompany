//
//  TFYCrashException.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/24.
//

#import "TFYCrashException.h"
#import "TFYCrashExceptionProxy.h"

@implementation TFYCrashException

+ (BOOL)isGuardException {
    return [TFYCrashExceptionProxy shareExceptionProxy].isProtectException;
}

+ (BOOL)exceptionWhenTerminate{
    return [TFYCrashExceptionProxy shareExceptionProxy].exceptionWhenTerminate;
}

+ (void)setExceptionWhenTerminate:(BOOL)exceptionWhenTerminate{
    [TFYCrashExceptionProxy shareExceptionProxy].exceptionWhenTerminate = exceptionWhenTerminate;
}

+ (void)startGuardException{
    [TFYCrashExceptionProxy shareExceptionProxy].isProtectException = YES;
}

+ (void)stopGuardException{
    [TFYCrashExceptionProxy shareExceptionProxy].isProtectException = NO;
}

+ (void)configExceptionCategory:(TFYCrashExceptionGuardCategory)exceptionGuardCategory{
    [TFYCrashExceptionProxy shareExceptionProxy].exceptionGuardCategory = exceptionGuardCategory;
}

+ (void)registerExceptionHandle:(id<TFYCrashExceptionHandle>)exceptionHandle{
    [TFYCrashExceptionProxy shareExceptionProxy].delegate = exceptionHandle;
}

@end
