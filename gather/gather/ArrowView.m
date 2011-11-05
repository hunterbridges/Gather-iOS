#import "ArrowView.h"

@implementation ArrowView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:CGRectMake(frame.origin.x,
                                         frame.origin.y,
                                         12,
                                         18)];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 1.0);
  CGContextSetStrokeColorWithColor(context,
      [UIColor colorWithWhite:0.20 alpha:1].CGColor);
  CGContextSetFillColorWithColor(context,
      [UIColor colorWithWhite:0.20 alpha:1].CGColor);
  CGContextMoveToPoint(context, 0, 0);
  CGContextAddLineToPoint(context, 12, 9);
  CGContextAddLineToPoint(context, 0, 18);
  CGContextClosePath(context);
  CGContextFillPath(context);
}


- (void)dealloc {
    [super dealloc];
}

@end
