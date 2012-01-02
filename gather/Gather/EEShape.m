#import "EEShape.h"
#import "EEAnimation.h"

@implementation EEShape 
@synthesize color = color_;
@synthesize useConstantColor = useConstantColor_;
@synthesize position = position_;
@synthesize rotation = rotation_;
@synthesize scale = scale_;
@synthesize children = children_;
@synthesize parent = parent_;
@synthesize velocity = velocity_;
@synthesize acceleration = acceleration_;
@synthesize angularVelocity = angularVelocity_;
@synthesize angularAcceleration = angularAcceleration_;
@synthesize animations = animations_;


- (id) init {
  self = [super init];
  if (self) {
    children_ = [[NSMutableArray alloc] init];
    animations_ = [[NSMutableArray alloc] init];
    
    useConstantColor_ = YES;
    color_ = GLKVector4Make(1, 1, 1, 1);
    scale_ = GLKVector2Make(1, 1);
    position_ = GLKVector2Make(0, 0);
    rotation_ = 0;
  }
  return self;
}

- (int)numVertices {
  return 0;
}

- (GLKVector2 *)vertices {
  if (vertexData_ == nil) {
    vertexData_ = [[NSMutableData dataWithLength:sizeof(GLKVector2) * self.numVertices] retain];
  }
  return [vertexData_ mutableBytes];
}

- (GLKVector4 *)vertexColors {
  if (vertexColorData_ == nil) {
    vertexColorData_ = [[NSMutableData dataWithLength:sizeof(GLKVector4) * self.numVertices] retain];
  }
  return [vertexColorData_ mutableBytes];
}

- (GLKVector2 *)textureCoordinates {
  if (textureCoordinateData_ == nil) {
    textureCoordinateData_ = [[NSMutableData dataWithLength:sizeof(GLKVector2) * self.numVertices] retain];
  }
  return [textureCoordinateData_ mutableBytes];
}

- (GLKMatrix4)modelViewMatrix {
  GLKMatrix4 modelViewMatrix = 
  GLKMatrix4Multiply(GLKMatrix4MakeTranslation(position_.x, 
                                               position_.y, 
                                               0),
                     GLKMatrix4MakeRotation(rotation_, 
                                            0, 
                                            0, 
                                            1));
  modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix,
                                       GLKMatrix4MakeScale(scale_.x,
                                                           scale_.y,
                                                           1));
  
  if (parent_ != nil) {
    modelViewMatrix =
        GLKMatrix4Multiply(parent_.modelViewMatrix,
                           modelViewMatrix);
  }
  return modelViewMatrix;
}

- (void)renderInScene:(EEScene *)scene {
  GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
  effect.transform.projectionMatrix = scene.projectionMatrix;
  effect.transform.modelviewMatrix = self.modelViewMatrix;
  
  if (useConstantColor_) {
    effect.useConstantColor = YES;
    effect.constantColor = color_;
  }
  
  if (texture_ != nil) {
    effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    effect.texture2d0.target = GLKTextureTarget2D;
    effect.texture2d0.name = texture_.name;
  }
  
  [effect prepareToDraw];
  
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  
  if (self.numVertices) {
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          self.vertices);
    if (!useConstantColor_) {
      glEnableVertexAttribArray(GLKVertexAttribColor);
      glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0,
                            self.vertexColors);
    }
    if (texture_ != nil) {
      glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
      glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE,
                            0, self.textureCoordinates);
    }
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, self.numVertices);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    if (!useConstantColor_) {
      glDisableVertexAttribArray(GLKVertexAttribColor);
    }
    if (texture_ != nil) {
      glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
  }
  
  glDisable(GL_BLEND);
  [effect release];
  
  [children_ makeObjectsPerformSelector:@selector(renderInScene:)
                             withObject:scene];
}

- (void)setTextureImage:(UIImage *)image {
  NSError *error;
  NSDictionary *options = 
      [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] 
                                  forKey:GLKTextureLoaderOriginBottomLeft];
  texture_ = [[GLKTextureLoader textureWithCGImage:image.CGImage
                                           options:options
                                            error:&error] retain];
  if (error) {
    NSLog(@"Error loading texture from image: %@", error);
  }
}

- (void)addChild:(EEShape *)child {
  child.parent = self;
  [children_ addObject:child];
}

- (void)update:(NSTimeInterval)dt {
  [animations_ enumerateObjectsUsingBlock:^(EEAnimation *animation, NSUInteger idx, BOOL *stop) {
    [animation animateShape:self dt:dt];
  }];
  
  [animations_ filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EEAnimation *animation, NSDictionary *bindings) {
    return animation.elapsedTime <= animation.duration;
  }]];
  
  angularVelocity_ += angularAcceleration_ * dt;
  rotation_ += angularVelocity_ * dt;
  
  GLKVector2 changeInVelocity = GLKVector2MultiplyScalar(self.acceleration, dt);
  self.velocity = GLKVector2Add(self.velocity, changeInVelocity);
  
  GLKVector2 distanceTraveled = GLKVector2MultiplyScalar(self.velocity, dt);
  self.position = GLKVector2Add(self.position, distanceTraveled);
}

- (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^)(void))animationsBlock {
  GLKVector2 currentPosition = self.position;
  GLKVector2 currentScale = self.scale;
  GLKVector4 currentColor = self.color;
  float currentRotation = self.rotation;
  
  animationsBlock();
  
  EEAnimation *animation = [[EEAnimation alloc] init];
  animation.positionDelta = GLKVector2Subtract(self.position, currentPosition);
  animation.scaleDelta = GLKVector2Subtract(self.scale, currentScale);
  animation.colorDelta = GLKVector4Subtract(self.color, currentColor);
  animation.rotationDelta = self.rotation - currentRotation;
  animation.duration = duration;
  [self.animations addObject:animation];
  [animation release];
  
  self.position = currentPosition;
  self.scale = currentScale;
  self.color = currentColor;
  self.rotation = currentRotation;
}

- (void)dealloc {
  [vertexData_ release];
  [vertexColorData_ release];
  [texture_ release];
  [textureCoordinateData_ release];
  [children_ release];
  [super dealloc];
}
@end
