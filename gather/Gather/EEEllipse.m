#import "EEEllipse.h"

#define EE_ELLIPSE_RESOLUTION 64

@implementation EEEllipse
@synthesize radiusX = radiusX_;
@synthesize radiusY = radiusY_;

- (int)numVertices {
  return EE_ELLIPSE_RESOLUTION;
}

- (void)updateVertices {
  for (int i = 0; i < self.numVertices; i++) {
    float theta = ((float) i) / EE_ELLIPSE_RESOLUTION * M_TAU;
    self.vertices[i] = GLKVector2Make(cos(theta) * radiusX_, 
                                      sin(theta) * radiusY_);
  }
}

- (float)radiusX {
  return radiusX_;
}

- (void)setRadiusX:(float)radiusX {
  radiusX_ = radiusX;
  [self updateVertices];
}

- (float)radiusY {
  return radiusY_;
}

- (void)setRadiusY:(float)radiusY {
  radiusY_ = radiusY;
  [self updateVertices];
}

@end
