//
//  LoginVC.h
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginVC : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField * phoneNumberField;
    IBOutlet UILabel * instructionsLabel;
    IBOutlet UILabel * phoneNumberLabel;
}

@end
