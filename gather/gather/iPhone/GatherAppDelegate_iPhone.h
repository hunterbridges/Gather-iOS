#import <UIKit/UIKit.h>

#import "GatherAppDelegate.h"
#import "GatherAppState.h"
#import "SlideViewController.h"

@interface GatherAppDelegate_iPhone : GatherAppDelegate {
    SlideViewController *slideView_;
    GatherAppState appState_;
}

- (void)resetNavigationForAuthState;

@property (nonatomic, retain) SlideViewController *slideView;
@property (nonatomic) GatherAppState appState;

@end
