#import <UIKit/UIKit.h>
#import "GolfballGrippies.h"

@class DoubleResponderScrollView;
@class SlideViewController;
@interface SlideNavigationController : UIViewController <UIScrollViewDelegate> {
  UIScrollView *scrollView_;
  NSMutableArray *navigationStack_;
  int scrollStop_;
  int currentPage_;
  UIViewController *removePage_;
  GolfballGrippies *grippies_;
}

@property (readonly) int currentPage;
@property (readonly) int currentIndex;
@property (readonly) int pageCount;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) GolfballGrippies *grippies;

- (void)addNewPage:(SlideViewController *)newPage;
- (void)resetWithPage:(SlideViewController *)newPage;
- (void)scrollToPage:(int)page;
- (void)scrollToLastPage;
- (void)scrollToFirstPage;
- (void)pushNewPage:(SlideViewController *)newPage;
- (void)setScrollStop:(int)atPage;
- (void)removeLastPage;
- (void)removeAllPages;
- (void)resetScrollStop;
- (void)updateCurrentPageBasedOnScroll;
- (void)setCurrentPage:(int)currentPage;
- (void)enableGrippiesLeft;
- (void)enableGrippiesRight;
- (void)disableGrippies;
- (void)makeGrippiesVisible:(BOOL)visible animated:(BOOL)animated;
@end
