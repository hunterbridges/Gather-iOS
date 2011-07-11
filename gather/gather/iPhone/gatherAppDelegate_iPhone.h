//
//  gatherAppDelegate_iPhone.h
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gatherAppDelegate.h"
#import "slideViewController.h"

@interface gatherAppDelegate_iPhone : gatherAppDelegate {
    slideViewController *slideView;
}
@property (nonatomic, retain) slideViewController *slideView;
@end
