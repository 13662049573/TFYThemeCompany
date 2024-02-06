//
//  TFYThemeCategory.h
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import <Foundation/Foundation.h>
#import "TFYThemePicker.h"

NS_ASSUME_NONNULL_BEGIN

// 更新完成通知
#define TFYThemeUpdateCompletedNotification @"TFYThemeUpdateCompletedNotification"

@interface NSObject (Theme)

@property (strong, nonatomic)NSMutableDictionary *tfy_themePickers;
- (void)tfy_updateFont;
- (void)tfy_updateTheme;
- (void)tfy_updateThemeCompleted;
- (void)tfy_customFontAction:(id(^)(void))block;
- (void)tfy_customThemeAction:(id(^)(void))block;
- (void)tfy_setThemePicker:(NSObject *)object selector:(NSString *)sel picker:(TFYThemePicker *)picker;

@end

@interface UIImage (Theme)
- (UIImage *)tfy_imageWiththemeTintColor:(UIColor *)tintColor;
- (UIImage *)tfy_imageWithGradientTintColor:(UIColor *)tintColor;
+ (UIImage *)tfy_imageWithName:(NSString *)name tintColor:(UIColor *)tintColor;
+ (UIImage *)tfy_imageWithName:(NSString *)name bradientTintColor:(UIColor *)tintColor;
+ (UIImage *)tfy_imageWithColor:(UIColor *)color size:(CGSize)imageSize;
@end

@interface UIColor (Theme)
+ (UIColor *)tfy_colorWithHexString:(NSString *)hexString;
@end

@interface UIFont (Theme)
+ (UIFont *)tfy_fontWithHexString:(NSString *)hexString;
@end

@interface UIApplication (Theme)
- (void)tfy_setStatusBarAnimated:(BOOL)animated;
@end

@interface UIView (Theme)
- (void)tfy_tintColor:(NSString *)type;
- (void)tfy_backgroundColor:(NSString *)type;
@end

@interface UITabBar (Theme)
- (void)tfy_bartintColor:(NSString *)type;
- (void)tfy_backgroundImageNamed:(NSString *)name;
@end

@interface UITabBarItem (Theme)
- (void)tfy_imageInsets:(NSString *)type;
- (void)tfy_imageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode;
- (void)tfy_selectedImageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode;
- (void)tfy_titleTextAttributesColorType:(NSString *)colorType font:(NSString *)fontType forState:(UIControlState)state;
@end

@interface UINavigationBar (Theme)
- (void)tfy_bartintColor:(NSString *)type;
- (void)tfy_backgroundImageNamed:(NSString *)name forBarMetrics:(UIBarMetrics)state;
- (void)tfy_titleTextAttributesColorType:(NSString *)colorType font:(NSString *)fontType;
@end

@interface UINavigationBarAppearance (Theme)
- (void)tfy_backgroundColor:(NSString *)type;
- (void)tfy_backgroundImageNamed:(NSString *)name;
- (void)tfy_titleTextAttributesColorType:(NSString *)colorType font:(NSString *)fontType;
@end

@interface UIBarButtonItem (Theme)
- (void)tfy_tintColor:(NSString *)type;
@end

@interface UILabel (Theme)
- (void)tfy_font:(NSString *)type;
- (void)tfy_textColor:(NSString *)type;
- (void)tfy_shadowColor:(NSString *)type;
- (void)tfy_highlightedTextColor:(NSString *)type;
@end

@interface UIButton (Theme)
- (void)tfy_titleFont:(NSString *)type;
- (void)tfy_titleColor:(NSString *)type forState:(UIControlState)state;
- (void)tfy_imageNamed:(NSString *)name forState:(UIControlState)state;
- (void)tfy_backgroundImageNamed:(NSString *)name forState:(UIControlState)state;
- (void)tfy_backgroundImageWithColorType:(NSString *)type size:(CGSize)size forState:(UIControlState)state;
@end

@interface UIImageView (Theme)
- (void)tfy_imageNamed:(NSString *)name;
- (void)tfy_imageWithColorType:(NSString *)type size:(CGSize)size;
@end

@interface CALayer (Theme)
- (void)tfy_borderColor:(NSString *)type;
- (void)tfy_shadowColor:(NSString *)type;
- (void)tfy_backgroundColor:(NSString *)type;
@end

@interface UITextField (Theme)
- (void)tfy_textFont:(NSString *)type;
- (void)tfy_textColor:(NSString *)type;
@end

@interface UITextView (Theme)
- (void)tfy_textFont:(NSString *)type;
- (void)tfy_textColor:(NSString *)type;
@end

@interface UISlider (Theme)
- (void)tfy_thumbTintColor:(NSString *)type;
- (void)tfy_minimumTrackTintColor:(NSString *)type;
- (void)tfy_maximumTrackTintColor:(NSString *)type;
@end

@interface UISwitch (Theme)
- (void)tfy_onTintColor:(NSString *)type;
- (void)tfy_thumbTintColor:(NSString *)type;
@end

@interface UIProgressView (Theme)
- (void)tfy_trackTintColor:(NSString *)type;
- (void)tfy_progressTintColor:(NSString *)type;
@end

@interface UIPageControl (Theme)
- (void)tfy_pageIndicatorTintColor:(NSString *)type;
- (void)tfy_currentPageIndicatorTintColor:(NSString *)type;
@end

@interface UISearchBar (Theme)
- (void)tfy_barTintColor:(NSString *)type;
@end


NS_ASSUME_NONNULL_END
