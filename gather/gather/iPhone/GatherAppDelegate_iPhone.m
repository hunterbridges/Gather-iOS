#import "GatherAppDelegate_iPhone.h"
#import "LoginVC.h"
#import "SessionData.h"
#import "SplitListViewController.h"
#import "ViewPlaceHolder.h"
#import "WhoVC.h"

@implementation GatherAppDelegate_iPhone
@synthesize slideView = slideView_;
@synthesize appState = appState_;

- (void)dealloc {
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Iphone Launched");
  slideView_ = [[SlideViewController alloc] init];
  [self.window addSubview:slideView_.view];
    
  [self resetNavigationForAuthState];
    
  return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  NSString * _stripped =
      [[url absoluteString] stringByReplacingOccurrencesOfString:@"gather://"
                                                      withString:@""];
  NSArray * uriSegments = [_stripped componentsSeparatedByString:@"/"];

  if ([[uriSegments objectAtIndex:0] isEqualToString:@"verify"]) {
    NSLog(@"Verify with code %@", [uriSegments objectAtIndex:1]);

    if (appState_ == kGatherAppStateLoggedOutNeedsVerification) {
      NSMutableDictionary * _userData =
          [[[NSMutableDictionary alloc] init] autorelease];
      [_userData setObject:[uriSegments objectAtIndex:1] forKey:@"verification"];
        
      [[NSNotificationCenter defaultCenter]
          postNotificationName:@"verification_from_link"
                        object:nil
                      userInfo:_userData];
    }

    return YES;
  }

  return NO;
}

- (void)resetNavigationForAuthState {
  NSLog(@"Resetting Naviation State");
  if (![[SessionData sharedSessionData] loggedIn]) {
    LoginVC *newPage = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    [slideView_ resetWithPage:newPage];
    [self setAppState:kGatherAppStateLoggedOutNeedsPhoneNumber];
  } else {
    SplitListViewController *newSplit = [[SplitListViewController alloc] init];
    [slideView_ resetWithPage:newSplit];
    [self setAppState:kGatherAppStateLoggedIn];
  }
}

@end
