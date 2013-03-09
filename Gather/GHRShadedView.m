#import "GHRShadedView.h"

@implementation GHRShadedView {
  UIView *shadingLayer_;
}

@synthesize faceShading = faceShading_;

- (void)dealloc {
  [shadingLayer_ release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    faceShading_ = 0;
    shadingLayer_ = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:shadingLayer_];
  }
  return self;
}

- (void)setFaceShading:(float)faceShading {
  faceShading_ = fmax(fminf(faceShading, 1), -1);
  int color = faceShading > 0 ? 1 : 0;
  float alpha = fabs(faceShading) * 1;
  shadingLayer_.backgroundColor = [UIColor colorWithWhite:color alpha:alpha];
  if (alpha == 0) {
    shadingLayer_.hidden = YES;
  } else {
    shadingLayer_.hidden = NO;
  }
  [self setNeedsDisplay];
}

- (void)addSubview:(UIView *)view {
  [super addSubview:view];
  [self bringSubviewToFront:shadingLayer_];
}


@end
