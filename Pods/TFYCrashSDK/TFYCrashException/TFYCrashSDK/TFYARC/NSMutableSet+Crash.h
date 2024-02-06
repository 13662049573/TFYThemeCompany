//
//  NSMutableSet+Crash.h
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableSet (Crash)
+ (void)tfy_crashswizzleNSMutableSet;
@end

NS_ASSUME_NONNULL_END
