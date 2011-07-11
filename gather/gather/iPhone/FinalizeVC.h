//
//  FinalizeVC.h
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * kFinalizingText = @"LOGGING IN...";

@interface FinalizeVC : UIViewController {
    IBOutlet UILabel * message;
    BOOL requested;
}

@end
