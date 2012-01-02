#import "EEAnimation.h"

@implementation EEAnimation
@synthesize duration = duration_;
@synthesize elapsedTime = elapsedTime_;
@synthesize rotationDelta = rotationDelta_;
@synthesize positionDelta = positionDelta_;
@synthesize scaleDelta = scaleDelta_;
@synthesize colorDelta = colorDelta_;
@synthesize projectionMatrixDelta = projectionMatrixDelta_;

- (id)init {
  self = [super init];
  if (self) {
    elapsedTime_ = 0;
    duration_ = 0;
    
    rotationDelta_ = 0;
    positionDelta_ = GLKVector2Make(0, 0);
    colorDelta_ = GLKVector4Make(0, 0, 0, 0);
    
    projectionMatrixDelta_ = GLKMatrix4Identity;
  }
  return self;
}

- (void)animateShape:(EEShape *)shape dt:(NSTimeInterval)dt {
  elapsedTime_ += dt;
  if (elapsedTime_ > duration_) {
    dt -= elapsedTime_ - duration_;
  }
  float fractionOfDuration = dt / duration_;
  GLKVector2 positionIncrement = GLKVector2MultiplyScalar(positionDelta_,
                                                          fractionOfDuration);
  shape.position = GLKVector2Add(shape.position, positionIncrement);
  
  GLKVector4 colorIncrement = GLKVector4MultiplyScalar(colorDelta_,
                                                       fractionOfDuration);
  shape.color = GLKVector4Add(shape.color, colorIncrement);
  
  GLKVector2 scaleIncrement = GLKVector2MultiplyScalar(scaleDelta_,
                                                       fractionOfDuration);
  shape.scale = GLKVector2Add(shape.scale, scaleIncrement);
  
  float rotationIncrement = rotationDelta_ * fractionOfDuration;
  shape.rotation += rotationIncrement;
}

- (void)animateScene:(EEScene *)scene dt:(NSTimeInterval)dt {
  elapsedTime_ += dt;
  if (elapsedTime_ > duration_) {
    dt -= elapsedTime_ - duration_;
  }
  float fractionOfDuration = dt / duration_;
  NSLog(@"Delta: %@", NSStringFromGLKMatrix4(projectionMatrixDelta_));
  
  GLKMatrix4 projectionIncrement =
      GLKMatrix4Make(projectionMatrixDelta_.m00 * fractionOfDuration,
                     projectionMatrixDelta_.m01 * fractionOfDuration,
                     projectionMatrixDelta_.m02 * fractionOfDuration,
                     projectionMatrixDelta_.m03 * fractionOfDuration,
                     projectionMatrixDelta_.m10 * fractionOfDuration,
                     projectionMatrixDelta_.m11 * fractionOfDuration, 
                     projectionMatrixDelta_.m12 * fractionOfDuration, 
                     projectionMatrixDelta_.m13 * fractionOfDuration, 
                     projectionMatrixDelta_.m20 * fractionOfDuration, 
                     projectionMatrixDelta_.m21 * fractionOfDuration, 
                     projectionMatrixDelta_.m22 * fractionOfDuration, 
                     projectionMatrixDelta_.m23 * fractionOfDuration, 
                     projectionMatrixDelta_.m30 * fractionOfDuration, 
                     projectionMatrixDelta_.m31 * fractionOfDuration, 
                     projectionMatrixDelta_.m32 * fractionOfDuration, 
                     projectionMatrixDelta_.m33 * fractionOfDuration);
  
  NSLog(@"Increment: %@", NSStringFromGLKMatrix4(projectionIncrement));
  NSLog(@"Before: %@", NSStringFromGLKMatrix4(scene.projectionMatrix));
  
  scene.projectionMatrix = GLKMatrix4Add(projectionIncrement,
                                         scene.projectionMatrix);
  
  NSLog(@"After: %@", NSStringFromGLKMatrix4(scene.projectionMatrix));
}
@end
