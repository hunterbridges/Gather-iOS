#import <UIKit/UIKit.h>

#import "GatherRequestDelegate.h"
#import "SlideViewController.h"

// TODO: Move to strings file
static NSString * kFinalizingText = @"LOGGING IN...";

@class AppContext;
@class GatherRequest;
@interface FinalizeVC : SlideViewController <GatherRequestDelegate> {
  IBOutlet UILabel * message_;
  BOOL requested_;
  
  AppContext *ctx_;
  GatherRequest *userInfoRequest_;
}

@property (nonatomic, retain) AppContext *ctx;
@end
