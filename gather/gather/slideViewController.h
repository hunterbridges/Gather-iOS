//
//  slideViewController.h
//  gather
//
//  Created by Brandon Withrow on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface slideViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *slideView;
    NSMutableArray *navigationStack;
    int scrollStop;
    int _currentPage;
    UIViewController *removePage;
}
@property (readonly) int currentPage;
@property (readonly) int currentIndex;
@property (readonly) int pageCount;
-(void)addNewPage:(id)newPage;
-(void)resetWithPage:(id)newPage;
-(void)scrollToPage:(int)page;
-(void)scrollToLastPage;
-(void)scrollToFirstPage;
-(void)pushNewPage:(id)newPage;
-(void)setScrollStop:(int)atPage;
- (void) removePage:(int)page;
- (void) removeAllPages;
-(void)resetScrollStop;
- (void) updateCurrentPageBasedOnScroll;
- (void) setCurrentPage:(int)pageNum;
@end
