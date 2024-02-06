//
//  TFYThemeFourController.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemeFourController.h"
#import "TFYThemeKit.h"

@interface TFYThemeFourController ()

@end

@implementation TFYThemeFourController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *image = (UIImage *)[TFYTheme imageNamed:@"cm2_chat_bg"];
    self.view.layer.contents = (id)image.CGImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
