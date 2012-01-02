#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface EEScene : NSObject {
  GLKVector4 clearColor_;
  
  BOOL projectionMatrixCached_;
  GLKMatrix4 projectionMatrix_;
  
  NSMutableArray *shapes_;
  NSMutableArray *animations_;
}

- (void)update:(NSTimeInterval)dt;
- (void)render;
- (void)setProjectionMatrixWithLeft:(float)left
                              right:(float)right
                                top:(float)top
                             bottom:(float)bottom;
- (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^)(void))animationsBlock;

@property GLKVector4 clearColor;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
@property (strong, readonly) NSMutableArray *shapes;
@property (nonatomic, readonly) NSMutableArray *animations;
@end
