#import "SlideViewController.h"

@implementation SlideViewController

- (id)init {
  self = [super init];
  if (self) {
    slideView_ = [[UIScrollView alloc] initWithFrame:self.view.frame];
    slideView_.scrollEnabled = YES;
    slideView_.pagingEnabled = YES;
    slideView_.directionalLockEnabled = YES;
    slideView_.showsVerticalScrollIndicator = NO;
    slideView_.showsHorizontalScrollIndicator = NO;
    slideView_.delegate = self;
    slideView_.backgroundColor = [UIColor blackColor];
    slideView_.autoresizesSubviews = YES;
    slideView_.contentSize = CGSizeMake(320, 480);
    slideView_.frame = CGRectMake(0, 0, 320, 480);
    scrollStop_ = 0;
    
    navigationStack_ = [[NSMutableArray alloc] init];
    [self.view addSubview:slideView_];
  }
  return self;
}

- (int)currentPage {
  return currentPage_;
}

- (int)currentIndex {
  int pageNum = (slideView_.contentOffset.x / 320);
  return pageNum;
}

- (int)pageCount {
  return [navigationStack_ count];
}

- (void)setScrollStop:(int)atPage {
  scrollStop_ = atPage;
  NSLog(@"Setting Scroll Stop to Page %i", atPage);
  slideView_.contentSize = CGSizeMake(((atPage * 320)+1), 480);
}

- (void)resetScrollStop {
  [self setScrollStop_:[navigationStack_ count]];
   scrollStop_ = 0;
}

- (void)addNewPage:(id)newPage {
  NSLog(@"Attempting to add view");
  if ([[newPage class] isSubclassOfClass:[UIViewController class]]) {
    NSLog(@"Adding View");
    UIViewController *newView = (UIViewController *)newPage;
    newView.view.frame = CGRectMake(([navigationStack_ count] * 320),
                                    0,
                                    320,
                                    480);
    [slideView_ addSubview:newView.view];

    slideView_.contentSize =
        CGSizeMake((([navigationStack_ count] * 320) + 320),
                   480);
    [navigationStack_ addObject:newPage];
    if ([navigationStack_ count] == 1) {
        [newPage viewWillAppear:YES];
        [newPage viewDidAppear:YES];
        currentPage_ = 1;
    }
    
    NSLog(@"Stack Count %i", [navigationStack_ count]);
    if (scrollStop_ !=0) {
        [self setScrollStop_:scrollStop_];
    }
  }
}

- (void)pushNewPage:(id)newPage {
    [self addNewPage:newPage];
    [self scrollToLastPage];
}

- (void)resetWithPage:(id)newPage {
  if ([navigationStack_ count] == 0) {
     UIViewController *newView = (UIViewController *)newPage;
    currentPage_ = 1;
    [self addNewPage:newView];
  } else{
    UIViewController *keepPage = (UIViewController *)
        [navigationStack_ objectAtIndex:([self currentPage] -1)];
    for (UIViewController * i in navigationStack_) {
      if (i != keepPage) {
        [i viewWillDisappear:NO];
        [i.view removeFromSuperview];
        [i viewDidDisappear:NO];
      }
    }
    [navigationStack_ removeAllObjects];
    removePage_ = keepPage;
    scrollStop_ = 0;
    UIViewController *newView = (UIViewController *)newPage;
    [navigationStack_ addObject:newView];
    [newView viewWillAppear:YES];
    [keepPage viewWillDisappear:YES];
    newView.view.frame = CGRectMake((keepPage.view.frame.origin.x + 320),
                                    0,
                                    320,
                                    480);
    [slideView_ addSubview:newView.view];
    slideView_.contentSize = CGSizeMake((newView.view.frame.origin.x + 320),
                                       480);
    [slideView_ setContentOffset:CGPointMake(newView.view.frame.origin.x,
                                            0)
                       animated:YES];
    currentPage_ = 1;

    // TODO: Wtf is this?
    //keepPage.view.frame = CGRectMake(-320, 0, 320, 480);
    //[slideView setContentOffset:CGPointMake(-320, 0) animated:NO];
    //slideView.contentSize = CGSizeMake(640, 480);
    //newView.view.frame = CGRectMake(0, 0, 320, 480);
    //[slideView addSubview:newView.view];
    
    //[slideView setContentOffset:CGPointMake(0, 0) animated:YES];
  }
  // TODO: Wtf is this?
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

- (void)scrollToPage:(int)page {
  [slideView_ setContentOffset:CGPointMake((320 * (page - 1)), 0)
                      animated:YES];
}

- (void)scrollToLastPage {
  if (scrollStop_ == 0) {
      [self scrollToPage:[navigationStack_ count]];
  } else {
      [self scrollToPage:scrollStop_];
  }
}

- (void)scrollToFirstPage {
    [self scrollToPage:1];
}

- (void)removePage:(int)page {
  // TODO: Desperately needs rewritten. creates holes in navigation.
  // also needs animation to close gaps.
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

- (void)removeAllPages {
  // TODO
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


- (void)updateCurrentPageBasedOnScroll {
  int pageNum = (((slideView_.contentOffset.x+10)/320)+1);
  NSLog(@"Current Page:%i PageNum:%i contentoffset:%f",
        currentPage_, pageNum, slideView_.contentOffset.x);
  [self setCurrentPage:pageNum];
}

- (void)setCurrentPage:(int)pageNum {
  NSLog(@"Set Current Page Called with curPage %i and newPage %i", currentPage_, pageNum);
  if (currentPage_ != pageNum) {
    if (currentPage_ > 0 && [navigationStack_ count] > 0) {
      [[navigationStack_ objectAtIndex:currentPage_ - 1] viewDidDisappear:YES];
    }
    
    if (pageNum > 0 && [navigationStack_ count] > 0) {
      [[navigationStack_ objectAtIndex:pageNum - 1] viewDidAppear:YES];
    }
    
    currentPage_ = pageNum;
    
    NSLog(@"Updated current page to %d",currentPage_);
  }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  NSLog(@"Scroll View Did End Deseleration");
  if (removePage_ == nil) {
    [self updateCurrentPageBasedOnScroll];
    /* if (scrollStop == 0) {
        slideView.contentSize = CGSizeMake((([navigationStack count] * 320)+1), 480);
    }else{
        slideView.contentSize = CGSizeMake(((scrollStop * 320)+1), 480);
    }*/

    NSLog(@"Scrolled to page %d",[self currentPage]);
  }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  NSLog(@"Scroll View Did End Animation");
  if ((removePage_ != nil)&&([navigationStack_ count] == 1)) {
    NSLog(@"Do Some Shit");
    UIViewController *keepPage = (UIViewController *)[navigationStack_ objectAtIndex:0];
    [keepPage viewDidAppear:YES];
    [keepPage.view setFrame:CGRectMake(0, 0, 320, 480)];
    [slideView_ setContentOffset:CGPointMake(0, 0) animated:NO];
    slideView_.contentSize = CGSizeMake(320, 480);
    currentPage_ = 1;
    [removePage_.view removeFromSuperview];
    [removePage_ viewDidDisappear:YES];

    removePage_ = nil;
  }
  [self updateCurrentPageBasedOnScroll];
}

- (void)dealloc {
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
