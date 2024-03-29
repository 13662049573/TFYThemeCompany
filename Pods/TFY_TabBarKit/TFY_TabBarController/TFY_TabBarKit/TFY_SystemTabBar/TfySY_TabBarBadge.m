//
//  TfySY_TabBarBadge.m
//  TFY_TabarController
//
//  Created by tiandengyou on 2019/11/25.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TfySY_TabBarBadge.h"

@implementation TfySY_TabBarBadge

#pragma mark - 构造
- (instancetype)init{
    self = [super init];
    if (self) {
        [self configuration];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self configuration];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configuration];
    }
    return self;
}
////////
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.layer.cornerRadius = self.frame.size.height/2.0;
}
#pragma mark - 配置实例
// 默认属性
- (void)configuration{
    self.backgroundColor = TfySY_TabBarItemBadgeRed;
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont boldSystemFontOfSize:10];
    self.textAlignment = NSTextAlignmentCenter;
    self.adjustsFontSizeToFitWidth = YES;
    self.clipsToBounds = YES;
    self.automaticHidden = YES;
    self.badgeHeight = 15;
}

- (void)setBadgeText:(NSString *)badgeText{
    _badgeText = badgeText;
    self.text = _badgeText;
    CGFloat widths = _badgeText.length*9<20?20:_badgeText.length*9;
    if ([badgeText isEqualToString:@"0"]) {
        self.hidden = self.automaticHidden;
    } else {
        self.text = _badgeText;
        if (self.badgeWidth) {
            widths = self.badgeWidth;
        }
        if (_badgeText.integerValue) { // 是数字 
            self.hidden = NO;
        } else{ //
            if (!_badgeText.length) { // 长度为0的空串
                widths = 10;
                self.badgeHeight = 10;
                self.hidden = self.automaticHidden;
            }
        }
    }
    CGRect frame = self.frame;
    frame.size.width = widths;
    frame.size.height = self.badgeHeight;
    self.frame = frame;
}

@end
