#import "DoubleResponderScrollView.h"
#import "SlideNavigationController.h"
#import "SlideViewController.h"

@implementation SlideNavigationController
@synthesize scrollView = scrollView_;

- (id)init {
  self = [super init];
  if (self) {
    scrollView_ =
        [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView_.scrollEnabled = NO;
    scrollView_.pagingEnabled = YES;
    scrollView_.directionalLockEnabled = YES;
    scrollView_.showsVerticalScrollIndicator = NO;
    scrollView_.showsHorizontalScrollIndicator = NO;
    scrollView_.delegate = self;
    scrollView_.backgroundColor = [UIColor blackColor];
    scrollView_.autoresizesSubviews = YES;
    scrollView_.contentSize = CGSizeMake(320, 480);
    scrollView_.frame = CGRectMake(0, 0, 320, 480);
    scrollView_.delaysContentTouches = NO;
    scrollStop_ = 0;
    
    navigationStack_ = [[NSMutableArray alloc] init];
    [self.view addSubview:scrollView_];
    currentPage_ = -1;
    
    grippies_ =
        [[GolfballGrippies alloc] initWithFrame:CGRectMake(64, 174, 192, 60)];
    grippies_.currentAnimation = kGolfballGrippiesAnimationNone;
    grippies_.enabled = NO;
    [grippies_ setScrollViewLeft:scrollView_];
    [grippies_ setScrollViewRight:scrollView_];
    [self.view addSubview:grippies_];
    grippies_.alpha = 0.0;
    grippies_.hidden = YES;
  }
  return self;
}

- (int)currentPage {
  return currentPage_;
}

- (int)currentIndex {
  int pageNum = (scrollView_.contentOffset.x / 320);
  return pageNum;
}

- (int)pageCount {
  return [navigationStack_ count];
}

- (void)setScrollStop:(int)atPage {
  scrollStop_ = atPage;
  scrollView_.contentSize = CGSizeMake(((atPage * 320)+1), 480);
}

- (void)resetScrollStop {
  [self setScrollStop:(int)[navigationStack_ count]];
   scrollStop_ = 0;
}

- (void)addNewPage:(SlideViewController *)newPage {
  newPage.view.frame = CGRectMake(([navigationStack_ count] * 320),
                                  0,
                                  320,
                                  480);
  newPage.slideNavigation = self;
  [scrollView_ addSubview:newPage.view];

  scrollView_.contentSize =
      CGSizeMake((([navigationStack_ count] * 320) + 320),
                 480);
  [navigationStack_ addObject:newPage];
  if ([navigationStack_ count] == 1) {
    [newPage viewWillAppearInSlideNavigation];
    [newPage viewDidAppearInSlideNavigation];
    self.currentPage = 1;
  }
  
  if (scrollStop_ != 0) {
      [self setScrollStop:scrollStop_];
  }
}

- (void)pushNewPage:(SlideViewController *)newPage {
    [self addNewPage:newPage];
    [self scrollToLastPage];
}

- (void)resetWithPage:(SlideViewController *)newPage {
  [self disableGrippies];
  if ([navigationStack_ count] == 0) {
    [self addNewPage:newPage];
  } else{
    for (SlideViewController *i in navigationStack_) {
      [i viewWillDisappearFromSlideNavigation];
      [i.view removeFromSuperview];
      [i viewDidDisappearInSlideNavigation];
    }
    [navigationStack_ removeAllObjects];
    scrollStop_ = 0;
    [self addNewPage:newPage];
    [scrollView_ setContentOffset:CGPointMake(0, 0)
                        animated:YES];
  }
}

- (void)scrollToPage:(int)page {
  [scrollView_ setContentOffset:CGPointMake((320 * (page - 1)), 0)
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

- (void)removeLastPage {
  // TODO
  SlideViewController *svc = [navigationStack_ lastObject];
  [svc.view removeFromSuperview];
  [navigationStack_ removeObject:svc];
  scrollView_.contentSize =
      CGSizeMake(([navigationStack_ count] * 320),
                 480);
}

- (void)removeAllPages {
  // TODO
  NSLog(@"Remove All Pages Called");
}


- (void)updateCurrentPageBasedOnScroll {
  int pageNum = (((scrollView_.contentOffset.x+10)/320)+1);
  [self setCurrentPage:pageNum];
}

- (void)setCurrentPage:(int)pageNum {
  if (currentPage_ != pageNum) {
    if (currentPage_ > 0 && [navigationStack_ count] > 0) {
      if (currentPage_ - 1 < [navigationStack_ count]) {
        [[navigationStack_ objectAtIndex:currentPage_ - 1]
            viewDidDisappearInSlideNavigation];
      }
    }
    
    if (pageNum > 0 && [navigationStack_ count] > 0) {
      [[navigationStack_ objectAtIndex:pageNum - 1]
          viewDidAppearInSlideNavigation];
    }
    
    currentPage_ = pageNum;
  }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (removePage_ == nil) {
    [self updateCurrentPageBasedOnScroll];
  }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  if ((removePage_ != nil)&&([navigationStack_ count] == 1)) {
    SlideViewController *keepPage = (SlideViewController *)
        [navigationStack_ objectAtIndex:0];
    [keepPage viewDidAppear:YES];
    [keepPage.view setFrame:CGRectMake(0, 0, 320, 480)];
    [scrollView_ setContentOffset:CGPointMake(0, 0) animated:NO];
    scrollView_.contentSize = CGSizeMake(320, 480);
    [removePage_.view removeFromSuperview];
    [removePage_ viewDidDisappear:YES];

    removePage_ = nil;
  }
  [self updateCurrentPageBasedOnScroll];
}

- (void)dealloc {
  [scrollView_ release];
  [navigationStack_ release];
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
