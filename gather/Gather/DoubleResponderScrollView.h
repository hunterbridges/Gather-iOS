#import <UIKit/UIKit.h>

@interface DoubleResponderScrollView : UIScrollView {
  CGRect grabberRect_;
}

@property (nonatomic, assign) CGRect grabberRect;
@end
