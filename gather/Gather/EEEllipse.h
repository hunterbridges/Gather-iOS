#import "EEShape.h"

@interface EEEllipse : EEShape {
  float radiusX_, radiusY_;
}

@property (assign) float radiusX, radiusY;

- (void)updateVertices;
@end
