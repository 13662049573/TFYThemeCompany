//
//  TFYZipLoader.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYZipLoader.h"
#import "TFYZipArchive.h"
#import <CommonCrypto/CommonDigest.h>

void (^ZIPLogger)(NSString *log);

@implementation TFYZipLoader

+ (void)copyFilesFromDirectory:(NSString *)srcDir toDirectory:(NSString *)destDir{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* filenames = [fileMgr contentsOfDirectoryAtPath:srcDir error:nil];
    for (NSString *filename in filenames) {
        NSString* srcFilePath = [srcDir stringByAppendingPathComponent:filename];
        NSString *destFilePath = [destDir stringByAppendingPathComponent:filename];
        [[NSFileManager defaultManager] copyItemAtPath:srcFilePath toPath:destFilePath error:nil];
    }
}

+ (void)downloadFile:(NSURL *)downloadURL destination:(NSString *)destination block:(void(^)(NSError *error))callback {
    if (!downloadURL || !destination) {
        if (ZIPLogger)ZIPLogger([NSString stringWithFormat:@"ZIP: downloadURL or destination should not be nil!!"]);
        return;
    }
    
    NSString *directory = destination;
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:30.0];
    
    if (ZIPLogger)ZIPLogger([NSString stringWithFormat:@"ZIP: request file %@", downloadURL]);
    
    // create task
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            if (ZIPLogger)ZIPLogger([NSString stringWithFormat:@"ZIP: request file success, data length:%@", @(data.length)]);
            
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];

            NSString *filename = [[downloadURL absoluteString] lastPathComponent];
            NSString *downloadTmpPath = [NSString stringWithFormat:@"%@zip_%@", NSTemporaryDirectory(), filename];
            NSString *unzipTmpDirectory = [NSString stringWithFormat:@"%@unzip_%@/", NSTemporaryDirectory(), @(arc4random())];
            [data writeToFile:downloadTmpPath atomically:YES];
            
            BOOL isFnished = NO;

            NSString *originZip = [directory stringByAppendingPathComponent:filename];
            if (!isFnished) {
                TFYZipArchive *zipArchive = [[TFYZipArchive alloc] init];
                [zipArchive unzipOpenFile:downloadTmpPath];
                BOOL unzipSucc = [zipArchive unzipFileTo:unzipTmpDirectory overWrite:YES];
                if (unzipSucc) {
                    [TFYZipLoader copyFilesFromDirectory:unzipTmpDirectory toDirectory:directory];
                }else{
                    if (ZIPLogger)ZIPLogger(@"ZIP: fail to unzip script file");
                    isFnished = YES;
                    if (callback) {
                        callback([NSError errorWithDomain:@"cn.micker" code:1000 userInfo:nil]);
                    }
                }
            }
            // success
            if (!isFnished) {
                if (ZIPLogger)ZIPLogger([NSString stringWithFormat:@"ZIP: download zip [%@] file success, @ [%@]", downloadURL, originZip]);
                [data writeToFile:originZip atomically:YES];
                if (callback) callback(nil);
            }
            
            // clear temporary files
            [[NSFileManager defaultManager] removeItemAtPath:downloadTmpPath error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:unzipTmpDirectory error:nil];
        }
        else {
            if (ZIPLogger)ZIPLogger([NSString stringWithFormat:@"ZIP: request error %@", error]);
            if (callback) callback(error);
        }
    }];
    [task resume];
}

+ (NSString *)fileAtLibrary:(NSString *)path {
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *scriptDirectory = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/", path]];
    return scriptDirectory;
}

+ (void)setLogger:(void (^)(NSString *))logger {
    ZIPLogger = [logger copy];
}

@end
