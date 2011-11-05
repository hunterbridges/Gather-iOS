#import <UIKit/UIKit.h>


@interface SlideViewController : UIViewController <UIScrollViewDelegate> {
  UIScrollView *slideView_;
  NSMutableArray *navigationStack_;
  int scrollStop_;
  int currentPage_;
  UIViewController *removePage_;
}

@property (readonly) int currentPage;
@property (readonly) int currentIndex;
@property (readonly) int pageCount;

- (void)addNewPage:(id)newPage;
- (void)resetWithPage:(id)newPage;
- (void)scrollToPage:(int)page;
- (void)scrollToLastPage;
- (void)scrollToFirstPage;
- (void)pushNewPage:(id)newPage;
- (void)setScrollStop:(int)atPage;
- (void)removePage:(int)page;
- (void)removeAllPages;
- (void)resetScrollStop;
- (void)updateCurrentPageBasedOnScroll;
- (void)setCurrentPage:(int)pageNum;
@end
