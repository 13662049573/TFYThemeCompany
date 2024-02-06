//
//  TFYZipArchive.h
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TFYZipArchiveProgressUpdateBlock)(int percentage, int filesProcessed, unsigned long numFiles);
@protocol TFYZipArchiveDelegate <NSObject>
@optional

-(void)errorMessage:(NSString*)msg;
-(BOOL)overWriteOperation:(NSString*)file;

@end

@interface TFYZipArchive : NSObject{
@private
    void*           _zipFile;
    void*           _unzFile;
    
    unsigned long   _numFiles;
    NSString*       _password;
    __weak id       _delegate;
    TFYZipArchiveProgressUpdateBlock _progressBlock;
    
    NSArray*    _unzippedFiles;
    
    NSFileManager* _fileManager;
    NSStringEncoding _stringEncoding;
}

/** a delegate object conforming to ZipArchiveDelegate protocol */
@property (nonatomic, weak) id<TFYZipArchiveDelegate> delegate;
@property (nonatomic, readonly) unsigned long numFiles;
@property (nonatomic, copy) TFYZipArchiveProgressUpdateBlock progressBlock;

@property (nonatomic, assign) NSStringEncoding stringEncoding;

/** an array of files that were successfully expanded. Available after calling UnzipFileTo:overWrite: */
@property (nonatomic, readonly,strong) NSArray *unzippedFiles;

-(id)initWithFileManager:(NSFileManager*)fileManager;

-(BOOL)createZipFile2:(NSString*)zipFile;
-(BOOL)createZipFile2:(NSString*)zipFile Password:(NSString*)password;
-(BOOL)addFileToZip:(NSString*)file newname:(NSString*)newname;
-(BOOL)closeZipFile2;

-(BOOL)unzipOpenFile:(NSString*)zipFile;
-(BOOL)unzipOpenFile:(NSString*)zipFile Password:(NSString*)password;
-(BOOL)unzipFileTo:(NSString*)path overWrite:(BOOL)overwrite;
-(BOOL)unzipCloseFile;
-(NSArray*)getZipFileContents;     // list the contents of the zip archive. must be called after UnzipOpenFile

@end

NS_ASSUME_NONNULL_END
