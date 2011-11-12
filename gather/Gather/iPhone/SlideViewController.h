#import <UIKit/UIKit.h>

#import "SlideNavigationController.h"

@interface SlideViewController : UIViewController {
  SlideNavigationController *slideNavigation_;
}

- (void)viewWillAppearInSlideNavigation;
- (void)viewDidAppearInSlideNavigation;
- (void)viewWillDisappearFromSlideNavigation;
- (void)viewDidDisappearInSlideNavigation;

@property (nonatomic, assign) SlideNavigationController *slideNavigation;
@end
