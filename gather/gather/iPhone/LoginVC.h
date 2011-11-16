#import <UIKit/UIKit.h>

#import "AppContext.h"
#import "SlideViewController.h"
#import "SlideNavigationController.h"

@class GolfballGrippies;
@protocol GolfballGrippiesDelegate;
@interface LoginVC : SlideViewController <UITextFieldDelegate> {
  IBOutlet UITextField * phoneNumberField_;
  IBOutlet UILabel * instructionsLabel_;
  IBOutlet UILabel * phoneNumberLabel_;
  
  AppContext *ctx_;
  GolfballGrippies *grippies_;
}

@property (nonatomic, retain) AppContext *ctx;

@end
