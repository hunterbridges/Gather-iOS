#import <UIKit/UIKit.h>

#import "GatherRequestDelegate.h"
#import "SlideViewController.h"

@class AppContext;
@class GatherRequest;
static NSString * kCommunicatingText = @"COMMUNICATING...";
static NSString * kEnterVerificationText =
    @"YOU WILL RECEIVE YOUR VERIFICATION CODE VIA TEXT IN A MOMENT. "
    @"YOU CAN ENTER IT BELOW.";
static NSString * kSwipeLeftText = @"SWIPE LEFT TO FINISH";

@interface ValidateVC : SlideViewController <GatherRequestDelegate> {
  IBOutlet UILabel * message_;
  IBOutlet UILabel * verificationLabel_;
  IBOutlet UITextField * verificationField_;
  BOOL requested_;
  
  AppContext *ctx_;
  GatherRequest *tokenRequest_;
}

- (void)verificationDisplayFilter:(NSString *)post;

@property (nonatomic, retain) AppContext *ctx;
@end
