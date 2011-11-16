#import "DoubleResponderScrollView.h"

@implementation DoubleResponderScrollView
@synthesize grabberRect = grabberRect_;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.nextResponder) {
    [self.nextResponder touchesBegan:touches withEvent:event];
  }
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.nextResponder) {
    [self.nextResponder touchesEnded:touches withEvent:event];
  }
  [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.nextResponder) {
    [self.nextResponder touchesMoved:touches withEvent:event];
  }
  [super touchesMoved:touches withEvent:event];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView* result = [super hitTest:point withEvent:event];
  
  if (CGRectEqualToRect(grabberRect_, CGRectZero)) {
    [self setScrollEnabled:YES];
  } else if (!CGRectEqualToRect(grabberRect_, CGRectZero) &&
             CGRectContainsPoint(grabberRect_, point)) {
    [self setScrollEnabled:YES];
  } else {
    [self setScrollEnabled:NO];
  }
  
  return result;
}

@end
