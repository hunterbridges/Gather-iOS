#import <UIKit/UIKit.h>

#import "AppContext.h"
#import "SlideViewController.h"
#import "SlideNavigationController.h"

@interface LoginVC : SlideViewController <UITextFieldDelegate> {
  IBOutlet UITextField * phoneNumberField_;
  IBOutlet UILabel * instructionsLabel_;
  IBOutlet UILabel * phoneNumberLabel_;
  
  AppContext *ctx_;
}

@property (nonatomic, retain) AppContext *ctx;

@end
