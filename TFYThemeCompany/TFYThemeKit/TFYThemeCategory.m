//
//  TFYThemeCategory.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemeCategory.h"
#import <objc/runtime.h>

static BOOL isChangeTheme;
static void *Theme_ThemeMap;
static NSPointerArray *themeHashTable;

@implementation NSObject (Theme)

- (NSPointerArray *)themeHashTable {
    if (!themeHashTable) {
        themeHashTable = [NSPointerArray weakObjectsPointerArray];
    }
    return themeHashTable;
}

- (NSMutableDictionary *)tfy_themePickers {
    NSMutableDictionary *themeMap = objc_getAssociatedObject(self, &Theme_ThemeMap);
    if (themeMap) {
        return themeMap;
    } else {
        themeMap = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &Theme_ThemeMap, themeMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return themeMap;
    }
}

- (void)setTfy_themePickers:(NSMutableDictionary *)tfy_themePickers {
    objc_setAssociatedObject(self, &Theme_ThemeMap, tfy_themePickers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tfy_themePickers && !isChangeTheme) {
        [self.themeHashTable addPointer:(__bridge void * _Nullable)(self)];
    }
}

//添加标识设置属性
- (void)tfy_setThemePicker:(NSObject *)object selector:(NSString *)sel picker:(TFYThemePicker *)picker {
    NSMutableArray *pickers = [object.tfy_themePickers valueForKey:sel];
    if (!pickers) { pickers = [NSMutableArray array]; }
    [pickers addObject:picker];
    [object.tfy_themePickers setValue:pickers forKey:sel];
    [object tfy_performThemePicker:sel picker:picker];
    //hastable添加会自动去重
    if (!isChangeTheme) {
        [self.themeHashTable addPointer:(__bridge void * _Nullable)(object)];
    }
}

//更新主题
- (void)tfy_updateTheme {
    if (isChangeTheme) { return; }
    isChangeTheme = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    NSArray *objects = [self.themeHashTable allObjects];
    for (NSObject *object in [objects reverseObjectEnumerator]) {
        dispatch_group_async(dispatchGroup, queue, ^{
            if (object) {
                [object.tfy_themePickers enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableArray *pickers, BOOL *stop) {
                    [pickers enumerateObjectsUsingBlock:^(TFYThemePicker* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.type != ThemePicker_Font) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [object tfy_performThemePicker:key picker:obj];
                            });
                        }
                    }];
                }];
            }
        });
    }
    __weak typeof(self) wself= self;
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        isChangeTheme = NO;
        [wself tfy_updateThemeCompleted];
    });
}

//更新字体
- (void)tfy_updateFont {
    if (isChangeTheme) { return; }
    isChangeTheme = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    NSArray *objects = [self.themeHashTable allObjects];
    for (NSObject *object in [objects reverseObjectEnumerator]) {
        dispatch_group_async(dispatchGroup, queue, ^{
            if (object) {
                [object.tfy_themePickers enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableArray *pickers, BOOL *stop) {
                    [pickers enumerateObjectsUsingBlock:^(TFYThemePicker* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.type == ThemePicker_Font) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [object tfy_performThemePicker:key picker:obj];
                            });
                        }
                    }];
                }];
            }
        });
    }
    __weak typeof(self) wself= self;
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        isChangeTheme = NO;
        [wself tfy_updateThemeCompleted];
    });
}

//解析，动态设置属性
- (void)tfy_performThemePicker:(NSString *)selStr picker:(TFYThemePicker *)picker {
    SEL selector = NSSelectorFromString(selStr);
    //判断有没有方法
    if (![self respondsToSelector:selector]) { return; }
    id value = picker.block();
    if (!value) { return; }
    IMP imp = [self methodForSelector:selector];

    //调用方法
    switch (picker.type) {
        case ThemePicker_Nomal:
        case ThemePicker_Font: {
            void (*func)(id, SEL, id) = (void *)imp;
            func(self, selector, value);
        }
            break;
        case ThemePicker_State: {
            void (*func)(id, SEL, id, UIControlState) = (void *)imp;
            func(self, selector, value, picker.valueState);
        }
            break;
        case ThemePicker_CGColor: {
            void (*func)(id, SEL, CGColorRef) = (void *)imp;
            CGColorRef color = ((UIColor *)value).CGColor;
            func(self, selector, color);
        }
            break;
        case ThemePicker_CGFloat: {
            void (*func)(id, SEL, CGFloat) = (void *)imp;
            NSNumber *num = value;
            func(self, selector, num.floatValue);
        }
            break;
        case ThemePicker_EdgeInset: {
            void (*func)(id, SEL, UIEdgeInsets) = (void *)imp;
            NSValue *empty = value;
            func(self, selector, empty.UIEdgeInsetsValue);
        }
            break;
        case ThemePicker_badgePoint: {
            void (*func)(id, SEL, CGPoint) = (void *)imp;
            NSValue *empty = value;
            func(self, selector, empty.CGPointValue);
        }
            break;
        case ThemePicker_StatusBar: {
            void (*func)(id, SEL, UIStatusBarStyle, BOOL) = (void *)imp;
            NSNumber *num = value;
            UIStatusBarStyle style = num.integerValue;
            func(self, selector, style, picker.valueState);
        }
            break;
    }
}

