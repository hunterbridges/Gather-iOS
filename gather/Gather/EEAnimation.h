#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "EEShape.h"
#import "EEScene.h"

@interface EEAnimation : NSObject {
  NSTimeInterval duration_;
  NSTimeInterval elapsedTime_;
  
  GLKVector2 positionDelta_;
  float rotationDelta_;
  GLKVector4 colorDelta_;
  GLKVector2 scaleDelta_;
  
  GLKMatrix4 projectionMatrixDelta_;
}

@property (nonatomic, assign) NSTimeInterval duration;
@property (readonly) NSTimeInterval elapsedTime;

@property (nonatomic, assign) float rotationDelta;
@property (nonatomic, assign) GLKVector2 positionDelta;
@property (nonatomic, assign) GLKVector2 scaleDelta;
@property (nonatomic, assign) GLKVector4 colorDelta;
@property (nonatomic, assign) GLKMatrix4 projectionMatrixDelta;

- (void)animateShape:(EEShape *)shape dt:(NSTimeInterval)dt;
- (void)animateScene:(EEScene *)scene dt:(NSTimeInterval)dt;
@end
