#import "FontManager.h"

@implementation FontManager

- (NSString *)headerFontName {
  return @"UniversLTStd-UltraCn";
}

- (NSString *)contentFontName {
  return @"UniversLTStd-UltraCn";
}

- (NSString *)alertFontName {
  return @"Helvetica-Bold";
}

- (UIFont *)headerFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:self.headerFontName size:size];
}

- (UIFont *)contentFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:self.contentFontName size:size];
}

- (UIFont *)alertFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:self.alertFontName size:size];
}
@end
