#import <UIKit/UIKit.h>

#import "AppContext.h"

@interface LoginVC : UIViewController <UITextFieldDelegate> {
  IBOutlet UITextField * phoneNumberField_;
  IBOutlet UILabel * instructionsLabel_;
  IBOutlet UILabel * phoneNumberLabel_;
  
  AppContext *ctx_;
}

@property (nonatomic, retain) AppContext *ctx;

@end
