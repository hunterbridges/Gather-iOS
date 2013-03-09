#import "GHRViewController.h"
#import "GHRCubeNavController.h"

@interface GHRViewController ()

@end

@implementation GHRViewController
@synthesize navController = navController_;
- (void)dealloc {
  [navController_ release];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (GHRViewController *)nextVC {
  return nil;
}

@end
