//
//  TFYThemePicker.h
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ThemePickerType) {
    ThemePicker_Nomal = 0,
    ThemePicker_Font,
    ThemePicker_State,
    ThemePicker_CGFloat,
    ThemePicker_CGColor,
    ThemePicker_EdgeInset,
    ThemePicker_badgePoint,
    ThemePicker_StatusBar
};

typedef id _Nonnull (^ThemePickerBlock)(void);

@interface TFYThemePicker : NSObject

@property (copy, nonatomic) ThemePickerBlock block;
@property (assign, nonatomic) ThemePickerType type;
@property (assign, nonatomic) UIControlState valueState;

#pragma mark - ThemePicker
+ (instancetype)initWithFontType:(NSString *)type;
+ (instancetype)initWithColorType:(NSString *)type;
+ (instancetype)initWithImageName:(NSString *)name;
+ (instancetype)initWithImageName:(NSString *)name tintColor:(NSString *)tintColor;
+ (instancetype)initWithImageColorType:(NSString *)type size:(CGSize)size;
+ (instancetype)initWithImageName:(NSString *)name renderingMode:(UIImageRenderingMode)mode;
+ (instancetype)initTextAttributesColorType:(NSString *)color font:(NSString *)font;

#pragma mark - ThemeStatePicker
+ (instancetype)initWithColorType:(NSString *)type forState:(UIControlState)state;
+ (instancetype)initWithImageName:(NSString *)name forState:(UIControlState)state;
+ (instancetype)initWithImageName:(NSString *)name forBarMetrics:(UIBarMetrics)state;
+ (instancetype)initWithImageWithColorType:(NSString *)type size:(CGSize)size forState:(UIControlState)state;
+ (instancetype)initTextAttributesColorType:(NSString *)color font:(NSString *)font forState:(UIControlState)state;

#pragma mark - ThemeCGColorPicker
+ (instancetype)initWithCGColor:(NSString *)type;

#pragma mark - ThemeCGFloatPicker
+ (instancetype)initWithCGFloat:(CGFloat)num;

#pragma mark - ThemeEdgeInsetPicker
+ (instancetype)initWithImageInsets:(NSString *)type;

#pragma mark - ThemeStatusBarPicker
+ (instancetype)initWithStatusBarAnimated:(BOOL)animated;

#pragma mark - ThemebadgePointPicker
+ (instancetype)initWithbadgePoint:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