//自定义主题事件只是为了注册方法
- (void)tfy_customThemeInternalAction {}

- (void)tfy_customThemeAction:(id(^)(void))block {
    TFYThemePicker *picker = [[TFYThemePicker alloc] init];
    picker.type = ThemePicker_Nomal;
    picker.block = block;
    [self tfy_setThemePicker:self selector:@"tfy_customThemeInternalAction" picker:picker];
}

//自定义Font触发事件
- (void)tfy_customFontInternalAction {}

- (void)tfy_customFontAction:(id(^)(void))block {
    TFYThemePicker *picker = [[TFYThemePicker alloc] init];
    picker.type = ThemePicker_Font;
    picker.block = block;
    [self tfy_setThemePicker:self selector:@"tfy_customFontInternalAction" picker:picker];
}

// 更新主题成功
- (void)tfy_updateThemeCompleted {
    [[NSNotificationCenter defaultCenter] postNotificationName:TFYThemeUpdateCompletedNotification object:nil userInfo:nil];
}

@end

@implementation UIImage (Theme)

+ (UIImage *)tfy_imageWithName:(NSString *)name tintColor:(UIColor *)tintColor {
    UIImage *image = [UIImage imageNamed:name];
    if (image) {
        return [image tfy_imageWiththemeTintColor:tintColor];
    } else {
        return image;
    }
}

+ (UIImage *)tfy_imageWithName:(NSString *)name bradientTintColor:(UIColor *)tintColor {
    UIImage *image = [UIImage imageNamed:name];
    if (image) {
        return [image tfy_imageWithGradientTintColor:tintColor];
    } else {
        return image;
    }
}

- (UIImage *)tfy_imageWiththemeTintColor:(UIColor *)tintColor {
    return [self tfy_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)tfy_imageWithGradientTintColor:(UIColor *)tintColor {
    return [self tfy_imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)tfy_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage *)tfy_imageWithColor:(UIColor *)color size:(CGSize)imageSize {
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIColor (Theme)

+ (UIColor *)tfy_colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self tfy_colorComponentFrom: colorString start: 0 length: 1];
            green = [self tfy_colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self tfy_colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self tfy_colorComponentFrom: colorString start: 0 length: 1];
            red   = [self tfy_colorComponentFrom: colorString start: 1 length: 1];
            green = [self tfy_colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self tfy_colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self tfy_colorComponentFrom: colorString start: 0 length: 2];
            green = [self tfy_colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self tfy_colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self tfy_colorComponentFrom: colorString start: 0 length: 2];
            red   = [self tfy_colorComponentFrom: colorString start: 2 length: 2];
            green = [self tfy_colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self tfy_colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)tfy_colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end

@implementation UIFont (Theme)

+ (UIFont *)tfy_fontWithHexString:(NSString *)hexString {
    NSArray *array = [hexString componentsSeparatedByString:@","];
    if (array.count == 1) {
        NSString *fontSize = array.firstObject;
        return [UIFont systemFontOfSize:fontSize.floatValue];
    }
    else if (array.count == 2) {
        NSString *fontName = array.firstObject;
        CGFloat fontSize = ((NSString *)array.lastObject).floatValue;
        UIFont *defaultFont = [UIFont systemFontOfSize:fontSize];
        
        if ([[fontName lowercaseString] isEqualToString:@"b"]) {
            return [UIFont boldSystemFontOfSize:fontSize];
        }
        else if ([[fontName lowercaseString] isEqualToString:@"i"]) {
            return [UIFont italicSystemFontOfSize:fontSize];
        }
        else if ([fontName hasPrefix:@"sw"]) {
            if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.2) {
                NSString *fontWeight = [fontName substringWithRange:NSMakeRange(2, 1)];
                return [UIFont systemFontOfSize:fontSize weight:[UIFont tfy_weightFromString:fontWeight]];
            }
            else {
                return defaultFont;
            }
        }
        else if ([fontName hasPrefix:@"smw"]) {
            if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
                NSString *fontWeight = [fontName substringWithRange:NSMakeRange(3, 1)];
                return [UIFont monospacedDigitSystemFontOfSize:fontSize weight:[UIFont tfy_weightFromString:fontWeight]];
            }
            else {
                return defaultFont;
            }
        }
        else {
            return [UIFont fontWithName:fontName size:fontSize];
        }
    }
    else {
        return [UIFont systemFontOfSize:hexString.floatValue];
    }
}

