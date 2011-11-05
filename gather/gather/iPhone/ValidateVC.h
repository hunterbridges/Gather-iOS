#import <UIKit/UIKit.h>

static NSString * kCommunicatingText = @"COMMUNICATING...";
static NSString * kEnterVerificationText =
    @"YOU WILL RECEIVE YOUR VERIFICATION CODE VIA TEXT IN A MOMENT. "
    @"YOU CAN ENTER IT BELOW.";
static NSString * kSwipeLeftText = @"SWIPE LEFT TO FINISH";

@interface ValidateVC : UIViewController {
  IBOutlet UILabel * message_;
  IBOutlet UILabel * verificationLabel_;
  IBOutlet UITextField * verificationField_;
  BOOL requested_;
}

- (void)verificationDisplayFilter:(NSString *)post;
@end
