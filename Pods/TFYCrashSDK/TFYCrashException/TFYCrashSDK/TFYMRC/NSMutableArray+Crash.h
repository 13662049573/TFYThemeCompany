//
//  NSMutableArray+Crash.h
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Crash)
+ (void)tfy_crashswizzleNSMutableArray;
@end

NS_ASSUME_NONNULL_END
