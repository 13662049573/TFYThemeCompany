# TFYCrashException
完成接口项目闪退问题，后期持续更新
保护App,一般常见的问题不会导致闪退，增强App的健壮性，同时会将错误抛出来，根据每个App自身的日志渠道记录，下次迭代或者热修复以下问题.

 Unrecognized Selector Sent to Instance(方法不存在异常)

 NSNull(方法不存在异常)

 NSArray,NSMutableArray,NSDictonary,NSMutableDictionary(数组越界,key-value参数异常)

 KVO(忘记移除keypath导致闪退)

 NSTimer(忘记移除导致内存泄漏)

 NSNotification(忘记移除导致异常)

 NSString,NSMutableString,NSAttributedString,NSMutableAttributedString(下标越界以及参数nil异常)

pod 'TFYCrashSDK'

设置异常类型并开启，建议放在didFinishLaunchingWithOptions第一行，以免在多线程出现异常的情况
[TFYCrashException configExceptionCategory:TFYCrashExceptionGuardAll];
[TFYCrashException startGuardException];

导入Source文件夹里所有文件，需要将TFYMRC目录下所有.m文件，编译选项更改成-fno-objc-arc

当异常时，默认程序不会中断，如果需要遇到异常时退出，需要如下设置:
    //Default value:NO
    TFYCrashException.exceptionWhenTerminate = YES;
    
如果需要记录日志，只需要实现TFYCrashExceptionHandle协议，并注册:

@interface ViewController ()<TFYCrashExceptionHandle>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TFYCrashException registerExceptionHandle:self];
}

- (void)handleCrashException:(NSString*)exceptionMessage exceptionCategory:(TFYCrashExceptionGuardCategory)exceptionCategory extraInfo:(nullable NSDictionary*)info{

}
