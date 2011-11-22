#import <QuartzCore/QuartzCore.h>

#import "AppContext.h"
#import "FontManager.h"
#import "StaticListView.h"
#import "StringUtils.h"

@interface StaticListView ()
- (void)shiftLabelsDownForNamesInRange:(NSRange)range;
- (void)shiftLabelsUpForNamesInRange:(NSRange)range;
- (void)refreshLabelForName:(NSString *)name;
@end

@implementation StaticListView

- (id)initWithContext:(AppContext *)ctx withFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    ctx_ = [ctx retain];
    names_ = [[NSMutableOrderedSet alloc] init];
    labels_ = [[NSMutableDictionary alloc] init];
    self.backgroundColor = [UIColor clearColor];
    titleLabel_ = [[UILabel alloc] init];
    titleLabel_.font = [ctx_.fontManager headerFontWithSize:24];
    titleLabel_.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
}

- (void)setTitle:(NSString *)title {
  titleLabel_.text = title;
  if (title != nil && ![title isEqualToString:@""]) {
    titleLabel_.frame = CGRectMake(20,
                                   20,
                                   100,
                                   24);
    [titleLabel_ sizeToFit];
    if (![titleLabel_.superview isEqual:self]) {
      [self addSubview:titleLabel_];
    }
  } else {
    if ([titleLabel_.superview isEqual:self]) {
      [titleLabel_ removeFromSuperview];
    }
  }
}

- (NSString *)title {
  return titleLabel_.text;
}

- (void)setTitleColor:(UIColor *)color {
  titleLabel_.textColor = color;
}

-(void)addName:(NSString *)name {
  if ([labels_ objectForKey:name] == nil) {
    if ([labels_ count] < ((self.frame.size.height - 80) / 32)) {
      [names_ addObject:name];
      [names_ sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:obj2
                                 options:NSCaseInsensitiveSearch];
      }];
      uint index = [names_ indexOfObject:name];
      BOOL last = NO;
      if (![name isEqual:[names_ lastObject]]) {
        // Move other name labels down
        NSRange newRange = NSMakeRange(index + 1,
                                       [names_ count] - index - 1);
        [self shiftLabelsDownForNamesInRange:newRange];
      } else {
        last = YES;
      }
      
      int yPos = [names_ indexOfObject:name] * 32;
      CGRect withoutPadding = CGRectMake(20,
                                         yPos + 60,
                                         self.frame.size.width - 20,
                                         32);
      UILabel *newLabel = [[UILabel alloc] initWithFrame:withoutPadding];
      [newLabel setFont:[ctx_.fontManager contentFontWithSize:24]];
      newLabel.backgroundColor = [UIColor clearColor];
      newLabel.textColor = [UIColor colorWithWhite:0.10 alpha:1];
      newLabel.alpha = 0.0;
      if (last) {
        [UIView animateWithDuration:0.25
                         animations:^{
                           newLabel.alpha = 1.0;
                         }];
      }
      [labels_ setObject:newLabel forKey:name];
      [self refreshLabelForName:name];
      [self addSubview:newLabel];
      [newLabel release];
    } else if([labels_ count] < ((self.frame.size.height - 80) / 32) + 1) {
      int yPos = [labels_ count] * 32;
      UILabel *newLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                    yPos,
                                                    self.frame.size.width,
                                                    30)];
      [newLabel setFont:[ctx_.fontManager contentFontWithSize:24]];
      newLabel.backgroundColor = [UIColor clearColor];
      newLabel.textColor = [UIColor colorWithWhite:0.10 alpha:1];
      newLabel.text = @"More #";
      newLabel.tag = [labels_ count] + 1;
      [labels_ setObject:newLabel forKey:name];
      [self addSubview:newLabel];
      [newLabel release];
    }
  }
}

- (void)shiftLabelsDownForNamesInRange:(NSRange)range {
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
  
  [UIView animateWithDuration:0.25
   animations:^{
     for (NSString *name in [names_ objectsAtIndexes:indexSet]) {
       UILabel *label = [labels_ objectForKey:name];
       label.frame = CGRectMake(label.frame.origin.x,
                                label.frame.origin.y +
                                    label.frame.size.height,
                                label.frame.size.width,
                                label.frame.size.height);
       [self refreshLabelForName:name];
     }
   }
    completion:^(BOOL finished) {
      NSString *revealName = [names_ objectAtIndex:range.location - 1];
      UILabel *label = [labels_ objectForKey:revealName];
      [UIView animateWithDuration:0.25
                       animations:^{
                         label.alpha = 1.0;
                       }];
    }];
}

- (void)shiftLabelsUpForNamesInRange:(NSRange)range {
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
  
  [UIView animateWithDuration:0.25
   animations:^{
     for (NSString *name in [names_ objectsAtIndexes:indexSet]) {
       UILabel *label = [labels_ objectForKey:name];
       label.frame = CGRectMake(label.frame.origin.x,
                                label.frame.origin.y -
                                    label.frame.size.height,
                                label.frame.size.width,
                                label.frame.size.height);
       [self refreshLabelForName:name];
     }
   }];
}

- (void)removeName:(NSString*)name {
  if ([names_ containsObject:name]) {
    uint index = [names_ indexOfObject:name];
    
    UILabel *removeLabel = [labels_ objectForKey:name];
    
    BOOL needsMoveUp = NO;
    if (![name isEqual:[names_ lastObject]]) {
      needsMoveUp = YES;
    }
    
    [UIView animateWithDuration:0.1
     animations:^{
       removeLabel.alpha = 0.0;
     }
     completion:^(BOOL finished) {
       if (needsMoveUp) {
         NSRange moveUpRange = NSMakeRange(index + 1,
                                           [names_ count] - index - 1);
         [self shiftLabelsUpForNamesInRange:moveUpRange];
         [labels_ removeObjectForKey:name];
         [names_ removeObjectAtIndex:index];
         for (NSString *iName in labels_) {
           [self refreshLabelForName:iName];
         }
       }
       [removeLabel removeFromSuperview];
     }];
    
    if (!needsMoveUp) {
      [labels_ removeObjectForKey:name];
      [names_ removeObjectAtIndex:index];
      for (NSString *iName in labels_) {
        [self refreshLabelForName:iName];
      }
    }
  }
}

- (void)refreshLabelForName:(NSString *)name {
  UILabel *label = [labels_ objectForKey:name];
  uint index = [names_ indexOfObject:name];
  label.text = [NSString stringWithFormat:@"%02d %@", 
                (index + 1), [StringUtils formattedNameString:name]];
}

- (void)dealloc {
  [ctx_ release];
  [labels_ release];
  [titleLabel_ release];
  [super dealloc];
}
@end
