//
//  TFYLogTool.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/3/30.
//

#import "TFYLogTool.h"

// 存储所有用户日志的根文件夹 - 内涵所有用户文件夹
#define TFYSaveLogsDirectoryPath  [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/TFYLogs"]

// 日志数据模型
@implementation TFYLogContentModel

@end

@implementation TFYLogTool

static BOOL _writeToFile = NO;

static BOOL _forceToWirte = NO;

static LOG_LEVEL_TYPE _curLogType = LOG_LEVEL_INFO;

static NSString *_curUserId = @"DefaultUser";

static NSString *_curUserDirectoryPath = nil;

static NSMutableArray *_tempNoClearUserDirectoryNames = nil;

static NSString *_useBeginTimeDayStr = nil;

static NSMutableArray <TFYLogContentModel *>*_logContentModelsDataArr = nil;

static long long _logTimes = 0;


#pragma mark -
#pragma mark - 🔥 public Methods 🔥 公共方法

//MARK: - setWriteToFileOn: bindUserId:
+ (void)tfy_setWriteToFileOn:(BOOL)on bindUserId:(NSString *)userId {
    _writeToFile = on;
    _curUserId = (userId && userId.length) ? userId : @"DefaultUser";

    [TFYLogTool initMembers];

    [TFYLogTool createSaveDirectory];

    [TFYLogTool monitorCrashExceptionHandler];
}

//MARK: - setForceWirteToFile:
+ (void)tfy_setForceWirteToFile:(BOOL)forceToWrite {
    _forceToWirte = forceToWrite;
}

