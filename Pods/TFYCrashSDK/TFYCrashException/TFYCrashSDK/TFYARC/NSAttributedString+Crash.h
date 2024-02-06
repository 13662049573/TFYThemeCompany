//
//  NSAttributedString+Crash.h
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Crash)
+ (void)tfy_crashswizzleNSAttributedString;
@end

NS_ASSUME_NONNULL_END
