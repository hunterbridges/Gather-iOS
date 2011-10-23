//
//  slideViewController.m
//  gather
//
//  Created by Brandon Withrow on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "slideViewController.h"
#import "viewPlaceHolder.h"

@implementation slideViewController

- (id)init{
    self = [super init];
    if (self) {
        slideView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        slideView.scrollEnabled = YES;
		slideView.pagingEnabled = YES;
		slideView.directionalLockEnabled = YES;
		slideView.showsVerticalScrollIndicator = NO;
		slideView.showsHorizontalScrollIndicator = NO;
		slideView.delegate = self;
		slideView.backgroundColor = [UIColor blackColor];
		slideView.autoresizesSubviews = YES;
        slideView.contentSize = CGSizeMake(320, 480);
		slideView.frame = CGRectMake(0, 0, 320, 480);
		scrollStop = 0;
        
        
        navigationStack = [[NSMutableArray alloc] init];
        [self.view addSubview:slideView];

    }
    return self;
}
-(int)currentPage{
    return _currentPage;

}
-(int)currentIndex{
    int pageNum = (slideView.contentOffset.x/320);
    return pageNum;
}
-(int)pageCount{
    
    return [navigationStack count];
    
}
-(void)setScrollStop:(int)atPage{
    scrollStop = atPage;
    NSLog(@"Setting Scroll Stop to Page %i", atPage);
    slideView.contentSize = CGSizeMake(((atPage * 320)+1), 480);
}
-(void)resetScrollStop{
    [self setScrollStop:[navigationStack count]];
     scrollStop = 0;
}
-(void)addNewPage:(id)newPage{
    NSLog(@"Attempting to add view");
    if ([[newPage class] isSubclassOfClass:[UIViewController class]]) {
        NSLog(@"Adding View");
        
        UIViewController *newView = (UIViewController *)newPage;
        newView.view.frame = CGRectMake(([navigationStack count]*320), 0, 320, 480);
        [slideView addSubview:newView.view];
        
        slideView.contentSize = CGSizeMake((([navigationStack count]*320)+320), 480);
        [navigationStack addObject:newPage];
        if ([navigationStack count] == 1) {
            [newPage viewWillAppear:YES];
            [newPage viewDidAppear:YES];
            _currentPage = 1;
        }
        NSLog(@"Stack Count %i", [navigationStack count]);
        
       
        
        if (scrollStop !=0) {
            [self setScrollStop:scrollStop];
        }
       
    }
}
-(void)pushNewPage:(id)newPage{
    [self addNewPage:newPage];
    
    [self scrollToLastPage];
    
}
-(void)resetWithPage:(id)newPage {
    if ([navigationStack count] == 0) {
         UIViewController *newView = (UIViewController *)newPage;
        _currentPage = 1;
        [self addNewPage:newView];
    }else{
        UIViewController *keepPage = (UIViewController *)[navigationStack objectAtIndex:([self currentPage] -1)];
        for (UIViewController * i in navigationStack)
        {
            if (i != keepPage) {
                [i viewWillDisappear:NO];
                [i.view removeFromSuperview];
                [i viewDidDisappear:NO];
                
            }
            
        }
        [navigationStack removeAllObjects];
        removePage = keepPage;
        scrollStop = 0;
        UIViewController *newView = (UIViewController *)newPage;
        [navigationStack addObject:newView];
        [newView viewWillAppear:YES];
        [keepPage viewWillDisappear:YES];
        newView.view.frame = CGRectMake((keepPage.view.frame.origin.x + 320), 0, 320, 480);
        [slideView addSubview:newView.view];
        slideView.contentSize = CGSizeMake((newView.view.frame.origin.x + 320), 480);
        [slideView setContentOffset:CGPointMake(newView.view.frame.origin.x, 0) animated:YES];
        _currentPage = 1;
        //keepPage.view.frame = CGRectMake(-320, 0, 320, 480);
        //[slideView setContentOffset:CGPointMake(-320, 0) animated:NO];
        //slideView.contentSize = CGSizeMake(640, 480);
        //newView.view.frame = CGRectMake(0, 0, 320, 480);
        //[slideView addSubview:newView.view];
        
       
        //[slideView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
        
    }
  /*  UIViewController *keepPage = (UIViewController *)[navigationStack objectAtIndex:([self currentPage] -1)];
    if ([navigationStack count] > 1)
    {
        for (UIViewController * i in navigationStack)
        {
            if (i != keepPage) {
                [i.view removeFromSuperview];
            }
            
        }
        
        [navigationStack removeAllObjects];
    }
    
    
    keepPage.view.frame = CGRectMake(-320, 0, 320, 480);
   
    //slideView.contentSize = CGSizeMake(320, 480);
    [slideView setContentOffset:CGPointMake(-320, 0) animated:NO];
    UIViewController *newView = (UIViewController *)newPage;
    newView.view.frame = CGRectMake(0, 0, 320, 480);
    [slideView addSubview:newView.view];
    [slideView setContentOffset:CGPointMake(0, 0) animated:YES];
    //slideView.contentSize = CGSizeMake(320, 480);
    //[keepPage.view removeFromSuperview];
    //[navigationStack removeObject:keepPage];
    //UIViewController *newestPage = (UIViewController *)newPage;
    //newestPage.view.frame = CGRectMake(0, 0, 320, 480);
    //[slideView setContentOffset:CGPointMake(0, 0) animated:NO];
    //slideView.contentSize = CGSizeMake(320, 480);
   // [self addNewPage:newPage];
   // [slideView setContentOffset:CGPointMake(0, 0) animated:YES];
   
    */
}
-(void)scrollToPage:(int)page{
    [slideView setContentOffset:CGPointMake((320 * (page - 1)), 0) animated:YES];
    
}
-(void)scrollToLastPage{
    if (scrollStop == 0) {
        [self scrollToPage:[navigationStack count]];
    }else{
        [self scrollToPage:scrollStop];
    }
    
}
-(void)scrollToFirstPage{
    [self scrollToPage:1];
}

