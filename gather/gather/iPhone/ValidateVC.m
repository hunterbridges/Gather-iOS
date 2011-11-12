#import "AppContext.h"
#import "FinalizeVC.h"
#import "GatherAppState.h"
#import "GatherRequest.h"
#import "GatherRequestDelegate.h"
#import "GatherServer.h"
#import "NSObject+SBJson.h"
#import "SBJson.h"
#import "SessionData.h"
#import "ValidateVC.h"

@implementation ValidateVC
@synthesize ctx = ctx_;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)dealloc {
  [ctx_ release];
  [tokenRequest_ release];
  [message_ release];
  [verificationLabel_ release];
  [verificationField_ release];
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
  if (!tokenRequest_) {
    NSString *phoneNumber = ctx_.server.sessionData.phoneNumber;
    
    tokenRequest_ =
        [[ctx_.server requestTokenWithPhoneNumber:phoneNumber
                                     withDelegate:self] retain];
    
    message_.text = kCommunicatingText;
  }
    
  if ([message_.text isEqualToString:kEnterVerificationText] ||
    [message_.text isEqualToString:kSwipeLeftText]) {
    [verificationField_ becomeFirstResponder];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
    [verificationField_ resignFirstResponder];
}

- (void)gatherRequest:(GatherRequest *)request
   didSucceedWithJSON:(id)json {
  NSLog(@"Deed it!");
  if ([request isEqual:tokenRequest_]) {
    if ([json objectForKey:@"token"] != nil)
    {
      ctx_.server.sessionData.token = [json objectForKey:@"token"];
      ctx_.appState = kGatherAppStateLoggedOutNeedsVerification;
      message_.text = kEnterVerificationText;
      [verificationField_ becomeFirstResponder];
      [tokenRequest_ release];
      tokenRequest_ = nil;
    }
  }
}

- (void)gatherRequest:(GatherRequest *)request
    didFailWithReason:(GatherRequestFailureReason)reason {
  // TODO: Catch failure
  NSLog(@"FAILED!");
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
    
    ctx_.appState = kGatherAppStateLoggedOutHasVerification;
    
    verificationLabel_.textColor = [UIColor colorWithRed:1.0
                                                   green:93.0/255.0
                                                    blue:53.0/255.0
                                                   alpha:1.0];
    
    ctx_.server.sessionData.verification = post;
    
    FinalizeVC *new =
       [[FinalizeVC alloc] initWithNibName:@"FinalizeVC" bundle:nil];
    [[[[UIApplication sharedApplication] delegate] slideView] addNewPage:new];
    [new release];
  } else {
    message_.text = kEnterVerificationText;
    ctx_.appState = kGatherAppStateLoggedOutNeedsVerification;
    
    ctx_.server.sessionData.verification = nil;
    verificationLabel_.textColor = [UIColor blackColor];
  }
}
@end