+ (CGFloat)tfy_weightFromString:(NSString *)string {
    if ([string isEqualToString:@"u"]) {
        return UIFontWeightUltraLight;
    }
    else if ([string isEqualToString:@"t"]) {
        return UIFontWeightThin;
    }
    else if ([string isEqualToString:@"l"]) {
        return UIFontWeightLight;
    }
    else if ([string isEqualToString:@"r"]) {
        return UIFontWeightRegular;
    }
    else if ([string isEqualToString:@"m"]) {
        return UIFontWeightMedium;
    }
    else if ([string isEqualToString:@"s"]) {
        return UIFontWeightSemibold;
    }
    else if ([string isEqualToString:@"B"]) {
        return UIFontWeightBold;
    }
    else if ([string isEqualToString:@"h"]) {
        return UIFontWeightHeavy;
    }
    else if ([string isEqualToString:@"b"]) {
        return UIFontWeightBlack;
    } else {
        return UIFontWeightUltraLight;
    }
}

@end

@implementation UIApplication (Theme)
- (void)tfy_setStatusBarAnimated:(BOOL)animated {
    [self tfy_setThemePicker:self selector:@"setStatusBarStyle:animated:"
                  picker:[TFYThemePicker initWithStatusBarAnimated:animated]];
}
@end

@implementation UIView (Theme)

- (void)tfy_tintColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_backgroundColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setBackgroundColor:" picker:[TFYThemePicker initWithColorType:type]];
}

@end

@implementation UITabBar (Theme)

- (void)tfy_bartintColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setBarTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_backgroundImageNamed:(NSString *)name {
    [self tfy_setThemePicker:self selector:@"setBackgroundImage:" picker:[TFYThemePicker initWithImageName:name]];
}
@end

@implementation UITabBarItem (Theme)

- (void)tfy_imageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode {
    [self tfy_setThemePicker:self selector:@"setImage:"
                  picker:[TFYThemePicker initWithImageName:name renderingMode:mode]];
}

- (void)tfy_selectedImageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode {
    [self tfy_setThemePicker:self selector:@"setSelectedImage:"
                  picker:[TFYThemePicker initWithImageName:name renderingMode:mode]];
}

- (void)tfy_imageInsets:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setImageInsets:"
                  picker:[TFYThemePicker initWithImageInsets:type]];
}

- (void)tfy_titleTextAttributesColorType:(NSString *)colorType font:(NSString *)fontType forState:(UIControlState)state {
    [self tfy_setThemePicker:self selector:@"setTitleTextAttributes:forState:"
                  picker:[TFYThemePicker initTextAttributesColorType:colorType font:fontType forState:state]];
}
@end

@implementation UINavigationBar (Theme)

- (void)tfy_bartintColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setBarTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}


- (void)tfy_titleTextAttributesColorType:(NSString *)colorType font:(NSString *)fontType {
    [self tfy_setThemePicker:self selector:@"setTitleTextAttributes:"
                  picker:[TFYThemePicker initTextAttributesColorType:colorType font:fontType]];
}

- (void)tfy_backgroundImageNamed:(NSString *)name forBarMetrics:(UIBarMetrics)state {
     [self tfy_setThemePicker:self selector:@"setBackgroundImage:forBarMetrics:"
                   picker:[TFYThemePicker initWithImageName:name forBarMetrics:state]];
}

@end

@implementation UINavigationBarAppearance (Theme)

- (void)tfy_backgroundColor:(NSString *)type {
  [self tfy_setThemePicker:self selector:@"setBackgroundColor:" picker:[TFYThemePicker initWithCGColor:type]];
}

- (void)tfy_backgroundImageNamed:(NSString *)name {
    [self tfy_setThemePicker:self selector:@"setBackgroundImage:" picker:[TFYThemePicker initWithImageName:name]];
}

