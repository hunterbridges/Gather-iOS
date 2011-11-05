#import "StaticListView.h"

// TODO: Is this generalized?
@implementation StaticListView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    nameDict_ = [[NSMutableDictionary alloc] init];
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

-(void)addName:(NSString*)name {
  // TODO: Centralize font management
  if ([nameDict_ objectForKey:name] == nil) {
    if ([nameDict_ count] < (self.frame.size.height / 32)) {
      int yPos = [nameDict_ count] * 32;
      NSLog(@"Less than yPos %i", yPos);
      UILabel *newLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                    yPos,
                                                    self.frame.size.width,
                                                    30)];
      [newLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
      newLabel.backgroundColor = [UIColor clearColor];
      newLabel.textColor = [UIColor colorWithWhite:0.10 alpha:1];
      newLabel.text =
          [NSString stringWithFormat:@"%i %@", ([nameDict_ count] +1),name];
      newLabel.tag = [nameDict_ count] + 1;
      [nameDict_ setObject:newLabel forKey:name];
      
      [self addSubview:newLabel];
        
    } else if([nameDict_ count] < ((self.frame.size.height / 32) + 1)) {
      int yPos = [nameDict_ count] * 32;
      UILabel *newLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                    yPos,
                                                    self.frame.size.width,
                                                    30)];
      [newLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
      newLabel.backgroundColor = [UIColor clearColor];
      newLabel.textColor = [UIColor colorWithWhite:0.10 alpha:1];
      newLabel.text = @"More #";
      newLabel.tag = [nameDict_ count] + 1;
      [nameDict_ setObject:newLabel forKey:name];
      
      [self addSubview:newLabel];
    }
  }
}

- (void)removeName:(NSString*)name {
  UILabel *removeLabel = [nameDict_ objectForKey:name];
  
  if (removeLabel != nil) {
    [removeLabel removeFromSuperview];
    if (removeLabel.tag == [nameDict_ count]) {
      [nameDict_ removeObjectForKey:name];
    } else {
      int count = removeLabel.tag;
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
      [UIView setAnimationDuration:0.5];
      [UIView setAnimationDelegate:self];
      while (count <= [nameDict_ count]) {
        count++;
        UILabel *temp = (UILabel*)[self viewWithTag:count];
        temp.tag = (count - 1);
        [temp setFrame:CGRectMake(0,
                                  temp.frame.origin.y - 32,
                                  temp.frame.size.width,
                                  temp.frame.size.height)];
      }
    }
      
    [UIView commitAnimations];
    [nameDict_ removeObjectForKey:name];
  }
}

- (void)dealloc {
  [nameDict_ release];
  [super dealloc];
}
@end
