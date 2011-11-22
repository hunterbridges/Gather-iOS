#import <UIKit/UIKit.h>

#import "ArrowView.h"
#import "ExView.h"

typedef enum {
  kSplitListCellStateNotSelected = 0,
  kSplitListCellStateSelected,
  kSplitListCellStateDeleteConfirmation
} SplitListCellState;

@class AppContext;
@interface SplitListCell : UITableViewCell {
  AppContext *ctx_;
  ArrowView *accessoryArrow_;
  ExView *accessoryEx_;
  UILabel *label_;
  BOOL isSelected_;
  BOOL showingDeleteConfirmation_;
  
  SplitListCellState currentState_;
  
  NSString *name_;
}

- (id)initWithContext:(AppContext *)ctx
  withReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setText:(NSString*)text selected:(BOOL)selected;
- (void)switchSelection;
- (void)deriveState;

@property BOOL isSelected;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) SplitListCellState currentState;
@property (nonatomic, retain) NSString *name;
@end
