#import "UIColor+Gather.h"

@implementation UIColor (Gather)
+ (UIColor *)lightTextColor {
  return [UIColor colorWithWhite:0.70 alpha:1];
}

+ (UIColor *)lighterTextColor {
  return [UIColor colorWithWhite:0.80 alpha:1];
}

+ (UIColor *)darkTextColor {
  return [UIColor colorWithWhite:0.2 alpha:1.0];
}

+ (UIColor *)darkerTextColor {
  return [UIColor blackColor];
}

+ (UIColor *)lightBackgroundColor {
  return [UIColor colorWithWhite:0.95 alpha:1.0];
}

+ (UIColor *)selectionCellDeleteBackgroundColor {
  return [UIColor colorWithRed:0.6
                         green:0.15
                          blue:0.15
                         alpha:1.0];
}

+ (UIColor *)selectionCellSelectedBackgroundColor {
  return [UIColor colorWithWhite:0.05 alpha:1];
}

+ (UIColor *)selectionCellUnselectedBackgroundColor {
  return [UIColor colorWithWhite:0.10 alpha:1];
}

+ (UIColor *)whoColor {
  return [UIColor colorWithRed:0.25
                         green:0.75
                          blue:0.44
                         alpha:1];
}

+ (UIColor *)whereColor {
  // TODO: What is this color?
  return [UIColor blueColor];
}

+ (UIColor *)whenColor {
  return [UIColor colorWithRed:1.0
                         green:93.0 / 255.0
                          blue:53.0 / 255.0
                         alpha:1.0];
}

@end
