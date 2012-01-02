#import "UIColor+Gather.h"

@implementation UIColor (Gather)
+ (UIColor *)lightTextColor {
  return [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
}

+ (UIColor *)lighterTextColor {
  return [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
}

+ (UIColor *)darkTextColor {
  return [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
}

+ (UIColor *)darkerTextColor {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
}

+ (UIColor *)lightBackgroundColor {
  return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
}

+ (UIColor *)selectionCellDeleteBackgroundColor {
  return [UIColor colorWithRed:0.6
                         green:0.15
                          blue:0.15
                         alpha:1.0];
}

+ (UIColor *)selectionCellSelectedBackgroundColor {
  return [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];
}

+ (UIColor *)selectionCellUnselectedBackgroundColor {
  return [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
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

+ (UIColor *)grippiesHighlightColor {
  return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
}

+ (UIColor *)grippiesShadowColor {
  return [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
}

+ (UIColor *)grippiesInactiveBodyColor {
  return [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
}

+ (UIColor *)grippiesActiveBodyColor {
  return [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
}

// =====================================

- (CGColorSpaceModel) colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL) canProvideRGBComponents {
	return (([self colorSpaceModel] == kCGColorSpaceModelRGB) || 
          ([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

- (CGFloat) red {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat) green {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat) blue {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat) alpha {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[CGColorGetNumberOfComponents(self.CGColor)-1];
}

- (GLKVector4)GLKVector4 {
  return GLKVector4Make(self.red,
                        self.green,
                        self.blue,
                        self.alpha);
}

@end
