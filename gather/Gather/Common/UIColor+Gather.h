#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface UIColor (Gather)
// General colors
+ (UIColor *)lightTextColor;
+ (UIColor *)lighterTextColor;
+ (UIColor *)darkTextColor;
+ (UIColor *)darkerTextColor;
+ (UIColor *)lightBackgroundColor;

// Colors for specific UI elements
+ (UIColor *)selectionCellDeleteBackgroundColor;
+ (UIColor *)selectionCellSelectedBackgroundColor;
+ (UIColor *)selectionCellUnselectedBackgroundColor;

// Thematic colors
+ (UIColor *)whoColor;
+ (UIColor *)whereColor;
+ (UIColor *)whenColor;

// Grippies colors
+ (UIColor *)grippiesHighlightColor;
+ (UIColor *)grippiesShadowColor;
+ (UIColor *)grippiesInactiveBodyColor;
+ (UIColor *)grippiesActiveBodyColor;

- (CGColorSpaceModel) colorSpaceModel;
- (BOOL) canProvideRGBComponents;
- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) alpha;

@property (readonly) GLKVector4 GLKVector4;
@end
