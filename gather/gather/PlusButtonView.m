#import "PlusButtonView.h"

@implementation PlusButtonView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.10 alpha:1];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 1);
  CGContextSetStrokeColorWithColor(context,
                                   [UIColor colorWithWhite:0 alpha:1].CGColor);
  CGContextMoveToPoint(context, 
                       2,
                       self.frame.size.height);
  CGContextAddLineToPoint(context,
                          self.frame.size.width,
                          self.frame.size.height);
  CGContextAddLineToPoint(context,
                          self.frame.size.width,
                          0);
  CGContextStrokePath(context);

  CGContextSetLineWidth(context, 4.0);
  CGContextSetStrokeColorWithColor(context,
      [UIColor colorWithWhite:0.20 alpha:1].CGColor);
  CGContextMoveToPoint(context,
                       (self.frame.size.width / 2),
                        ((self.frame.size.height / 2) - 11));
  CGContextAddLineToPoint(context,
                          (self.frame.size.width / 2),
                          ((self.frame.size.height / 2) + 11));
  CGContextMoveToPoint(context,
                       ((self.frame.size.width / 2) - 11),
                       (self.frame.size.height / 2));
  CGContextAddLineToPoint(context,
                          ((self.frame.size.width / 2) + 11),
                          (self.frame.size.height / 2));
  CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}

@end
