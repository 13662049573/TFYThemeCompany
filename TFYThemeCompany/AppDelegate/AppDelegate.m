//
//  AppDelegate.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "AppDelegate.h"
#import <TFY_LayoutCategoryKit.h>
#import <TFYCrashSDK.h>

#import "TFYTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /// 空数据防止闪退
    [TFYCrashException configExceptionCategory:TFYCrashExceptionGuardAll];
    [TFYCrashException startGuardException];
    
    if (!TFY_ScenePackage.isSceneApp) {
          self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
          self.window.backgroundColor = [UIColor whiteColor];
          [self.window makeKeyAndVisible];
    }
    
    [TFY_ScenePackage addBeforeWindowEvent:^(TFY_Scene * _Nonnull application) {
        application.window.rootViewController = TFYTabBarController.new;
    }];
    return YES;
}

@end
