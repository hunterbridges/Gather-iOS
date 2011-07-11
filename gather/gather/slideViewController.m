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

- (id)init
{
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
        NSLog(@"Stack Count %i", [navigationStack count]);
        
        [self updateCurrentPageBasedOnScroll];
        
        if (scrollStop !=0) {
            [self setScrollStop:scrollStop];
        }
       
    }
}
-(void)resetWithPage:(id)newPage 
{
    [self removeAllPages];
    _currentPage = 0;
    [self addNewPage:newPage];
    [self scrollToPage:1];
}

-(void)scrollToPage:(int)page{
    [slideView setContentOffset:CGPointMake((320 * (page - 1)), 0) animated:YES];
    [self setCurrentPage:page];
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
-(void)pushNewPage:(id)newPage{
    [self addNewPage:newPage];
    [self scrollToLastPage];
    
}

- (void) removePage:(int)page
{
    if ([self pageCount] > 1)
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
    }
}

-(void) removeAllPages
{
    if ([navigationStack count] > 0)
    {
        for (UIViewController * i in navigationStack)
        {
            [i.view removeFromSuperview];
        }
        
        [navigationStack removeAllObjects];
    }
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPageBasedOnScroll];
    NSLog(@"Scrolled to page %d",[self currentPage]);
}

- (void) updateCurrentPageBasedOnScroll
{
    int pageNum = ((slideView.contentOffset.x/320)+1);
    
    [self setCurrentPage:pageNum];
}

- (void) setCurrentPage:(int)pageNum
{
    if (_currentPage != pageNum)
    {
        if (_currentPage > 0 && [navigationStack count] > 0) [[navigationStack objectAtIndex:_currentPage - 1] viewDidDisappear:NO];
        if (pageNum > 0 && [navigationStack count] > 0) [[navigationStack objectAtIndex:pageNum - 1] viewDidAppear:NO];
        
        _currentPage = pageNum;
        
        NSLog(@"Updated current page to %d",_currentPage);
    }
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
