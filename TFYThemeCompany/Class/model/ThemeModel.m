//
//  ThemeModel.m
//  GoldUISSFramework
//
//  Created by vvusu on 12/29/16.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "ThemeModel.h"

@implementation ThemeitemsModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"items":ThemeModel.class};
}


@end

@implementation ThemeModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"idField" : @"id",
             @"descriptionField" : @"description"};
}

@end
