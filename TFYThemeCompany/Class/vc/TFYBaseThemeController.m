//
//  TFYBaseThemeController.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/6.
//

#import "TFYBaseThemeController.h"

@interface TFYBaseThemeController ()

@end

@implementation TFYBaseThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBackground];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavigationBackground) name:TFYThemeUpdateCompletedNotification object:nil];
}

- (void)setNavigationBackground {
    UIImage *image = (UIImage *)[TFYTheme imageNamed:@"cm2_chat_bg"];
    self.view.layer.contents = (id)image.CGImage;
}

@end
