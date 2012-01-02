#import "FontManager.h"
#import "GatherAppDelegate.h"
#import "GatherAppState.h"
#import "GatherServer.h"
#import "GolfballGrippies.h"
#import "LoginVC.h"
#import "PhoneNumberFormatter.h"
#import "SessionData.h"
#import "SlideNavigationController.h"
#import "SlideViewController.h"
#import "UIColor+Gather.h"
#import "ValidateVC.h"

@implementation LoginVC
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
  [phoneNumberField_ release];
  [instructionsLabel_ release];
  [phoneNumberLabel_ release];
  //[grippies_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor lightBackgroundColor];
  [phoneNumberLabel_ setFont:[ctx_.fontManager contentFontWithSize:50]];

  [instructionsLabel_ setFont:[ctx_.fontManager contentFontWithSize:20]];
  /*
  grippies_ =
      [[GolfballGrippies alloc] initWithFrame:CGRectMake(64, 174, 192, 60)];
  grippies_.currentAnimation = kGolfballGrippiesAnimationNone;
  grippies_.enabled = NO;
   */
  [self.view addSubview:grippies_];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppearInSlideNavigation {
  [super viewDidAppearInSlideNavigation];
  slideNavigation_.grippies.frame = CGRectMake(64, 174, 192, 60);
  [slideNavigation_ makeGrippiesVisible:YES animated:YES];
  [phoneNumberField_ becomeFirstResponder];
}

- (void)viewDidDisappearInSlideNavigation {
  //[self.slideNavigation setGrabberRect:CGRectZero];
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
      phoneNumberLabel_.textColor = [UIColor whenColor];
      
      [ctx_.server.sessionData setPhoneNumber:post];
      ctx_.appState = kGatherAppStateLoggedOutHasPhoneNumber;
      
      ValidateVC *new = [[ValidateVC alloc] initWithNibName:@"ValidateVC"
                                                     bundle:nil];
      new.ctx = ctx_;
      
      slideNavigation_.grippies.enabled = YES;
      slideNavigation_.grippies.currentAnimation = kGolfballGrippiesAnimationLeft;
      
      //[self.slideNavigation setGrabberRect:grippies_.frame];
      [self.slideNavigation addNewPage:new];
      [new release];
    } else {
      instructionsLabel_.text = @"HELLO. WHAT IS YOUR CELL PHONE NUMBER?";
      phoneNumberLabel_.textColor = [UIColor darkerTextColor];
        
      ctx_.appState = kGatherAppStateLoggedOutNeedsPhoneNumber;
      
      slideNavigation_.grippies.enabled = NO;
      slideNavigation_.grippies.currentAnimation = kGolfballGrippiesAnimationNone;
      
      [ctx_.server.sessionData setPhoneNumber:nil];
      if (self.slideNavigation.pageCount > 1) {
        //[self.slideNavigation setGrabberRect:CGRectZero];
        [grippies_ setScrollViewLeft:nil];
        [self.slideNavigation removeLastPage];
      }
    }
    [pn release];
    return TRUE;
  }
}


@end
