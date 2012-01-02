#import "EERectangle.h"

@implementation EERectangle

- (int)numVertices {
  return 4;
}

- (void)updateVertices {
  self.vertices[0] = GLKVector2Make(width_ / 2.0, -height_ / 2.0);
  self.vertices[1] = GLKVector2Make(width_ / 2.0, height_ / 2.0);
  self.vertices[2] = GLKVector2Make(-width_ / 2.0, height_ / 2.0);
  self.vertices[3] = GLKVector2Make(-width_ / 2.0, -height_ / 2.0);
}

- (float)width {
  return width_;
}

- (void)setWidth:(float)width {
  width_ = width;
  [self updateVertices];
}

- (float)height {
  return height_;
}

- (void)setHeight:(float)height {
  height_ = height;
  [self updateVertices];
}

@end
