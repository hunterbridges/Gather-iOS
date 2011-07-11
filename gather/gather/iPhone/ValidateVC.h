//
//  ValidateVC.h
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * kCommunicatingText = @"COMMUNICATING...";
static NSString * kEnterVerificationText = @"YOU WILL RECEIVE YOUR VERIFICATION CODE VIA TEXT IN A MOMENT. YOU CAN ENTER IT BELOW.";
static NSString * kSwipeLeftText = @"SWIPE LEFT TO FINISH";

@interface ValidateVC : UIViewController {
    IBOutlet UILabel * message;
    IBOutlet UILabel * verificationLabel;
    IBOutlet UITextField * verificationField;
    BOOL requested;
}

- (void) verificationDisplayFilter:(NSString *)post;
@end
