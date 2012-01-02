#import "EESprite.h"

@implementation EESprite

- (id)initWithImage:(UIImage *)image pointRatio:(float)ratio {
  self = [super init];
  if (self) {
    self.width = image.size.width / ratio;
    self.height = image.size.height / ratio;
    
    [self setTextureImage:image];
    self.textureCoordinates[0] = GLKVector2Make(1, 0);
    self.textureCoordinates[1] = GLKVector2Make(1, 1);
    self.textureCoordinates[2] = GLKVector2Make(0, 1);
    self.textureCoordinates[3] = GLKVector2Make(0, 0);
  }
  return self;
}
@end
