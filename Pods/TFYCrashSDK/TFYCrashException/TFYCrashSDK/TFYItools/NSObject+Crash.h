//
//  NSObject+Crash.h
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import <Foundation/Foundation.h>

@class TFYCrashSwizzleObject;

NS_ASSUME_NONNULL_BEGIN

typedef void (*TFYCrashSwizzleOriginalIMP)(void /* id, SEL, ... */ );

typedef id _Nullable (^TFYCrashSwizzledIMPBlock)(TFYCrashSwizzleObject* swizzleInfo);

@interface TFYCrashSwizzleObject : NSObject

- (TFYCrashSwizzleOriginalIMP)getOriginalImplementation;

@property (nonatomic,readonly,assign) SEL selector;

@end

@interface NSObject (Crash)

+ (void)tfy_crashswizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;

- (void)tfy_crashswizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;

- (void)tfy_crashswizzleInstanceMethod:(SEL)originSelector withSwizzledBlock:(TFYCrashSwizzledIMPBlock)swizzledBlock;

- (void)tfy_crashswizzleClassMethod:(Class)cls originSelector:(SEL)originSelector swizzleSelector:(SEL)swizzleSelector;

- (void)tfy_crashswizzleInstanceMethod:(Class)cls originSelector:(SEL)originSelector swizzleSelector:(SEL)swizzleSelector;

- (void)tfy_crashswizzleDeallocIfNeeded:(Class)cls;

- (void)tfy_deallocBlock:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
