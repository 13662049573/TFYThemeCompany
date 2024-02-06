//
//  TFYThemeOneCell.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemeOneCell.h"
#import <TFY_LayoutCategoryKit.h>
#import <UIImageView+WebCache.h>
#import "TFYThemeKit.h"

@interface TFYThemeOneCell ()
@property(nonatomic , strong)UIImageView *backImageView;
@property(nonatomic , strong)UILabel *nameLabel;
@property(nonatomic , strong)UIButton *botton;
@end

@implementation TFYThemeOneCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.makeChain.cornerRadius(8).masksToBounds(YES).borderColor(UIColor.blackColor.CGColor).borderWidth(1).backgroundColor(UIColor.whiteColor);
        
        [self.contentView addSubview:self.backImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(-40);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.backImageView.mas_bottom).offset(0);
        }];
    
        [self.contentView addSubview:self.botton];
        [self.botton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backImageView).offset(0);
            make.bottom.equalTo(self.backImageView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(80, 35));
        }];
   
        [self.nameLabel tfy_textColor:@"c8"];
        [self.nameLabel tfy_font:@"f6"];
        
        [self.botton tfy_titleFont:@"f10"];
        [self.botton tfy_backgroundColor:@"c7"];
        [self.botton tfy_backgroundColor:@"c8"];
    }
    return self;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = UIImageView.new;
        _backImageView.makeChain
        .userInteractionEnabled(YES)
        .contentMode(UIViewContentModeScaleAspectFit);
    }
    return _backImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.makeChain
        .font([UIFont systemFontOfSize:14 weight:UIFontWeightBold])
        .textColor(UIColor.blackColor)
        .textAlignment(NSTextAlignmentCenter)
        .numberOfLines(2);
    }
    return _nameLabel;
}

- (UIButton *)botton {
    if (!_botton) {
        _botton = UIButton.new;
        _botton.makeChain
            .text(@"使用主题", UIControlStateNormal)
            .textColor(UIColor.orangeColor, UIControlStateNormal)
            .font([UIFont systemFontOfSize:14 weight:UIFontWeightBold])
            .backgroundColor(UIColor.whiteColor)
            .cornerRadius(6)
            .masksToBounds(YES)
            .addTarget(self, @selector(buttonClick:), UIControlEventTouchUpInside);
    }
    return _botton;
}

- (void)setData:(ThemeModel *)data {
    _data = data;
    
//    NSString *picUrl = [data.thumbnail stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:data.thumbnail]];
    
    self.nameLabel.text = data.name;
}

- (void)buttonClick:(UIButton *)btn {
    if (!self.data.idField) {
        self.data.idField = [NSString stringWithFormat:@"theme_%f",[NSDate date].timeIntervalSince1970];
    }
    NSString *path = [NSString stringWithFormat:@"UserData/Skin/CurrentTheme/%@",self.data.idField];
    NSString *targetPath = [TFYZipLoader fileAtLibrary:path];
    [TFYZipLoader downloadFile:[NSURL URLWithString:self.data.downloadUrl]
                    destination:targetPath
                          block:^(NSError *error) {
                              dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [TFYTheme changeTheme:self.data.idField];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"thumbnail" object:self.data];
                                  });
                              });
                          }];
}

@end
