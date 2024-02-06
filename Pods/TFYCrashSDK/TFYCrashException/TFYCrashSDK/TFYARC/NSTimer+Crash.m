//
//  NSTimer+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSTimer+Crash.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"

@interface TFYCrashTimerObject : NSObject
@property(nonatomic,readwrite,assign)NSTimeInterval ti;
@property(nonatomic,readwrite,weak)id target;
@property(nonatomic,readwrite,assign)SEL selector;
@property(nonatomic,readwrite,assign)id userInfo;
@property(nonatomic,readwrite,weak)NSTimer* timer;
@property(nonatomic,readwrite,copy)NSString* targetClassName;
@property(nonatomic,readwrite,copy)NSString* targetMethodName;
@end

@implementation TFYCrashTimerObject

- (void)fireTimer{
    if (!self.target) {
        [self.timer invalidate];
        self.timer = nil;
        crashhandleCrashException(TFYCrashExceptionGuardNSTimer,[NSString stringWithFormat:@"Need invalidate timer from target:%@ method:%@",self.targetClassName,self.targetMethodName]);
        return;
    }
    if ([self.target respondsToSelector:self.selector]) {
        ((void(*)(id, SEL, NSTimer*))objc_msgSend)(self.target, self.selector, _timer);
    }
}

@end


@implementation NSTimer (Crash)

+ (void)tfy_crashswizzleNSTimer {
    [self tfy_crashswizzleClassMethod:NSTimer.class originSelector:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzleSelector:@selector(crashHookScheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
}

+ (NSTimer*)crashHookScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    if (!yesOrNo) {
        return [self crashHookScheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    TFYCrashTimerObject* timerObject = TFYCrashTimerObject.new;
    timerObject.ti = ti;
    timerObject.target = aTarget;
    timerObject.selector = aSelector;
    timerObject.userInfo = userInfo;
    if (aTarget) {
        timerObject.targetClassName = [NSString stringWithCString:object_getClassName(aTarget) encoding:NSASCIIStringEncoding];
    }
    timerObject.targetMethodName = NSStringFromSelector(aSelector);
    
    NSTimer* timer = [NSTimer crashHookScheduledTimerWithTimeInterval:ti target:timerObject selector:@selector(fireTimer) userInfo:userInfo repeats:yesOrNo];
    timerObject.timer = timer;
    
    return timer;
}

@end
