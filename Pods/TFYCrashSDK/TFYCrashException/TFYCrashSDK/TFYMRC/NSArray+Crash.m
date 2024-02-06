//
//  NSArray+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSArray+Crash.h"
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSArray_ArrayHook)

@implementation NSArray (Crash)

+ (void)tfy_crashswizzleNSArray {
    [NSArray tfy_crashswizzleClassMethod:@selector(arrayWithObject:) withSwizzleMethod:@selector(crashhookArrayWithObject:)];
    [NSArray tfy_crashswizzleClassMethod:@selector(arrayWithObjects:count:) withSwizzleMethod:@selector(crashhookArrayWithObjects:count:)];
    
    /* __NSArray0 */
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArray0") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArray0") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArray0") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
        
    /* __NSArrayI */
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
    
    /* __NSArrayI_Transfer */
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayI_Transfer") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayI_Transfer") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayI_Transfer") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
    
    /* above iOS10  __NSSingleObjectArrayI */
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSSingleObjectArrayI") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSSingleObjectArrayI") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSSingleObjectArrayI") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
    
    /* __NSFrozenArrayM */
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSFrozenArrayM") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSFrozenArrayM") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSFrozenArrayM") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
    

    /* __NSArrayReversed */
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayReversed") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayReversed") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayReversed") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
}

+ (instancetype)crashhookArrayWithObject:(id)anObject
{
    if (anObject) {
        return [self crashhookArrayWithObject:anObject];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,@"NSArray arrayWithObject object is nil");
    return nil;
}

- (id)crashhookObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self crashhookObjectAtIndex:index];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSArray objectAtIndex invalid index:%tu total:%tu",index,self.count]);
    return nil;
}
- (id)crashhookObjectAtIndexedSubscript:(NSInteger)index {
    if (index < self.count) {
        return [self crashhookObjectAtIndexedSubscript:index];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSArray objectAtIndexedSubscript invalid index:%tu total:%tu",index,self.count]);
    return nil;
}
- (NSArray *)crashhookSubarrayWithRange:(NSRange)range
{
    if (range.location + range.length <= self.count){
        return [self crashhookSubarrayWithRange:range];
    }else if (range.location < self.count){
        return [self crashhookSubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSArray subarrayWithRange invalid range location:%tu length:%tu",range.location,range.length]);
    return nil;
}
+ (instancetype)crashhookArrayWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    NSInteger index = 0;
    id objs[cnt];
    for (NSInteger i = 0; i < cnt ; ++i) {
        if (objects[i]) {
            objs[index++] = objects[i];
        }else{
            crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSArray arrayWithObjects invalid index object:%tu total:%tu",i,cnt]);
        }
    }
    return [self crashhookArrayWithObjects:objs count:index];
}


@end