- (void)tfy_titleTextAttributesColorType:(NSString *)colorType font:(NSString *)fontType {
    [self tfy_setThemePicker:self selector:@"setTitleTextAttributes:"
                  picker:[TFYThemePicker initTextAttributesColorType:colorType font:fontType]];
}

@end

@implementation UIBarButtonItem (Theme)
- (void)tfy_tintColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

@implementation UILabel (Theme)

- (void)tfy_font:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setFont:" picker:[TFYThemePicker initWithFontType:type]];
}

- (void)tfy_textColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setTextColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_shadowColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setShadowColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_highlightedTextColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setHighlightedTextColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

@implementation UIButton (Theme)

- (void)tfy_titleFont:(NSString *)type {
    [self tfy_setThemePicker:self.titleLabel selector:@"setFont:" picker:[TFYThemePicker initWithFontType:type]];
}

- (void)tfy_imageNamed:(NSString *)name forState:(UIControlState)state {
    [self tfy_setThemePicker:self selector:@"setImage:forState:"
                  picker:[TFYThemePicker initWithImageName:name forState:(UIControlState)state]];
}

- (void)tfy_backgroundImageNamed:(NSString *)name forState:(UIControlState)state {
    [self tfy_setThemePicker:self selector:@"setBackgroundImage:forState:"
                  picker:[TFYThemePicker initWithImageName:name forState:(UIControlState)state]];
}

- (void)tfy_backgroundImageWithColorType:(NSString *)type size:(CGSize)size forState:(UIControlState)state {
    [self tfy_setThemePicker:self selector:@"setBackgroundImage:forState:"
                  picker:[TFYThemePicker initWithImageWithColorType:type size:size forState:(UIControlState)state]];
}

- (void)tfy_titleColor:(NSString *)type forState:(UIControlState)state {
    [self tfy_setThemePicker:self selector:@"setTitleColor:forState:"
                  picker:[TFYThemePicker initWithColorType:type forState:state]];
}
@end

@implementation UIImageView (Theme)

- (void)tfy_imageNamed:(NSString *)name {
    [self tfy_setThemePicker:self selector:@"setImage:" picker:[TFYThemePicker initWithImageName:name]];
}

- (void)tfy_imageWithColorType:(NSString *)type size:(CGSize)size {
    [self tfy_setThemePicker:self selector:@"setImage:" picker:[TFYThemePicker initWithImageColorType:type size:size]];
}

- (void)tfy_imageWithName:(NSString *)name tintColor:(NSString *)tintColor {
    [self tfy_setThemePicker:self selector:@"setImage:" picker:[TFYThemePicker initWithImageName:name tintColor:tintColor]];
}

@end

@implementation CALayer (Theme)

- (void)tfy_borderColor:(NSString *)type {
  [self tfy_setThemePicker:self selector:@"setBorderColor:" picker:[TFYThemePicker initWithCGColor:type]];
}

- (void)tfy_shadowColor:(NSString *)type {
  [self tfy_setThemePicker:self selector:@"setShadowColor:" picker:[TFYThemePicker initWithCGColor:type]];
}

- (void)tfy_backgroundColor:(NSString *)type {
  [self tfy_setThemePicker:self selector:@"setBackgroundColor:" picker:[TFYThemePicker initWithCGColor:type]];
}

@end

@implementation UITextField (Theme)

- (void)tfy_textFont:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setFont:" picker:[TFYThemePicker initWithFontType:type]];
}

- (void)tfy_textColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setTextColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

@implementation UITextView (Theme)

- (void)tfy_textFont:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setFont:" picker:[TFYThemePicker initWithFontType:type]];
}

- (void)tfy_textColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setTextColor:" picker:[TFYThemePicker initWithColorType:type]];
}

@end

@implementation UISlider (Theme)
- (void)tfy_thumbTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setThumbTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_minimumTrackTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setMinimumTrackTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_maximumTrackTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setMaximumTrackTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

@implementation UISwitch (Theme)
- (void)tfy_onTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setOnTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_thumbTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setThumbTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

@implementation UIProgressView (Theme)

- (void)tfy_trackTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setTrackTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}

- (void)tfy_progressTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setProgressTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

@implementation UIPageControl (Theme)
- (void)tfy_pageIndicatorTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setPageIndicatorTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}
    
