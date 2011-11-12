#import <UIKit/UIKit.h>

#import "GatherAppDelegate.h"
#import "GatherAppState.h"

@class AppContext;
@class SlideViewController;
@interface GatherAppDelegate_iPhone : GatherAppDelegate {
  AppContext *ctx_;
  SlideViewController *slideView_;
  GatherAppState appState_;
}

- (void)resetNavigationForAuthState;

@property (nonatomic, retain) SlideViewController *slideView;
@property (nonatomic) GatherAppState appState;

@end
