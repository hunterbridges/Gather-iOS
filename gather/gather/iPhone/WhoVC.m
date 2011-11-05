#import "WhoVC.h"
#import "SessionData.h"

@implementation WhoVC

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
  // TODO: Centralize font management
  header.font = [UIFont fontWithName:@"UniversLTStd-UltraCn" size:60];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) logoutClicked:(id)sender {
  [[SessionData sharedSessionData] clear];
  
  [[[UIApplication sharedApplication] delegate] resetNavigationForAuthState];
}
@end