- (void)tfy_currentPageIndicatorTintColor:(NSString *)type {
   [self tfy_setThemePicker:self selector:@"setCurrentPageIndicatorTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

@implementation UISearchBar (Theme)
- (void)tfy_barTintColor:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setBarTintColor:" picker:[TFYThemePicker initWithColorType:type]];
}
@end

#if HasTFYNavKit
@implementation TFYContainerNavigationController (navTheme)
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavigationBackground) name:TFYThemeUpdateCompletedNotification object:nil];
    [self setNavigationBackground];
}
/// 设置导航栏颜色
-(void)setNavigationBackground {
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor blackColor],
                              NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]};
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundEffect = nil;// 去掉半透明效果
        appearance.titleTextAttributes = dic;// 标题字体颜色及大小
        appearance.shadowImage = UIImage.new;// 设置导航栏下边界分割线透明
        appearance.shadowColor = [UIColor clearColor];// 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
        [appearance tfy_titleTextAttributesColorType:@"ctabh" font:@"f4"];
        [appearance tfy_backgroundImageNamed:@"cm2_topbar_bg"];
        
        self.navigationBar.standardAppearance = appearance;// standardAppearance：常规状态, 标准外观，iOS15之后不设置的时候，导航栏背景透明
        if (@available(iOS 15.0, *)) {
         self.navigationBar.scrollEdgeAppearance = appearance;// scrollEdgeAppearance：被scrollview向下拉的状态, 滚动时外观，不设置的时候，使用标准外观
        }
    } else {
        self.navigationBar.titleTextAttributes = dic;
        [self.navigationBar setShadowImage:UIImage.new];
        [self.navigationBar tfy_backgroundImageNamed:@"cm2_topbar_bg" forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar tfy_titleTextAttributesColorType:@"ctabh" font:@"f4"];
    }
}
@end
#endif

#if HasTFYTabbarKit
@implementation TfySY_TabBar (tabbarTheme)
- (void)tfy_backgroundImageNamed:(NSString *)name {
    [self tfy_setThemePicker:self selector:@"setThemeImage:" picker:[TFYThemePicker initWithImageName:name]];
}
@end
@implementation TfySY_TabBarConfigModel (tabbarTheme)
- (void)tfy_imageInsets:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setComponentMargin:"
                  picker:[TFYThemePicker initWithImageInsets:type]];
}

- (void)tfy_badgePoint:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setBadgePoint:"
                  picker:[TFYThemePicker initWithbadgePoint:type]];
}

- (void)tfy_imageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode {
    [self tfy_setThemePicker:self selector:@"setNormalImage:"
                  picker:[TFYThemePicker initWithImageName:name renderingMode:mode]];
}

- (void)tfy_selectedImageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode {
    [self tfy_setThemePicker:self selector:@"setSelectImage:"
                  picker:[TFYThemePicker initWithImageName:name renderingMode:mode]];
}

- (void)tfy_titleTextColorType:(NSString *)colorType {
    [self tfy_setThemePicker:self selector:@"setNormalColor:"
                  picker:[TFYThemePicker initWithColorType:colorType forState:UIControlStateNormal]];
}

- (void)tfy_selectedtitleTextColorType:(NSString *)colorType {
    [self tfy_setThemePicker:self selector:@"setSelectColor:"
                  picker:[TFYThemePicker initWithColorType:colorType forState:UIControlStateSelected]];
}
@end
@implementation TfySY_TabBarItem (tabbarTheme)
- (void)tfy_imageInsets:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setComponentMargin:"
                  picker:[TFYThemePicker initWithImageInsets:type]];
}

- (void)tfy_badgePoint:(NSString *)type {
    [self tfy_setThemePicker:self selector:@"setBadgePoint:"
                  picker:[TFYThemePicker initWithbadgePoint:type]];
}

- (void)tfy_imageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode {
    [self tfy_setThemePicker:self selector:@"setNormalImage:"
                  picker:[TFYThemePicker initWithImageName:name renderingMode:mode]];
}

- (void)tfy_selectedImageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)mode {
    [self tfy_setThemePicker:self selector:@"setSelectImage:"
                  picker:[TFYThemePicker initWithImageName:name renderingMode:mode]];
}

- (void)tfy_titleTextColorType:(NSString *)colorType {
    [self tfy_setThemePicker:self selector:@"setNormalColor:"
                  picker:[TFYThemePicker initWithColorType:colorType forState:UIControlStateNormal]];
}

- (void)tfy_selectedtitleTextColorType:(NSString *)colorType {
    [self tfy_setThemePicker:self selector:@"setSelectColor:"
                  picker:[TFYThemePicker initWithColorType:colorType forState:UIControlStateSelected]];
}
@end
#endif
