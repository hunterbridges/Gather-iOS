#import <UIKit/UIKit.h>

#import "ArrowView.h"
#import "ExView.h"

@interface SplitListCellView : UIView {
  ArrowView *accessoryArrow_;
  ExView *accessoryEx_;
  UILabel *label_;
  BOOL isSelected_;
}

@property BOOL isSelected;
@property (nonatomic, retain) UILabel *label;

- (id)init;
- (void)setText:(NSString*)text selected:(BOOL)selected;
- (void)switchSelection;
@end
