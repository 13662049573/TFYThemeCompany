//
//  TFYZipLoader.h
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFYZipLoader : NSObject

+ (void)downloadFile:(NSURL *)downloadURL destination:(NSString *)destination block:(void(^)(NSError *error))callback;

+ (void)setLogger:(void(^)(NSString *log))logger;

+ (NSString *)fileAtLibrary:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
