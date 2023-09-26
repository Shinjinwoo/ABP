#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "circle_blue" asset catalog image resource.
static NSString * const ACImageNameCircleBlue AC_SWIFT_PRIVATE = @"circle_blue";

/// The "circle_green" asset catalog image resource.
static NSString * const ACImageNameCircleGreen AC_SWIFT_PRIVATE = @"circle_green";

/// The "circle_outline" asset catalog image resource.
static NSString * const ACImageNameCircleOutline AC_SWIFT_PRIVATE = @"circle_outline";

/// The "circle_outline_green" asset catalog image resource.
static NSString * const ACImageNameCircleOutlineGreen AC_SWIFT_PRIVATE = @"circle_outline_green";

/// The "circle_outline_red" asset catalog image resource.
static NSString * const ACImageNameCircleOutlineRed AC_SWIFT_PRIVATE = @"circle_outline_red";

/// The "circle_outline_yellow" asset catalog image resource.
static NSString * const ACImageNameCircleOutlineYellow AC_SWIFT_PRIVATE = @"circle_outline_yellow";

/// The "circle_red" asset catalog image resource.
static NSString * const ACImageNameCircleRed AC_SWIFT_PRIVATE = @"circle_red";

/// The "circle_yellow" asset catalog image resource.
static NSString * const ACImageNameCircleYellow AC_SWIFT_PRIVATE = @"circle_yellow";

#undef AC_SWIFT_PRIVATE