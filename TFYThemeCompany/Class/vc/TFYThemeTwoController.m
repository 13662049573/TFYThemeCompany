//
//  TFYThemeTwoController.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemeTwoController.h"

@interface TFYThemeTwoController ()
@property(nonatomic , strong)UIImageView *imageViews;
@end

@implementation TFYThemeTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageViews.makeChain
    .image([UIImage imageNamed:@"cm2_msg_operbar_left"])
    .addToSuperView(self.view)
    .makeMasonry(^(MASConstraintMaker * _Nonnull make) {
        make.center.equalTo(self.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    });
    
    [self.imageViews tfy_imageWithName:@"cm2_msg_operbar_left" tintColor:@"c8"];
}

- (UIImageView *)imageViews {
    if (!_imageViews) {
        _imageViews = UIImageView.new;
        _imageViews.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageViews;
}

@end
