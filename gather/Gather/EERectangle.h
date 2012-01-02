#import "EEShape.h"

@interface EERectangle : EEShape {
  float width_, height_;
}

@property (assign) float width, height;

- (void)updateVertices;
@end
