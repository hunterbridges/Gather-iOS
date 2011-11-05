#import "FinalizeVC.h"
#import "GatherAPI.h"
#import "SessionData.h"
#import "GatherAppState.h"

@implementation FinalizeVC

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
  if (!requested_)
  {
    NSMutableDictionary * dict =
        [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:[[SessionData sharedSessionData] token] forKey:@"token"];
    [dict setObject:[[SessionData sharedSessionData] verification]
             forKey:@"verification"];

    [GatherAPI request:@"users/me" requestMethod:@"GET" requestData:dict];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(connectionFinished:)
               name:@"GETusers/me"
             object:nil];

    message_.text = kFinalizingText;

    [[[UIApplication sharedApplication] delegate]
        setAppState:kGatherAppStateLoggedOutFinalizing];

    requested_ = YES;
  }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)connectionFinished:(NSNotification*)notification {
  NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
  NSMutableURLRequest * req = [dict objectForKey:@"request"];

  if ([GatherAPI request:req isCallToMethod:@"users/me"]) {
    NSString * str =
        [[NSString alloc] initWithData:[dict objectForKey:@"data"]
                              encoding:NSUTF8StringEncoding];
    id json = [str JSONValue];
    
    if ([json objectForKey:@"id"] != nil) {
      [[SessionData sharedSessionData]
          setCurrentUserId:[[json objectForKey:@"id"] intValue]];
    }
    
    [[SessionData sharedSessionData] setLoggedIn:YES];
    [[SessionData sharedSessionData] saveSession];
    
    // TODO: Should we be using app delegate here?
    [[[UIApplication sharedApplication] delegate] resetNavigationForAuthState];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@", str);
    [str release];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [message_ setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:20]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
