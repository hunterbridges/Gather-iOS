#import "GolfballGrippies.h"

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
    
    animationTrail_ = 10;
    animationStep_ = -animationTrail_;
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
    if (animationTimer_) {
      [animationTimer_ invalidate];
    }
    animationTimer_ = nil;
    [self setNeedsDisplay];
  } else {
    animationStep_ = -animationTrail_;
    animationTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                       target:self
                                                     selector:@selector(animate)
                                                     userInfo:nil
                                                      repeats:YES];
  }
}

- (void)dealloc {
  [touches_ release];
  if (animationTimer_) {
    [animationTimer_ invalidate];
  }
  [animationTimer_ release];
  [super dealloc];
}

- (CGSize)cellOuterSize {
  CGSize outerSize = CGSizeMake(cellSize_ + 2 * cellPadding_,
                                cellSize_ + 2 * cellPadding_);
  return outerSize;
}

- (void)animate {
  switch (currentAnimation_) {
    case kGolfballGrippiesAnimationLeft:
    case kGolfballGrippiesAnimationRight:
      animationStep_++;
      if (animationStep_ > self.columnCount + animationTrail_) {
        animationStep_ = -animationTrail_;
      }
      [self setNeedsDisplay];
      break;
      
    case kGolfballGrippiesAnimationNone:
      animationStep_ = 0;
      break;
  }
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  int lightUpColumn;
  for (int row = 0; row < self.rowCount; row++) {
    for (int col = 0; col < self.columnCount; col++) {
      CGRect circleRect = CGRectMake(self.cellOuterSize.width * col +
                                         cellPadding_,
                                     self.cellOuterSize.height * row +
                                         cellPadding_,
                                     cellSize_,
                                     cellSize_);
      CGPoint circleCenter = CGPointMake(circleRect.origin.x +
                                             circleRect.size.width / 2.0,
                                         circleRect.origin.y + 
                                             circleRect.size.height / 2.0);
      CGFloat shade = 0.8;
      if (touches_ != nil && [touches_ count] > 0) {
        for (UITouch *touch in touches_) {
          CGPoint point = [touch locationInView:self];
          CGFloat distance = sqrtf(powf(circleCenter.x - point.x, 2) +
                                   powf(circleCenter.y - point.y, 2));
          if (distance < 50.0) {
            shade = MIN(shade, 0.7);
          }
        }
      }
      
      switch (currentAnimation_) {
        case kGolfballGrippiesAnimationLeft:
          lightUpColumn = self.columnCount - animationStep_;
          if (lightUpColumn >= col && lightUpColumn <= col + animationTrail_) {
            int distance = abs(lightUpColumn - col);
            CGFloat darken = 0.1;
            shade = MIN(shade, 0.8 - (darken * distance / animationTrail_));
          }
          break;
        
        case kGolfballGrippiesAnimationRight:
          if (animationStep_ <= col && animationStep_ >= col - animationTrail_) {
            int distance = abs(animationStep_ - col);
            CGFloat darken = 0.1;
            shade = MIN(shade, 0.8 - (darken * distance / animationTrail_));
          }
          break;
          
        case kGolfballGrippiesAnimationNone:
          break;
      }
      
      CGContextSetFillColorWithColor(context,
          [UIColor colorWithWhite:0.95 alpha:1].CGColor);
      CGContextMoveToPoint(context, 0, 0);
      CGContextFillEllipseInRect(context, 
                                 CGRectMake(circleRect.origin.x,
                                            circleRect.origin.y + 1,
                                            circleRect.size.width,
                                            circleRect.size.height));
      
      CGContextSetFillColorWithColor(context,
          [UIColor colorWithWhite:0.65 alpha:1].CGColor);
      CGContextMoveToPoint(context, 0, 0);
      CGContextFillEllipseInRect(context, 
                                 CGRectMake(circleRect.origin.x,
                                            circleRect.origin.y,
                                            circleRect.size.width,
                                            circleRect.size.height));
      
      CGContextSetFillColorWithColor(context,
          [UIColor colorWithWhite:shade alpha:1].CGColor);
      CGContextMoveToPoint(context, 0, 0);
      CGContextFillEllipseInRect(context, 
                                 CGRectMake(circleRect.origin.x,
                                            circleRect.origin.y + 1,
                                            circleRect.size.width,
                                            circleRect.size.height - 1));
      
      /*
      CGFloat colors [] = { 
        0.0, 0.0, 0.0, 0.20, 
        0.0, 0.0, 0.0, 0.0
      };
      
      CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
      CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace,
                                                                   colors,
                                                                   NULL,
                                                                   2);
      CGColorSpaceRelease(baseSpace), baseSpace = NULL;
      
      CGContextSaveGState(context);
      CGContextAddEllipseInRect(context, circleRect);
      CGContextClip(context);
      
      CGPoint startPoint = CGPointMake(CGRectGetMidX(circleRect),
                                       CGRectGetMinY(circleRect));
      CGPoint endPoint = CGPointMake(CGRectGetMidX(circleRect),
                                     CGRectGetMaxY(circleRect));
      
      CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
      CGGradientRelease(gradient), gradient = NULL;
      
      CGContextRestoreGState(context);
       */
    }
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
    startTouchPosition = [touch locationInView:self];
    scrollViewLeftStart = scrollViewLeft_.contentOffset;
    scrollViewRightStart = scrollViewRight_.contentOffset;
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
    [scrollViewLeft_ setContentOffset:scrollViewLeftStart animated:YES];
    [scrollViewRight_ setContentOffset:scrollViewRightStart animated:YES];
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
  if (currentTouchPosition.x > startTouchPosition.x) {
    //Swiping Right
    swipePercentage = (currentTouchPosition.x - startTouchPosition.x) / 
        (self.frame.size.width - startTouchPosition.x);

    if ((swipePercentage>0.5)&&
        ((scrollViewRightStart.x - scrollViewRight_.frame.size.width)>=0)) {
      //full swipe
      [scrollViewRight_ setContentOffset:
        CGPointMake((scrollViewRightStart.x - scrollViewRight_.frame.size.width)
        , 0) animated:YES];
    } else {
      //swipe cancelled
      [scrollViewRight_ setContentOffset:scrollViewRightStart animated:YES];
    }
    
  } else {
    //Swiped Left
    swipePercentage = (startTouchPosition.x - currentTouchPosition.x) / 
        startTouchPosition.x;
    if ((fabsf(swipePercentage)>0.5)&&
        ((scrollViewLeftStart.x + scrollViewLeft_.frame.size.width)
        < scrollViewLeft_.contentSize.width)) 
    {
      //full swipe
      [scrollViewLeft_ setContentOffset:
          CGPointMake((scrollViewLeftStart.x + scrollViewLeft_.frame.size.width)
          , 0) animated:YES];
    } else {
      //swipe cancelled
      [scrollViewLeft_ setContentOffset:scrollViewLeftStart animated:YES];
    }
  }
  scrollViewLeftStart = scrollViewLeft_.contentOffset;
  scrollViewRightStart = scrollViewRight_.contentOffset;
  
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  if (enabled_) {
    [touches_ release];
    touches_ = [touches retain];
    [self setNeedsDisplay];
  }
}

@end
