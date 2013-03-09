#import "GHRCubeNavController.h"
#import "GHRViewController.h"
#import "GHRShadedView.h"

@interface GHRCubeNavController ()

@end

@implementation GHRCubeNavController {
  NSMutableArray *navigationStack_;
  GHRShadedView *viewContainer_;
  GHRShadedView *leftView_;
  GHRShadedView *rightView_;
}

- (void)dealloc {
  [leftView_ release];
  [rightView_ release];
  [viewContainer_ release];
  [navigationStack_ release];
  [super dealloc];
}

- (id)init {
  self = [super init];
  if (self) {
    navigationStack_ = [[NSMutableArray alloc] init];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  viewContainer_ = [[GHRShadedView alloc] initWithFrame:self.view.bounds];
  viewContainer_.backgroundColor = [UIColor blackColor];
  [self.view addSubview:viewContainer_];
  
  leftView_ = [[GHRShadedView alloc] initWithFrame:self.view.bounds];
  leftView_.backgroundColor = [UIColor blackColor];
  leftView_.faceShading = -1;
  [self.view addSubview:leftView_];
  leftView_.hidden = YES;
  
  rightView_ = [[GHRShadedView alloc] initWithFrame:self.view.bounds];
  rightView_.backgroundColor = [UIColor blackColor];
  rightView_.faceShading = 1;
  [self.view addSubview:rightView_];
  rightView_.hidden = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)addVC:(GHRViewController *)vc toView:(UIView *)view {
  [vc setNavController:self];
  vc.view.frame = view.bounds;
  vc.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                              UIViewAutoresizingFlexibleWidth);
  [view addSubview:vc.view];
  [self addChildViewController:vc];
  [vc didMoveToParentViewController:self];
}

- (void)pushViewController:(GHRViewController *)vc withAnimation:(BOOL)animate {
  
  if (animate && navigationStack_.count > 0) {
    
  } else {
    if (navigationStack_.count > 0) {
      [leftView_ addSubview:[[navigationStack_ lastObject] view]];
    }
    [self addVC:vc toView:viewContainer_];
  }  
}

@end
