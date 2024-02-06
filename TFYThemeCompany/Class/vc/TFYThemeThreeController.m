//
//  TFYThemeThreeController.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemeThreeController.h"
#import "TFYThemeKit.h"
@interface TFYThemeThreeController ()

@end

@implementation TFYThemeThreeController

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