//MARK: - logWithType: file: line: function: format:
+ (void)tfy_logWithType:(LOG_LEVEL_TYPE)type file:(NSString *)file line:(NSUInteger)line function:(NSString *)function format:(NSString *)format {
    _curLogType = type;
    NSString *timeStr = [TFYLogTool getFormatTimeStr];
#if DEBUG
    if (type == LOG_LEVEL_ONLY_DEBUG_PRINT_NSLOG) {
        fprintf(stderr,"🐭『DEBUG』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
    }else if (!_forceToWirte) {
        if (type == LOG_LEVEL_INFO) {
            fprintf(stderr,"❄️『INFO』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
        }else if (type == LOG_LEVEL_WARN) {
            fprintf(stderr,"⚠️『WARN』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
        }else if (type == LOG_LEVEL_ERROR) {
            fprintf(stderr,"❌『ERROR』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
        }
    }
    
#else
#endif
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    NSString *curFmtlogStr = [TFYLogTool getFmtLogStrWithTime:timeStr file:file line:line function:function format:format];
    UIColor *fontColor = type == LOG_LEVEL_INFO ? [UIColor blackColor] : type == LOG_LEVEL_WARN ? [UIColor yellowColor] : type == LOG_LEVEL_ERROR ? [UIColor redColor] : [UIColor blackColor];
    TFYLogContentModel *model = [TFYLogContentModel new];
    model.content = curFmtlogStr;
    model.logType = type;
    model.fontColor = fontColor;
    [_logContentModelsDataArr addObject:model];
#elif TARGET_OS_MAC
    NSString *curFmtlogStr = [TFYLogTool getFmtLogStrWithTime:timeStr file:file line:line function:function format:format];
    NSColor *fontColor = type == LOG_LEVEL_INFO ? [NSColor blackColor] : type == LOG_LEVEL_WARN ? [NSColor yellowColor] : type == LOG_LEVEL_ERROR ? [NSColor redColor] : [NSColor blackColor];
    TFYLogContentModel *model = [TFYLogContentModel new];
    model.content = curFmtlogStr;
    model.logType = type;
    model.fontColor = fontColor;
    [_logContentModelsDataArr addObject:model];
#endif

    if (type == LOG_LEVEL_ONLY_DEBUG_PRINT_NSLOG) {
        return;
    }
    
    NSString *curDayStr = [[timeStr componentsSeparatedByString:@" "][0] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (![curDayStr isEqualToString:_useBeginTimeDayStr] && _useBeginTimeDayStr) {
        TFYWLogWarn(@"少年够疯狂,决战到天亮！跨夜时间:【%@->%@】", _useBeginTimeDayStr, curDayStr);
        _useBeginTimeDayStr = curDayStr;
        [_tempNoClearUserDirectoryNames removeAllObjects];
    }
    
    if (!_forceToWirte) {
#if DEBUG
#else

        if (_writeToFile) {
            [TFYLogTool writeLogWithTime:timeStr file:file line:line function:function format:format];
        }
#endif
    }else {
       
        [TFYLogTool writeLogWithTime:timeStr file:file line:line function:function format:format];
    }
}
 
//MARK: - getCurrentLogContents
+ (NSArray <TFYLogContentModel *> *)tfy_getCurrentLogContents {
    return _logContentModelsDataArr;
}



//MARK: - - - - - - - - - - 华丽的分割线 - - - - - - - - - - - - - -

#pragma mark -
#pragma mark - ⭐️ pravite methods ⭐️
//MARK: - initMembers
+ (void)initMembers {
    if (!_logContentModelsDataArr) {
        _logContentModelsDataArr = [NSMutableArray array];
    }
    if (!_tempNoClearUserDirectoryNames) {
        _tempNoClearUserDirectoryNames = [NSMutableArray array];
    }
}

//MARK: - createSaveDirectory
+ (void)createSaveDirectory {
    NSString *timeStr = [TFYLogTool getFormatTimeStr];
    _useBeginTimeDayStr = [[timeStr componentsSeparatedByString:@" "][0] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    _curUserDirectoryPath = [TFYSaveLogsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", _curUserId]];
    if (![fileManager fileExistsAtPath:_curUserDirectoryPath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:_curUserDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            TFYWLogError(@"用户存储日志文件夹路径创建失败 errorInfo: %@", error.domain);
        }else {
            TFYWLogInfo(@"用户存储日志文件夹路径创建成功!");
        }
    }
}

//MARK: - getFormatTimeStr
+ (NSString *)getFormatTimeStr {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld:%@", (long)comps.year, (long)comps.month, (long)comps.day, (long)comps.hour, (long)comps.minute, (long)comps.second, [[NSString stringWithFormat:@"%ld", (long)comps.nanosecond] substringToIndex:2]];

    return timeStr;
}

//MARK: - writeLogWithTime: file: line: function: format:
+ (void)writeLogWithTime:(NSString *)timeStr file:(NSString *)file line:(NSUInteger)line function:(NSString *)function format:(NSString *)format {
    NSString *logStr = [TFYLogTool getFmtLogStrWithTime:timeStr file:file line:line function:function format:format];
    
    NSString *dayStr = [[timeStr componentsSeparatedByString:@" "][0] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *filePath = [_curUserDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"TFYLog_%@_%@.text", _curUserId, dayStr]];
    if(![fileManager fileExistsAtPath:filePath]) {
        [logStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            TFYWLogError(@"日志信息写入文件失败 errorInfo: %@", error.domain);
        }
        
    }else {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandle seekToEndOfFile];
        NSData* stringData = [logStr dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:stringData];
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
    }
    
#if DEBUG

    if (_curLogType == LOG_LEVEL_INFO) {
        fprintf(stderr,"❄️『INFO』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
    }else if (_curLogType == LOG_LEVEL_WARN) {
        fprintf(stderr,"⚠️『WARN』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
    }else if (_curLogType == LOG_LEVEL_ERROR) {
        fprintf(stderr,"❌『ERROR』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
    }else if (_curLogType == LOG_LEVEL_ONLY_DEBUG_PRINT_NSLOG) {
        fprintf(stderr,"🐭『DEBUG』[%s] [%s:%lu] %s ●:%s\n",[timeStr UTF8String], [file UTF8String], (unsigned long)line, [function UTF8String], [format UTF8String]);
    }
#else
#endif
    

    _logTimes ++;
    if (!(_logTimes % 1000)) {// 每1000次打印，校验一回文件大小相关问题，降低频率，增加性能   => 实测 1000次大概是0.1*Mb左右
        FILE_SIZE_CHECK_LOOP: {
            
            float curFileSize = [TFYLogTool getTotalLogsSizeMb];
            if (curFileSize >= tfy_maxFoldSize) {
                FILE_EARLIEST_LOOP: {
                    
                    NSString *earliestFilePath = [TFYLogTool getEarliestLogFilePath];
                    if ([earliestFilePath isEqualToString:@"NoFilePath"]) {
                        return;
                    }
                    
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:[earliestFilePath componentsSeparatedByString:@"/"]];
                    
                    [temp removeLastObject];
                    
                    NSString *earliestUserPath = [temp componentsJoinedByString:@"/"];
                    
                    NSInteger userLogsCount = [TFYLogTool getUserPathLogsCount:earliestUserPath];
                    if (userLogsCount > tfy_forceSaveDays) {
                        if ([fileManager fileExistsAtPath:earliestFilePath]) {
                            [fileManager removeItemAtPath:earliestFilePath error:nil];
                            TFYWLogInfo(@"发现符合条件的日志文件，已清理:%@", [earliestFilePath componentsSeparatedByString:@"/"].lastObject);
                            
                            goto FILE_SIZE_CHECK_LOOP;
                        }
                        
                    }else {
                        
                        NSString *userDirectoryName = temp.lastObject;
                        
                        [_tempNoClearUserDirectoryNames addObject:userDirectoryName];
                        
                        goto FILE_EARLIEST_LOOP;
                    }
                }
            }
        }
    }
}

//MARK: - getFmtLogStrWithTime: file: line: funtion: format:
+ (NSString *)getFmtLogStrWithTime:(NSString *)timeStr file:(NSString *)file line:(NSUInteger)line function:(NSString *)function format:(NSString *)format {
    NSString *logStr;
    if (_curLogType == LOG_LEVEL_INFO) {
        logStr = [NSString stringWithFormat:@"❄️『INFO』[%@] [%@:%lu] %@ ●:%@\n", timeStr, file, (unsigned long)line, function, format];
        
    }else if (_curLogType == LOG_LEVEL_WARN) {
        logStr = [NSString stringWithFormat:@"⚠️『WARN』[%@] [%@:%lu] %@ ●:%@\n", timeStr, file, (unsigned long)line, function, format];
        
    }else if (_curLogType == LOG_LEVEL_ERROR) {
        logStr = [NSString stringWithFormat:@"❌『ERROR』[%@] [%@:%lu] %@ ●:%@\n", timeStr, file, (unsigned long)line, function, format];
        
    }
    
    return logStr;
}

//MARK: - getTotalLogsSizeMb
+ (float)getTotalLogsSizeMb {
    long long folderSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:TFYSaveLogsDirectoryPath]) {
        return 0.0;
    }
  
    NSEnumerator *logsFilesEnumerator = [[fileManager subpathsAtPath:TFYSaveLogsDirectoryPath] objectEnumerator];
   
    NSString *pathName;
    while ((pathName = [logsFilesEnumerator nextObject]) != nil) {
        if ([pathName hasSuffix:@".text"]) {
            
            NSString *logFilePath = [TFYSaveLogsDirectoryPath stringByAppendingPathComponent:pathName];
            folderSize += [TFYLogTool fileSizeAtPath:logFilePath];
        }
    }
    
    float totalSize = folderSize / (1000.0 * 1000.0);
    TFYWLogInfo(@"日志文件总大小:%lld, 折合约:%fMb", folderSize, totalSize);
    
    return totalSize;
}

//MARK: - fileSizeAtPath:
+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return 0;
}

//MARK: - getEarliestLogFilePath
+ (NSString *)getEarliestLogFilePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
  
    NSEnumerator *logsFilesEnumerator = [[fileManager subpathsAtPath:TFYSaveLogsDirectoryPath] objectEnumerator];
    
    NSString *pathName;

    int minDay = 22161231;
    NSString *earliestFilePath = @"NoFilePath";
    
    while ((pathName = [logsFilesEnumerator nextObject]) != nil) {
        if ([pathName hasSuffix:@".text"]) {
            
            NSString *userDirectoryName = [pathName componentsSeparatedByString:@"/"][0];
            if (![_tempNoClearUserDirectoryNames containsObject:userDirectoryName]) {
                
                NSString *logFilePath = [TFYSaveLogsDirectoryPath stringByAppendingPathComponent:pathName];
                int day = [[[[pathName componentsSeparatedByString:@"/"][1] componentsSeparatedByString:@"_"].lastObject componentsSeparatedByString:@"."][0] intValue];
                if (day < minDay) {
                    minDay = day;
                    earliestFilePath = logFilePath;
                }
            }
        }
    }
    
    return earliestFilePath;
}

//MARK: - getUserPathLogsCount:
+ (NSInteger)getUserPathLogsCount:(NSString *)userPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:userPath] objectEnumerator];
    return childFilesEnumerator.allObjects.count;
}

//MARK: - monitorCrashExceptionHandler
+ (void)monitorCrashExceptionHandler {
    static BOOL _hasMonitor = NO;
    if (!_hasMonitor) {
        struct sigaction newSignalAction;
        memset(&newSignalAction, 0,sizeof(newSignalAction));
        newSignalAction.sa_handler = &signalHandler;
        sigaction(SIGABRT, &newSignalAction, NULL);
        sigaction(SIGILL, &newSignalAction, NULL);
        sigaction(SIGSEGV, &newSignalAction, NULL);
        sigaction(SIGFPE, &newSignalAction, NULL);
        sigaction(SIGBUS, &newSignalAction, NULL);
        sigaction(SIGPIPE, &newSignalAction, NULL);

        NSSetUncaughtExceptionHandler(&handleExceptions);
        _hasMonitor = YES;
    }
    
}
//MARK: - signalHandler
void signalHandler(int sig) {
    TFYWLogError(@"crash signal = %d", sig);
}
//MARK: - handleExceptions
void handleExceptions(NSException *exception) {
    TFYWLogError(@"crash exception = %@",exception);
    TFYWLogError(@"crash callStackSymbols = %@",[exception callStackSymbols]);
}


@end
