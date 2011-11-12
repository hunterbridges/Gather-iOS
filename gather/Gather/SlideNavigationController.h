#import <UIKit/UIKit.h>

@class SlideViewController;
@interface SlideNavigationController : UIViewController <UIScrollViewDelegate> {
  UIScrollView *slideView_;
  NSMutableArray *navigationStack_;
  int scrollStop_;
  int currentPage_;
  UIViewController *removePage_;
}

@property (readonly) int currentPage;
@property (readonly) int currentIndex;
@property (readonly) int pageCount;

- (void)addNewPage:(SlideViewController *)newPage;
- (void)resetWithPage:(SlideViewController *)newPage;
- (void)scrollToPage:(int)page;
- (void)scrollToLastPage;
- (void)scrollToFirstPage;
- (void)pushNewPage:(SlideViewController *)newPage;
- (void)setScrollStop:(int)atPage;
- (void)removePage:(int)page;
- (void)removeAllPages;
- (void)resetScrollStop;
- (void)updateCurrentPageBasedOnScroll;
- (void)setCurrentPage:(int)pageNum;
@end
