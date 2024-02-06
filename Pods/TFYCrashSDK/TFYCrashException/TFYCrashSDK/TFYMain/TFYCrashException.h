//
//  TFYCrashException.h
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger,TFYCrashExceptionGuardCategory){
    TFYCrashExceptionGuardNone = 0,
    TFYCrashExceptionGuardUnrecognizedSelector = 1 << 1,
    TFYCrashExceptionGuardDictionaryContainer = 1 << 2,
    TFYCrashExceptionGuardArrayContainer = 1 << 3,
    TFYCrashExceptionGuardKVOCrash = 1 << 4,
    TFYCrashExceptionGuardNSTimer = 1 << 5,
    TFYCrashExceptionGuardNSNotificationCenter = 1 << 6,
    TFYCrashExceptionGuardNSStringContainer = 1 << 7,
    TFYCrashExceptionGuardAll = TFYCrashExceptionGuardUnrecognizedSelector | TFYCrashExceptionGuardDictionaryContainer | TFYCrashExceptionGuardArrayContainer | TFYCrashExceptionGuardKVOCrash | TFYCrashExceptionGuardNSTimer | TFYCrashExceptionGuardNSNotificationCenter | TFYCrashExceptionGuardNSStringContainer,
};

@protocol TFYCrashExceptionHandle<NSObject>

/**
 崩溃消息和来自当前线程的额外信息
 */
- (void)crashhandleCrashException:(NSString*)exceptionMessage extraInfo:(nullable NSDictionary*)info;

@optional

/**
 崩溃消息，exceptionCategory，来自当前线程的额外信息
 */
- (void)crashhandleCrashException:(NSString*)exceptionMessage exceptionCategory:(TFYCrashExceptionGuardCategory)exceptionCategory extraInfo:(nullable NSDictionary*)info;

@end

@interface TFYCrashException : NSObject

/**
 如果exceptionwhterminate YES，该异常将停止应用
 如果exceptionwhterminate NO，则该异常仅在控制台上显示log，不会停止应用程序
 默认值:无
 */
@property(class,nonatomic,readwrite,assign)BOOL exceptionWhenTerminate;

/**
 TFYCrashException保护异常状态，默认为NO
 */
@property(class,nonatomic,readonly,assign)BOOL isGuardException;

/**
 配置保护例外类别，默认值:TFYCrashExceptionGuardNone
 */
+ (void)configExceptionCategory:(TFYCrashExceptionGuardCategory)exceptionGuardCategory;

/**
 启动异常protect
 */
+ (void)startGuardException;

/**
 停止异常protect
 */
+ (void)stopGuardException __attribute__((deprecated("停止调用此方法，如果调用此方法，可能会发生无限循环然后崩溃")));

/**
 注册异常接口
 */
+ (void)registerExceptionHandle:(id<TFYCrashExceptionHandle>)exceptionHandle;

@end

NS_ASSUME_NONNULL_END