- (void) removePage:(int)page
{
    //Desperately needs rewritten. creates holes in navigation. also needs animation to close gaps.
    NSLog(@"Remove Page Called");
   /* if ([self pageCount] > 1)
    {
        if (page == [self currentPage])
        {
            if (page - 1 >= 1)
                [self scrollToPage:(page - 1)];
            else
                [self scrollToPage:(page + 1)];
        }
        
        [[[navigationStack objectAtIndex:(page - 1)] view] removeFromSuperview];
        [navigationStack removeObjectAtIndex:(page) - 1];
        
        slideView.contentSize = CGSizeMake(([navigationStack count]*320), 480);
    }*/
}

-(void) removeAllPages
{
    NSLog(@"Remove All Pages Called");
   /* if ([navigationStack count] > 0)
    {
        for (UIViewController * i in navigationStack)
        {
            [i.view removeFromSuperview];
        }
        
        [navigationStack removeAllObjects];
    }*/
}


- (void) updateCurrentPageBasedOnScroll
{
    int pageNum = (((slideView.contentOffset.x+10)/320)+1);
    NSLog(@"Current Page:%i PageNum:%i contentoffset:%f", _currentPage, pageNum, slideView.contentOffset.x);
    [self setCurrentPage:pageNum];
}

- (void) setCurrentPage:(int)pageNum
{
    NSLog(@"Set Current Page Called with curPage %i and newPage %i", _currentPage, pageNum);
    if (_currentPage != pageNum)
    {
        if (_currentPage > 0 && [navigationStack count] > 0) [[navigationStack objectAtIndex:_currentPage - 1] viewDidDisappear:YES];
        
        if (pageNum > 0 && [navigationStack count] > 0) [[navigationStack objectAtIndex:pageNum - 1] viewDidAppear:YES];
        
        _currentPage = pageNum;
        
        NSLog(@"Updated current page to %d",_currentPage);
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Scroll View Did End Deseleration");
    if (removePage == nil) {
    [self updateCurrentPageBasedOnScroll];
   /* if (scrollStop == 0) {
        slideView.contentSize = CGSizeMake((([navigationStack count] * 320)+1), 480);
    }else{
        slideView.contentSize = CGSizeMake(((scrollStop * 320)+1), 480);
    }*/
    
    NSLog(@"Scrolled to page %d",[self currentPage]);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSLog(@"Scroll View Did End Animation");
    if ((removePage != nil)&&([navigationStack count] == 1)) {
        NSLog(@"Do Some Shit");
        UIViewController *keepPage = (UIViewController *)[navigationStack objectAtIndex:0];
        [keepPage viewDidAppear:YES];
       [keepPage.view setFrame:CGRectMake(0, 0, 320, 480)];
       [slideView setContentOffset:CGPointMake(0, 0) animated:NO];
       slideView.contentSize = CGSizeMake(320, 480);
       _currentPage = 1;
        [removePage.view removeFromSuperview];
        [removePage viewDidDisappear:YES];
        
        removePage = nil;
        
    }
    [self updateCurrentPageBasedOnScroll];
}

- (void)dealloc{
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
