#import "AppContext.h"
#import "FinalizeVC.h"
#import "FontManager.h"
#import "GatherAppState.h"
#import "GatherRequestDelegate.h"
#import "GatherServer.h"
#import "SessionData.h"
#import "SlideNavigationController.h"
#import "SlideViewController.h"

@implementation FinalizeVC
@synthesize ctx;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)dealloc {
  [ctx_ release];
  [message_ release];
  [userInfoRequest_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidAppearInSlideNavigation {
  [super viewDidAppearInSlideNavigation];
  if (!requested_) {
    userInfoRequest_ = 
        [[self.ctx.server requestInfoForCurrentUserWithDelegate:self] retain];
    message_.text = kFinalizingText;
    self.ctx.appState = kGatherAppStateLoggedOutFinalizing;
    requested_ = YES;
  }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)gatherRequest:(GatherRequest *)request
   didSucceedWithJSON:(id)json {
  if ([request isEqual:userInfoRequest_]) {
    if ([json objectForKey:@"id"] != nil) {
      self.ctx.server.sessionData.currentUserId =
          [[json objectForKey:@"id"] intValue];
      
      self.ctx.server.sessionData.loggedIn = YES;
      // TODO: I feel like session shouldn't be saved from the VC.
      [self.ctx.server.sessionData saveSession];
      
      [[NSNotificationCenter defaultCenter]
          postNotificationName:@"authStateDidChange"
                        object:nil];
    }
    
    [userInfoRequest_ release];
    userInfoRequest_ = nil;
  }
}

- (void)gatherRequest:(GatherRequest *)request
    didFailWithReason:(GatherRequestFailureReason)reason {
  // TODO: Catch failure
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [message_ setFont:[ctx_.fontManager contentFontWithSize:20]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
