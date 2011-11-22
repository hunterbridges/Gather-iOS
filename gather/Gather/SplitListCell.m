#import "AppContext.h"
#import "FontManager.h"
#import "SplitListCell.h"
#import "UIColor+Gather.h"
#import "StringUtils.h"


@implementation SplitListCell
@synthesize label = label_;
@synthesize isSelected = isSelected_;
@synthesize currentState = currentState_;
@synthesize name = name_;

- (id)initWithContext:(AppContext *)ctx
  withReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle
              reuseIdentifier:reuseIdentifier];
  if (self) {
    ctx_ = [ctx retain];
    self.backgroundColor = [UIColor selectionCellUnselectedBackgroundColor];
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
    [label_ setFont:[ctx_.fontManager contentFontWithSize:24]];
    label_.backgroundColor = [UIColor clearColor];
    label_.textColor = [UIColor lighterTextColor];
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
  if (!isSelected_) {
    CGContextSetStrokeColorWithColor(context,
        [UIColor colorWithWhite:0.20 alpha:1].CGColor);
  } else {
    CGContextSetStrokeColorWithColor(context,
        [UIColor colorWithWhite:0 alpha:1].CGColor);
  }
  CGContextMoveToPoint(context, 2, 0);
  CGContextAddLineToPoint(context, 158, 0);
  CGContextStrokePath(context);
  
  if (!isSelected_) {
    CGContextSetStrokeColorWithColor(context,
        [UIColor colorWithWhite:0 alpha:1].CGColor);
  } else {
    CGContextSetStrokeColorWithColor(context,
        [UIColor colorWithWhite:0.20 alpha:1].CGColor);
  }
  CGContextMoveToPoint(context, 2, 65);
  CGContextAddLineToPoint(context, 158, 65);
  CGContextStrokePath(context);
}

- (void)setText:(NSString*)text selected:(BOOL)selected {
  self.name = text;
  isSelected_ = selected;
  [self deriveState];
}

- (void)setName:(NSString *)name {
  name_ = [name retain];
  label_.text = [StringUtils formattedNameString:name];
}

- (void)switchSelection {
  isSelected_ = !isSelected_;
  [self deriveState];
}

- (void)deriveState {
  if (showingDeleteConfirmation_) {
    self.currentState = kSplitListCellStateDeleteConfirmation;
    return;
  }
  
  if (isSelected_) {
    self.currentState = kSplitListCellStateSelected;
    return;
  }
  
  self.currentState = kSplitListCellStateNotSelected;
}

- (void)setCurrentState:(SplitListCellState)currentState {
  currentState_ = currentState;
  switch (currentState) {
    case kSplitListCellStateNotSelected:
      accessoryArrow_.hidden = YES;
      accessoryEx_.hidden = NO;
      label_.textColor = [UIColor lighterTextColor];
      self.backgroundColor = [UIColor selectionCellUnselectedBackgroundColor];
      break;
    
    case kSplitListCellStateSelected:
      accessoryArrow_.hidden = NO;
      accessoryEx_.hidden = YES;
      label_.textColor = [UIColor lightTextColor];
      self.backgroundColor = [UIColor selectionCellSelectedBackgroundColor];
      break;
    
    case kSplitListCellStateDeleteConfirmation:
      label_.textColor = [UIColor lighterTextColor];
      self.backgroundColor = [UIColor selectionCellDeleteBackgroundColor];
      break;
      
    default:
      break;
  }
  [self setNeedsDisplay];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
  [super willTransitionToState:state];
  if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
    showingDeleteConfirmation_ = YES;
  } else {
    showingDeleteConfirmation_ = NO;
  }
  [self deriveState];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
  [super didTransitionToState:state];
}

- (void)dealloc {
  [ctx_ release];
  [accessoryArrow_ release];
  [accessoryEx_ release];
  [label_ release];
  [name_ release];
  [super dealloc];
}

@end
