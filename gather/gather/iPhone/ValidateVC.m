#import "ValidateVC.h"
#import "SessionData.h"
#import "GatherAPI.h"
#import "SBJson.h"
#import "NSObject+SBJson.h"
#import "GatherAppState.h"
#import "FinalizeVC.h"

@implementation ValidateVC

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [verificationLabel_ setFont:
        [UIFont fontWithName:@"UniversLTStd-UltraCn" size:60]];
    [message_ setFont:
        [UIFont fontWithName:@"UniversLTStd-UltraCn" size:20]];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(externalVerification:)
               name:@"verification_from_link"
             object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
  if (!requested_) {
    NSString * udid =
        [[[UIDevice currentDevice] uniqueIdentifier]
            stringByReplacingOccurrencesOfString:@"-"
                                      withString:@""];
      
    NSMutableDictionary * dict =
        [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:[[SessionData sharedSessionData] phoneNumber]
             forKey:@"phone_number"];
    [dict setObject:udid
             forKey:@"device_udid"];
    [dict setObject:[[UIDevice currentDevice] model]
             forKey:@"device_type"];
    [GatherAPI request:@"tokens"
         requestMethod:@"POST"
           requestData:dict];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(connectionFinished:)
               name:@"POSTtokens"
             object:nil];
    
    message_.text = kCommunicatingText;
    requested_ = YES;
  }
    
  if ([message_.text isEqualToString:kEnterVerificationText] ||
    [message_.text isEqualToString:kSwipeLeftText]) {
    [verificationField_ becomeFirstResponder];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
    [verificationField_ resignFirstResponder];
}

- (void)connectionFinished:(NSNotification*)notification {
    NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
    NSMutableURLRequest * req = [dict objectForKey:@"request"];
    
  if ([GatherAPI request:req isCallToMethod:@"tokens"]) {
    NSString * str =
        [[NSString alloc] initWithData:[dict objectForKey:@"data"]
                              encoding:NSUTF8StringEncoding];
    id json = [str JSONValue];
    if ([json objectForKey:@"token"] != nil)
    {
      [[SessionData sharedSessionData] setToken:[json objectForKey:@"token"]];
      
      [[[UIApplication sharedApplication] delegate]
          setAppState:kGatherAppStateLoggedOutNeedsVerification];
      message_.text = kEnterVerificationText;
      [verificationField_ becomeFirstResponder];
    }
    
    NSLog(@"%@", str);
    [str release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }
}

- (void)externalVerification:(NSNotification*)notification {
  verificationField_.text =
      [[notification userInfo] objectForKey:@"verification"];
  [self verificationDisplayFilter:
      [[notification userInfo] objectForKey:@"verification"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
  NSCharacterSet * set =
      [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
          invertedSet];
  
  if ([string rangeOfCharacterFromSet:set].location != NSNotFound) {
    return FALSE;
  } else {
    NSString * post =
        [[textField text] stringByReplacingCharactersInRange:range
                                                  withString:string];
    [self verificationDisplayFilter:post];
    return TRUE;
  }
}

- (void) verificationDisplayFilter:(NSString *) post {
  verificationLabel_.text = post;
    
  if ([post length] == 6) {
    message_.text = kSwipeLeftText;
    
    [[[UIApplication sharedApplication] delegate]
        setAppState:kGatherAppStateLoggedOutHasVerification];
    
    verificationLabel_.textColor = [UIColor colorWithRed:1.0
                                                   green:93.0/255.0
                                                    blue:53.0/255.0
                                                   alpha:1.0];
    
    [[SessionData sharedSessionData] setVerification:post];
    
    FinalizeVC *new =
       [[FinalizeVC alloc] initWithNibName:@"FinalizeVC" bundle:nil];
    [[[[UIApplication sharedApplication] delegate] slideView] addNewPage:new];
  } else {
    message_.text = kEnterVerificationText;
    [[[UIApplication sharedApplication] delegate]
        setAppState:kGatherAppStateLoggedOutNeedsVerification];
    
    [[SessionData sharedSessionData] setVerification:nil];
    verificationLabel_.textColor = [UIColor blackColor];
  }
}
@end
