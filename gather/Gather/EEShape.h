#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "EEScene.h"

#define M_TAU (2 * M_PI)

@interface EEShape : NSObject {
  NSMutableData *vertexData_;
  NSMutableData *vertexColorData_;
  NSMutableData *textureCoordinateData_;
  
  GLKVector4 color_;
  BOOL useConstantColor_;
  GLKTextureInfo *texture_;
  
  GLKVector2 position_;
  float rotation_;
  GLKVector2 scale_;
  
  NSMutableArray *children_;
  EEShape *parent_;
  
  GLKVector2 velocity_;
  GLKVector2 acceleration_;
  float angularVelocity_;
  float angularAcceleration_;
  
  NSMutableArray *animations_;
}

@property (readonly) int numVertices;
@property (readonly) GLKVector2 *vertices;
@property (assign) GLKVector4 color;
@property (readonly) GLKVector4 *vertexColors;
@property (readonly) GLKVector2 *textureCoordinates;
@property (assign) BOOL useConstantColor;
@property (nonatomic, assign) GLKVector2 position;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) GLKVector2 scale;
@property (strong, readonly) NSMutableArray *children;
@property (nonatomic, assign) EEShape *parent;
@property (readonly) GLKMatrix4 modelViewMatrix;
@property (nonatomic, assign) GLKVector2 velocity;
@property (nonatomic, assign) GLKVector2 acceleration;
@property (nonatomic, assign) float angularVelocity;
@property (nonatomic, assign) float angularAcceleration;
@property (strong, readonly) NSMutableArray *animations;

- (void)renderInScene:(EEScene *)scene;
- (void)setTextureImage:(UIImage *)image;
- (void)addChild:(EEShape *)child;
- (void)update:(NSTimeInterval)dt;
- (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^)(void))animationsBlock;
  
@end
