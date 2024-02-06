//
//  TFYTabBarController.m
//  StockTtem
//
//  Created by 田风有 on 2023/12/20.
//  Copyright © 2023 TFY. All rights reserved.
//

#import "TFYTabBarController.h"
#import "TFYThemeKit.h"

#import "TFYThemeOneController.h"
#import "TFYThemeTwoController.h"
#import "TFYThemeThreeController.h"
#import "TFYThemeFourController.h"

@interface TFYTabBarController ()

@end

@implementation TFYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavigationBackground) name:TFYThemeUpdateCompletedNotification object:nil];
    
    [self addChildViewControllers];
}

- (void)addChildViewControllers {
    
    NSArray <NSDictionary *>*VCArray =
    @[@{@"vc":TFYThemeOneController.new,@"normalImg":@"cm2_btm_icn_discovery",@"selectImg":@"cm2_btm_icn_discovery_prs",@"itemTitle":@"home"},
      @{@"vc":TFYThemeTwoController.new,@"normalImg":@"cm2_btm_icn_music",@"selectImg":@"cm2_btm_icn_music_prs",@"itemTitle":@"Discover"},
      @{@"vc":TFYThemeThreeController.new,@"normalImg":@"cm2_btm_icn_friend",@"selectImg":@"cm2_btm_icn_friend_prs",@"itemTitle":@"Stock"},
      @{@"vc":TFYThemeFourController.new,@"normalImg":@"cm2_btm_icn_account",@"selectImg":@"cm2_btm_icn_account_prs",@"itemTitle":@"Mine"}
      ];
    
    // 创建选项卡的数据 想怎么写看自己，这块我就写笨点了
    NSMutableArray *tabBarVCs = NSMutableArray.array;
    NSMutableArray *tabBarConfs = NSMutableArray.array;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TfySY_TabBarConfigModel *model = [TfySY_TabBarConfigModel new];
        model.interactionEffectStyle = TfySY_TabBarInteractionEffectStyleSpring;
        model.itemLayoutStyle = TfySY_TabBarItemLayoutStylePicture;
        
        [model tfy_imageInsets:@"NMTabBarBadgeTextViewOriginOffset"];
        [model tfy_titleTextColorType:@"ctabn" font:@"f2"];
        [model tfy_selectedtitleTextColorType:@"ctabn" font:@"f2"];
        [model tfy_imageNamed:obj[@"normalImg"] renderingMode:UIImageRenderingModeAlwaysOriginal];
        [model tfy_selectedImageNamed:obj[@"selectImg"] renderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIViewController *controller = obj[@"vc"];
        TFY_NavigationController *nav = [[TFY_NavigationController alloc] initWithRootViewController:controller];
        [tabBarVCs addObject:nav];// 5.将VC添加到系统控制组
        [tabBarConfs addObject:model];// 5.1添加构造Model到集合
    }];
    
    [self controllerArr:tabBarVCs TabBarConfigModelArr:tabBarConfs];
    [self.tfySY_TabBar tfy_backgroundImageNamed:@"cm2_btm_bg"];
}

- (void)setNavigationBackground {
    NSArray *normalImages = @[@"cm2_btm_icn_discovery",@"cm2_btm_icn_music",@"cm2_btm_icn_friend",@"cm2_btm_icn_account"];
    NSArray *prsImages = @[@"cm2_btm_icn_discovery_prs",@"cm2_btm_icn_music_prs",@"cm2_btm_icn_friend_prs",@"cm2_btm_icn_account_prs"];
    [self.tfySY_TabBar.tabBarItems enumerateObjectsUsingBlock:^(TfySY_TabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj tfy_imageInsets:@"NMTabBarBadgeTextViewOriginOffset"];
        [obj tfy_titleTextColorType:@"ctabn" font:@"f2"];
        [obj tfy_selectedtitleTextColorType:@"ctabn" font:@"f2"];
        [obj tfy_imageNamed:normalImages[idx] renderingMode:UIImageRenderingModeAlwaysOriginal];
        [obj tfy_selectedImageNamed:prsImages[idx] renderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.isSelect = !obj.isSelect;
    }];
}

@end
