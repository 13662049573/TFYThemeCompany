//
//  TFYThemeTwoController.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemeTwoController.h"
#import <TFY_LayoutCategoryKit.h>
#import <UIImageView+WebCache.h>
#import "TFYThemeKit.h"
#import "ThemeModel.h"

@interface TFYThemeTwoController ()

@end

@implementation TFYThemeTwoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *image = (UIImage *)[TFYTheme imageNamed:@"cm2_chat_bg"];
    self.view.layer.contents = (id)image.CGImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
