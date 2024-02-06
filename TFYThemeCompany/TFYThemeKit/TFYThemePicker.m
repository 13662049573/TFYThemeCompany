//
//  TFYThemePicker.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemePicker.h"
#import "TFYTheme.h"

@implementation TFYThemePicker
#pragma mark - Base

+ (instancetype)initWithColorType:(NSString *)type {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.block = ^() {
       return [TFYTheme colorForType:type];
    };
    return picker;
}

+ (instancetype)initWithFontType:(NSString *)type {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.type = ThemePicker_Font;
    picker.block = ^() {
        return [TFYTheme fontForType:type];
    };
    return picker;
}

+ (instancetype)initWithImageName:(NSString *)name {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.block = ^() {
       return [TFYTheme imageNamed:name];
    };
    return picker;
}

+ (instancetype)initWithImageColorType:(NSString *)type size:(CGSize)size {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.block = ^() {
        return [TFYTheme imageForColorType:type size:size];
    };
    return picker;
}

+ (instancetype)initWithImageName:(NSString *)name renderingMode:(UIImageRenderingMode)mode {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.block = ^() {
        return [[TFYTheme imageNamed:name] imageWithRenderingMode:mode];
    };
    return picker;
}

+ (instancetype)initTextAttributesColorType:(NSString *)color font:(NSString *)font {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.block = ^() {
        NSDictionary *textAttributes = @{NSFontAttributeName:[TFYTheme fontForType:font],
                                         NSForegroundColorAttributeName:[TFYTheme colorForType:color]};
        return textAttributes;
    };
    return picker;
}

#pragma mark - UIControlState

+ (instancetype)initWithColorType:(NSString *)type forState:(UIControlState)state {
    TFYThemePicker *picker = [self initWithColorType:type];
    picker.valueState = state;
    picker.type = ThemePicker_State;
    return picker;
}

+ (instancetype)initWithImageName:(NSString *)name forState:(UIControlState)state {
    TFYThemePicker *picker = [self initWithImageName:name];
    picker.valueState = state;
    picker.type = ThemePicker_State;
    return picker;
}

+ (instancetype)initWithImageName:(NSString *)name forBarMetrics:(UIBarMetrics)state {
    TFYThemePicker *picker = [self initWithImageName:name];
    picker.type = ThemePicker_State;
    picker.valueState = (NSUInteger)state;
    return picker;
}

+ (instancetype)initWithImageWithColorType:(NSString *)type size:(CGSize)size forState:(UIControlState)state {
    TFYThemePicker *picker = [self initWithImageColorType:type size:size];
    picker.valueState = state;
    picker.type = ThemePicker_State;
    return picker;
}

+ (instancetype)initTextAttributesColorType:(NSString *)color font:(NSString *)font forState:(UIControlState)state {
    TFYThemePicker *picker = [self initTextAttributesColorType:color font:font];
    picker.valueState = state;
    picker.type = ThemePicker_State;
    return picker;
}

#pragma mark - ThemeCGColorPicker

+ (instancetype)initWithCGColor:(NSString *)type {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.type = ThemePicker_CGColor;
    picker.block = ^() {
        return [TFYTheme colorForType:type];
    };
    return picker;
}

#pragma mark - ThemeCGFloatPicker

+ (instancetype)initWithCGFloat:(CGFloat)num {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.type = ThemePicker_CGFloat;
    picker.block = ^() {
        return [NSNumber numberWithFloat:num];
    };
    return picker;
}

#pragma mark - ThemeEdgeInsetPicker

+ (instancetype)initWithImageInsets:(NSString *)type {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.type = ThemePicker_EdgeInset;
    picker.block = ^() {
        return [NSValue valueWithUIEdgeInsets:[TFYTheme edgeInsetsForType:type]];
    };
    return picker;
}

#pragma mark - ThemeStatusBarPicker

+ (instancetype)initWithStatusBarAnimated:(BOOL)animated {
    TFYThemePicker *picker = [[TFYThemePicker alloc]init];
    picker.type = ThemePicker_StatusBar;
    picker.valueState = animated;
    picker.block = ^() {
        return [NSNumber numberWithFloat:0];
    };
    return picker;
}

@end
