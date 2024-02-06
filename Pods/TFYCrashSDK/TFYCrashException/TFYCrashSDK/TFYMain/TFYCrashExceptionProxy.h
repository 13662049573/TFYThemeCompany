//
//  TFYCrashExceptionProxy.h
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/24.
//

#import <Foundation/Foundation.h>
#import "TFYCrashException.h"

NS_ASSUME_NONNULL_BEGIN

/**
 C风格调用句柄崩溃消息
 */
__attribute__((overloadable)) void crashhandleCrashException(NSString* exceptionMessage);

/**
 C风格的调用处理崩溃消息，以及额外的崩溃信息
 */
__attribute__((overloadable)) void crashhandleCrashException(NSString* exceptionMessage,NSDictionary* extraInfo);

/**
 C风格的调用处理崩溃消息，以及额外的崩溃信息
 */
__attribute__((overloadable)) void crashhandleCrashException(TFYCrashExceptionGuardCategory exceptionCategory, NSString* exceptionMessage,NSDictionary* extraInfo);

/**
 C风格的调用处理崩溃消息，以及额外的崩溃信息
 */
__attribute__((overloadable)) void crashhandleCrashException(TFYCrashExceptionGuardCategory exceptionCategory, NSString* exceptionMessage);

@interface TFYCrashExceptionProxy : NSObject<TFYCrashExceptionHandle>


+ (instancetype)shareExceptionProxy;


#pragma mark - Handle crash interface

/**
 保持TFYCrashExceptionHandle接口对象
 */
@property(nonatomic,readwrite,weak)id<TFYCrashExceptionHandle> delegate;

/**
 设置钩子期望状态，默认值为NO
 */
@property(nonatomic,readwrite,assign)BOOL isProtectException;

/**
 如果exceptionwhterminate YES，该异常将停止应用
 如果exceptionwhterminate NO，则该异常仅在控制台上显示log，不会停止应用程序
 默认值:无
 */
@property(nonatomic,readwrite,assign)BOOL exceptionWhenTerminate;

/**
 设置exceptionGuardCategory
 */
@property(nonatomic,readwrite,assign)TFYCrashExceptionGuardCategory exceptionGuardCategory;

@end

NS_ASSUME_NONNULL_END
