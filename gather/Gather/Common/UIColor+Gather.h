#import <UIKit/UIKit.h>

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
@end
