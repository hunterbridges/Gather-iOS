#import "GolfballGrippies.h"
#import "GrippiesBlip.h"
#import "UIColor+Gather.h"

@implementation GolfballGrippies
@synthesize currentAnimation = currentAnimation_;
@synthesize cellPadding = cellPadding_;
@synthesize cellSize = cellSize_;
@synthesize enabled = enabled_;
@synthesize scrollViewLeft = scrollViewLeft_;
@synthesize scrollViewRight = scrollViewRight_;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    cellSize_ = 8.0;
    cellPadding_ = 2.0;
    touches_ = nil;
    
    cachedOuterSize_ = CGSizeZero;
    
    animationStep_ = 0;
    
    EAGLContext *context =
        [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    glkView_ = [[GLKView alloc] initWithFrame:self.bounds
                                      context:context];
    glkView_.delegate = self;
    [self addSubview:glkView_];
    [context release];
  
    glkViewController_ = [[GLKViewController alloc] init];
    glkViewController_.view = glkView_;
    glkViewController_.delegate = self;
    
    scene_ = [[GrippiesScene alloc] initWithGrippies:self];
    scene_.clearColor = [UIColor lightBackgroundColor].GLKVector4;
  }
  return self;
}
- (void)setScrollViewLeft:(UIScrollView *)scrollViewLeft{
  scrollViewLeft_ = scrollViewLeft;  
}
- (void)setScrollViewRight:(UIScrollView *)scrollViewRight{
  scrollViewRight_ = scrollViewRight;
}

- (void)setCurrentAnimation:(GolfballGrippiesAnimation)currentAnimation {
  currentAnimation_ = currentAnimation;
  if (currentAnimation == kGolfballGrippiesAnimationNone) {
    [self setNeedsDisplay];
  } else {
    animationStep_ = 0;
  }
}

- (void)dealloc {
  [touches_ release];
  [glkView_ release];
  [glkViewController_ release];
  [super dealloc];
}

- (CGSize)cellOuterSize {
  if (!CGSizeEqualToSize(cachedOuterSize_, CGSizeZero)) return cachedOuterSize_;
  cachedOuterSize_ = CGSizeMake(cellSize_ + 2 * cellPadding_,
                                cellSize_ + 2 * cellPadding_);
  return cachedOuterSize_;
}

- (void)animate {
  switch (currentAnimation_) {
    case kGolfballGrippiesAnimationLeft:
    case kGolfballGrippiesAnimationRight:
      animationStep_++;
      if (animationStep_ > self.columnCount) {
        animationStep_ = 0;
      }
      
      int column = (currentAnimation_ == kGolfballGrippiesAnimationLeft ?
                    animationStep_ :
                    self.columnCount - animationStep_);
      [[scene_ blipsInColumn:column] enumerateObjectsUsingBlock:^(GrippiesBlip *blip, NSUInteger idx, BOOL *stop) {
        [blip tap];
      }];
      break;
      
    case kGolfballGrippiesAnimationNone:
      animationStep_ = 0;
      break;
  }
}

- (int)columnCount {
  return floor(self.frame.size.width / self.cellOuterSize.width);
}

- (int)rowCount {
  return floor(self.frame.size.height / self.cellOuterSize.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  UITouch *touch = [touches anyObject];
  // startTouchPosition is an instance variable
  if (enabled_) {
    startTouchPosition_ = [touch locationInView:self];
    scrollViewLeftStart_ = scrollViewLeft_.contentOffset;
    scrollViewRightStart_ = scrollViewRight_.contentOffset;
  }
  if (enabled_) {
    [touches_ release];
    touches_ = [touches retain];
    [self setNeedsDisplay];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  if (enabled_) {
    [scrollViewLeft_ setContentOffset:scrollViewLeftStart_ animated:YES];
    [scrollViewRight_ setContentOffset:scrollViewRightStart_ animated:YES];
  }
  [touches_ release];
  touches_ = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  UITouch *touch = [touches anyObject];
  CGPoint currentTouchPosition = [touch locationInView:self];
  if (enabled_) {
    float swipePercentage;
    if (currentTouchPosition.x > startTouchPosition_.x) {
      //Swiping Right
      swipePercentage = (currentTouchPosition.x - startTouchPosition_.x) / 
          (self.frame.size.width - startTouchPosition_.x);

      if ((swipePercentage>0.5)&&
          ((scrollViewRightStart_.x - scrollViewRight_.frame.size.width)>=0)) {
        //full swipe
        [scrollViewRight_ setContentOffset:
          CGPointMake((scrollViewRightStart_.x - scrollViewRight_.frame.size.width)
          , 0) animated:YES];
      } else {
        //swipe cancelled
        [scrollViewRight_ setContentOffset:scrollViewRightStart_ animated:YES];
      }
      
    } else {
      //Swiped Left
      swipePercentage = (startTouchPosition_.x - currentTouchPosition.x) / 
          startTouchPosition_.x;
      if ((fabsf(swipePercentage)>0.5)&&
          ((scrollViewLeftStart_.x + scrollViewLeft_.frame.size.width)
          < scrollViewLeft_.contentSize.width)) 
      {
        //full swipe
        [scrollViewLeft_ setContentOffset:
            CGPointMake((scrollViewLeftStart_.x + scrollViewLeft_.frame.size.width)
            , 0) animated:YES];
      } else {
        //swipe cancelled
        [scrollViewLeft_ setContentOffset:scrollViewLeftStart_ animated:YES];
      }
    }
    scrollViewLeftStart_ = scrollViewLeft_.contentOffset;
    scrollViewRightStart_ = scrollViewRight_.contentOffset;
  }
  
  [touches_ release];
  touches_ = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  
  UITouch *touch = [touches anyObject];
  CGPoint currentTouchPosition = [touch locationInView:self];
  
  if (enabled_) {
    float swipePercentage;
    if (currentTouchPosition.x > startTouchPosition_.x) {
      //Swiping Right
      swipePercentage = (currentTouchPosition.x - startTouchPosition_.x) / 
      (self.frame.size.width - startTouchPosition_.x);
      float newContentOffset = scrollViewRightStart_.x - 
      (scrollViewRight_.frame.size.width * swipePercentage);
      
      if (newContentOffset < -100) {
        [scrollViewRight_ setContentOffset:scrollViewRightStart_ animated:YES];
        
      }else if(swipePercentage <= 1.2){
        [scrollViewRight_ setContentOffset:
         CGPointMake(newContentOffset, 0) animated:NO];
        
      }
    } else {
      //Swiping Left
      swipePercentage = (startTouchPosition_.x - currentTouchPosition.x) / 
      startTouchPosition_.x;
      float newContentOffset = (scrollViewLeft_.frame.size.width 
                                * swipePercentage) + scrollViewLeftStart_.x;
      if (newContentOffset > 
          ((scrollViewLeft_.contentSize.width-scrollViewLeft_.frame.size.width) 
           + 100)) {
        //Cancel
        [scrollViewLeft_ setContentOffset:scrollViewLeftStart_ animated:YES];
      } else if (swipePercentage <= 1.2){
        [scrollViewLeft_ setContentOffset:
        CGPointMake(newContentOffset, 0) animated:NO];
      }
    }
  }
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
  [scene_ update:controller.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [scene_ render];
}

@end
