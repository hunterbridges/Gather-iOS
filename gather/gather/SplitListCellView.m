#import "SplitListCellView.h"


@implementation SplitListCellView
@synthesize label = label_;
@synthesize isSelected = isSelected_;

- (id)init {
  self = [super initWithFrame:CGRectMake(0,
                                         0,
                                         158,
                                         65)];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.10 alpha:1];
    accessoryArrow_ = [[ArrowView alloc] initWithFrame:CGRectMake(128, 
                                                                23, 
                                                                0, 
                                                                0)];
    accessoryEx_ = [[ExView alloc] initWithFrame:CGRectMake(128, 
                                                          22, 
                                                          0, 
                                                          0)];
    accessoryEx_.hidden = YES;
    [self addSubview:accessoryArrow_];
    [self addSubview:accessoryEx_];
    isSelected_ = NO;

    label_ = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                      22,
                                                      110,
                                                      30)];
    // TODO: Centralize font management.
    [label_ setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
    label_.backgroundColor = [UIColor clearColor];
    label_.textColor = [UIColor colorWithWhite:0.80 alpha:1];
    [self addSubview:label_];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 1);
  CGContextSetStrokeColorWithColor(context,
      [UIColor colorWithWhite:0.20 alpha:1].CGColor);
  CGContextMoveToPoint(context, 2, 0);
  CGContextAddLineToPoint(context, 158, 0);
  CGContextStrokePath(context);
  
  CGContextSetStrokeColorWithColor(context,
                                   [UIColor colorWithWhite:0 alpha:1].CGColor);
  CGContextMoveToPoint(context, 2, 65);
  CGContextAddLineToPoint(context, 158, 65);
  CGContextStrokePath(context);
}

- (void)setText:(NSString*)text selected:(BOOL)selected {
  label_.text = text;
  if (selected == YES) {
      accessoryArrow_.hidden = YES;
      accessoryEx_.hidden = NO;
      isSelected_ = YES;
      self.backgroundColor = [UIColor colorWithWhite:0.11 alpha:1];
  } else {
      accessoryArrow_.hidden = NO;
      accessoryEx_.hidden = YES;
      isSelected_ = NO;
      self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
  }
}

- (void)switchSelection {
  if (isSelected_ == NO) {
    accessoryArrow_.hidden = YES;
    accessoryEx_.hidden = NO;
    isSelected_ = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.11 alpha:1];
  } else{
    accessoryArrow_.hidden = NO;
    accessoryEx_.hidden = YES;
    isSelected_ = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
  }
}

- (void)dealloc {
  [super dealloc];
}

@end
