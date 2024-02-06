//
//  TFYCrashExceptionMacros.h
//  TFYCrashException
//
//  Created by 田风有 on 2023/2/24.
//

#ifndef TFYCrashExceptionMacros_h
#define TFYCrashExceptionMacros_h

#ifndef TFYCrashSYNTH_DUMMY_CLASS
#define TFYCrashSYNTH_DUMMY_CLASS(_name_) \
@interface TFYCrashSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation TFYCrashSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif

#endif /* TFYCrashExceptionMacros_h */
