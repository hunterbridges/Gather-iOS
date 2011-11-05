#import "GatherAppDelegate.h"
#import "GatherAppState.h"
#import "LoginVC.h"
#import "PhoneNumberFormatter.h"
#import "SessionData.h"
#import "ValidateVC.h"

@implementation LoginVC

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
  [phoneNumberLabel_ setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn"
                                             size:60]];

  [instructionsLabel_ setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn"
                                              size:20]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [phoneNumberField_ becomeFirstResponder];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [phoneNumberField_ resignFirstResponder];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
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
      
    PhoneNumberFormatter * pn = [[PhoneNumberFormatter alloc] init];
    phoneNumberLabel_.text = [pn format:post withLocale:@"us"];
      
    if ([post length] == 10 &&
      [[[phoneNumberLabel_ text] substringToIndex:1] isEqualToString:@"("]) {
      instructionsLabel_.text = @"SWIPE LEFT TO LOG IN";
      phoneNumberLabel_.textColor = [UIColor colorWithRed:1.0
                                                    green:93.0/255.0
                                                     blue:53.0/255.0
                                                    alpha:1.0];
      
      [[SessionData sharedSessionData] setPhoneNumber:post];
      [[[UIApplication sharedApplication] delegate]
          setAppState:kGatherAppStateLoggedOutHasPhoneNumber];
      
      ValidateVC *new = [[ValidateVC alloc] initWithNibName:@"ValidateVC"
                                                     bundle:nil];
      // TODO: Why accessing slideView on app delegate directly here?
      [[[[UIApplication sharedApplication] delegate] slideView] addNewPage:new];
    } else {
      instructionsLabel_.text = @"HELLO. WHAT IS YOUR CELL PHONE NUMBER?";
      phoneNumberLabel_.textColor = [UIColor blackColor];
        
      [[[UIApplication sharedApplication] delegate]
          setAppState:kGatherAppStateLoggedOutNeedsPhoneNumber];
      
      [[SessionData sharedSessionData] setPhoneNumber:nil];
    }
    return TRUE;
  }
}

@end
