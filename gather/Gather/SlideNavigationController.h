#import <UIKit/UIKit.h>

@class DoubleResponderScrollView;
@class SlideViewController;
@interface SlideNavigationController : UIViewController <UIScrollViewDelegate> {
  DoubleResponderScrollView *scrollView_;
  NSMutableArray *navigationStack_;
  int scrollStop_;
  int currentPage_;
  UIViewController *removePage_;
}

@property (readonly) int currentPage;
@property (readonly) int currentIndex;
@property (readonly) int pageCount;
@property (nonatomic, retain) UIScrollView *scrollView;

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
- (void)setGrabberRect:(CGRect)grabberRect;
@end
