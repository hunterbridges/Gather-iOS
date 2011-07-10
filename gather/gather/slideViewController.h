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
}
@property (readonly) int currentPage;
@property (readonly) int pageCount;
-(void)addNewPage:(id)newPage;
-(void)scrollToPage:(int)page;
-(void)scrollToLastPage;
-(void)scrollToFirstPage;
-(void)pushNewPage:(id)newPage;
-(void)setScrollStop:(int)atPage;
-(void)resetScrollStop;
@end
