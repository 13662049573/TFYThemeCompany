//
//  NSMutableArray+Crash.m
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/27.
//

#import "NSMutableArray+Crash.h"
#import "NSObject+Crash.h"
#import "TFYCrashExceptionProxy.h"
#import "TFYCrashExceptionMacros.h"

TFYCrashSYNTH_DUMMY_CLASS(NSMutableArray_MutableArrayHook)

@implementation NSMutableArray (Crash)

+ (void)tfy_crashswizzleNSMutableArray {
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
    
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(addObject:) swizzleSelector:@selector(crashhookAddObject:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(insertObject:atIndex:) swizzleSelector:@selector(crashhookInsertObject:atIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(removeObjectAtIndex:) swizzleSelector:@selector(crashhookRemoveObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(replaceObjectAtIndex:withObject:) swizzleSelector:@selector(crashhookReplaceObjectAtIndex:withObject:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(setObject:atIndexedSubscript:) swizzleSelector:@selector(crashhookSetObject:atIndexedSubscript:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(removeObjectsInRange:) swizzleSelector:@selector(crashhookRemoveObjectsInRange:)];
    

    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(objectAtIndex:) swizzleSelector:@selector(crashhookObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(subarrayWithRange:) swizzleSelector:@selector(crashhookSubarrayWithRange:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(objectAtIndexedSubscript:) swizzleSelector:@selector(crashhookObjectAtIndexedSubscript:)];
    
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(addObject:) swizzleSelector:@selector(crashhookAddObject:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(insertObject:atIndex:) swizzleSelector:@selector(crashhookInsertObject:atIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(removeObjectAtIndex:) swizzleSelector:@selector(crashhookRemoveObjectAtIndex:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(replaceObjectAtIndex:withObject:) swizzleSelector:@selector(crashhookReplaceObjectAtIndex:withObject:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(setObject:atIndexedSubscript:) swizzleSelector:@selector(crashhookSetObject:atIndexedSubscript:)];
    [self tfy_crashswizzleInstanceMethod:NSClassFromString(@"__NSCFArray") originSelector:@selector(removeObjectsInRange:) swizzleSelector:@selector(crashhookRemoveObjectsInRange:)];
}

- (void)crashhookAddObject:(id)anObject {
    if (anObject) {
        [self crashhookAddObject:anObject];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,@"NSMutableArray addObject nil object");
    }
}
- (id)crashhookObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self crashhookObjectAtIndex:index];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray objectAtIndex invalid index:%tu total:%tu",index,self.count]);
    return nil;
}
- (id)crashhookObjectAtIndexedSubscript:(NSInteger)index {
    if (index < self.count) {
        return [self crashhookObjectAtIndexedSubscript:index];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray objectAtIndexedSubscript invalid index:%tu total:%tu",index,self.count]);
    return nil;
}
- (void)crashhookInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        [self crashhookInsertObject:anObject atIndex:index];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray insertObject invalid index:%tu total:%tu insert object:%@",index,self.count,anObject]);
    }
}

- (void)crashhookRemoveObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self crashhookRemoveObjectAtIndex:index];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray removeObjectAtIndex invalid index:%tu total:%tu",index,self.count]);
    }
}


- (void)crashhookReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count && anObject) {
        [self crashhookReplaceObjectAtIndex:index withObject:anObject];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray replaceObjectAtIndex invalid index:%tu total:%tu replace object:%@",index,self.count,anObject]);
    }
}

- (void)crashhookSetObject:(id)object atIndexedSubscript:(NSUInteger)index {
    if (index <= self.count && object) {
        [self crashhookSetObject:object atIndexedSubscript:index];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray setObject invalid object:%@ atIndexedSubscript:%tu total:%tu",object,index,self.count]);
    }
}

- (void)crashhookRemoveObjectsInRange:(NSRange)range {
    if (range.location + range.length <= self.count) {
        [self crashhookRemoveObjectsInRange:range];
    }else{
        crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray removeObjectsInRange invalid range location:%tu length:%tu",range.location,range.length]);
    }
}

- (NSArray *)crashhookSubarrayWithRange:(NSRange)range
{
    if (range.location + range.length <= self.count){
        return [self crashhookSubarrayWithRange:range];
    }else if (range.location < self.count){
        return [self crashhookSubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    crashhandleCrashException(TFYCrashExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray subarrayWithRange invalid range location:%tu length:%tu",range.location,range.length]);
    return nil;
}


@end
