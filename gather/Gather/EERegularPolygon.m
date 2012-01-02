#import "EERegularPolygon.h"

@implementation EERegularPolygon
@synthesize numSides = numSides_;
@synthesize radius = radius_;

- (id)initWithSides:(int)numSides {
  self = [super init];
  if (self) {
    numSides_ = numSides;
  }
  return self;
}

- (int)numVertices {
  return numSides_;
}

- (void)updateVertices {
  for (int i = 0; i < numSides_; i++) {
    float theta = ((float)i) / numSides_ * M_TAU;
    self.vertices[i] = GLKVector2Make(cos(theta)* radius_,
                                      sin(theta) * radius_);
  }
}

- (float)radius {
  return radius_;
}

- (void)setRadius:(float)radius {
  radius_ = radius;
  [self updateVertices];
}
@end
