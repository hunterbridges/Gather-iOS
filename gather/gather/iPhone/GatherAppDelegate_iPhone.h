#import <UIKit/UIKit.h>

#import "GatherAppDelegate.h"
#import "GatherAppState.h"

@class AppContext;
@class SlideNavigationController;
@interface GatherAppDelegate_iPhone : GatherAppDelegate {
  AppContext *ctx_;
  SlideNavigationController *slideView_;
  GatherAppState appState_;
}

- (void)resetNavigationForAuthState;

@property (nonatomic, retain) SlideNavigationController *slideView;
@property (nonatomic) GatherAppState appState;

@end
