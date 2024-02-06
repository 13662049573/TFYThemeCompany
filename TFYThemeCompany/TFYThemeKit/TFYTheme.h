//
//  TFYTheme.h
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFYThemeCategory.h"

NS_ASSUME_NONNULL_BEGIN

//默认主题的名称
FOUNDATION_EXPORT  NSString * const THEME_DEFAULT_NAME;

@interface TFYTheme : NSObject

+ (instancetype)instance;
/**
    当前主题Name
 */
+ (NSString *)currentTheme;

/**
    当前FontName
 */
+ (NSString *)currentFont;

/**
    沙盒中主题存储的根目录
 */
+ (NSString *)themeRootPath;
/**
    启动本地主题注册接口 适用于多Frameworks注册
    各模块需要编写TFYTheme的分类，并以‘registerTheme_’作为前缀命名
    - (void)registerTheme_Host {
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"theme_day" ofType:@"json"]
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"theme_night" ofType:@"json"]
        [[self class] addTheme:THEME_DEFAULT_NAME forPath:path1];
        [[self class] addTheme:@"day" forPath:path2];
        //如果有本地字体
        [[self class] addFont:THEME_DEFAULT_NAME forPath:path1];
    }
 */
- (void)loadLocalJsonFiles;

/**
    注册本地字体的路径，可以多次调用
    fontName 主题名字 默认主题为TFY_DEFAULT_THEME_NAME("default")
    path 目录地址
 */
+ (void)addFont:(NSString *)fontName forPath:(NSString *)path;

/**
    切换主题，初始值为default
    如果当前主题不存在，则自动切换回default
    themeName 当前主题
 */
+ (void)changeTheme:(NSString *)themeName;

/**
    注册本地主题的路径，可以多次调用
    themeName 主题名字 默认主题为DEFAULT_THEME_NAME("default")
    path 目录地址
 */
+ (void)addTheme:(NSString *)themeName forPath:(NSString *)path;

/**
    基础数据结构对象 Font
    type 名称
    UIFont
 */
+ (UIFont *)fontForType:(NSString *)type;

/**
    基础数据结构对象Image，和JSON文件同级目录或者BUNDLE
    name 名称
    UIImage
 */
+ (UIImage *)imageNamed:(NSString *)name;
+ (UIImage *)imageForColorType:(NSString *)type size:(CGSize)size;

/**
    基础数据结构对象 Color
    type 名称
    UIColor
 */
+ (UIColor *)colorForType:(NSString *)type;

/**
    除Color,Font,Image,Coorderate之外
    type 名称
    id值
 */
+ (id)otherForType:(NSString *)type;

/**
    基础数据结构对象 Coorderate
    type 名称 格式：{1,1,1,1}
    值
 */
+ (CGSize)sizeForType:(NSString *)type;
+ (CGRect)rectForType:(NSString *)type;
+ (CGPoint)pointForType:(NSString *)type;
+ (CGVector)vectorForType:(NSString *)type;
+ (UIEdgeInsets)edgeInsetsForType:(NSString *)type;
+ (CGAffineTransform)affineTransformForType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
