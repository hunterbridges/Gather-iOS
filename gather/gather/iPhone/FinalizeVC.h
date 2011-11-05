#import <UIKit/UIKit.h>

static NSString * kFinalizingText = @"LOGGING IN...";

@interface FinalizeVC : UIViewController {
  IBOutlet UILabel * message_;
  BOOL requested_;
}

@end
