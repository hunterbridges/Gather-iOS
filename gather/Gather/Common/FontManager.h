#import <Foundation/Foundation.h>

@interface FontManager : NSObject {
  
}

- (UIFont *)headerFontWithSize:(CGFloat)size;
- (UIFont *)contentFontWithSize:(CGFloat)size;
- (UIFont *)alertFontWithSize:(CGFloat)size;

@property (nonatomic, readonly) NSString *headerFontName;
@property (nonatomic, readonly) NSString *contentFontName;
@property (nonatomic, readonly) NSString *alertFontName;
@end
