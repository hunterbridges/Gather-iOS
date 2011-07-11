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
#import "gatherAppState.h"

@interface gatherAppDelegate_iPhone : gatherAppDelegate {
    slideViewController *slideView;
    gatherAppState appState;
}

- (void) resetNavigationForAuthState;

@property (nonatomic, retain) slideViewController *slideView;
@property (nonatomic) gatherAppState appState;

@end
