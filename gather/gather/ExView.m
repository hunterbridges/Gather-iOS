#import "ExView.h"

@implementation ExView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:CGRectMake(frame.origin.x,
                                         frame.origin.y,
                                         20,
                                         20)];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 4.0);
  CGContextSetStrokeColorWithColor(context,
      [UIColor colorWithWhite:0.20 alpha:1].CGColor);
  CGContextMoveToPoint(context, 1, 1);
  CGContextAddLineToPoint(context, 18, 18);
  CGContextMoveToPoint(context, 18, 1);
  CGContextAddLineToPoint(context, 1, 18);
  CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}

@end
