#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField * phoneNumberField_;
    IBOutlet UILabel * instructionsLabel_;
    IBOutlet UILabel * phoneNumberLabel_;
}

@end
