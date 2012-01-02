#import "EEScene.h"
#import "EEShape.h"
#import "EEAnimation.h"

@implementation EEScene
@synthesize clearColor = clearColor_;
@synthesize shapes = shapes_;
@synthesize animations = animations_;

- (id)init {
  self = [super init];
  if (self) {
    shapes_ = [[NSMutableArray alloc] init];
    animations_ = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)update:(NSTimeInterval)dt {
  [animations_ enumerateObjectsUsingBlock:^(EEAnimation *animation, NSUInteger idx, BOOL *stop) {
    [animation animateScene:self dt:dt];
  }];
  
  [animations_ filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EEAnimation *animation, NSDictionary *bindings) {
    return animation.elapsedTime <= animation.duration;
  }]];
  
  [shapes_ enumerateObjectsUsingBlock:^(EEShape *shape, NSUInteger idx, BOOL *stop) {
    [shape update:dt];
  }];
}

- (void)render {
  glClearColor(clearColor_.r,
               clearColor_.g,
               clearColor_.b,
               clearColor_.a);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [shapes_ makeObjectsPerformSelector:@selector(renderInScene:)
                           withObject:self];
}

-(GLKMatrix4)projectionMatrix {
  if (projectionMatrixCached_) {
    return projectionMatrix_;
  }
  projectionMatrix_ = GLKMatrix4Identity;
  projectionMatrixCached_ = YES;
  return projectionMatrix_;
}

- (void)setProjectionMatrixWithLeft:(float)left
                              right:(float)right
                                top:(float)top
                             bottom:(float)bottom {
  projectionMatrix_ = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
  projectionMatrixCached_ = YES;
}

- (void)setProjectionMatrix:(GLKMatrix4)projectionMatrix {
  projectionMatrix_ = projectionMatrix;
  projectionMatrixCached_ = YES;
}

- (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^)(void))animationsBlock {
  GLKMatrix4 currentMatrix = self.projectionMatrix;
  
  animationsBlock();
  
  EEAnimation *animation = [[EEAnimation alloc] init];
  animation.projectionMatrixDelta = GLKMatrix4Subtract(self.projectionMatrix,
                                                       currentMatrix);
  animation.duration = duration;
  [self.animations addObject:animation];
  [animation release];
  
  self.projectionMatrix = currentMatrix;
}

- (void)dealloc {
  [shapes_ release];
  [animations_ release];
  [super dealloc];
}

@end
