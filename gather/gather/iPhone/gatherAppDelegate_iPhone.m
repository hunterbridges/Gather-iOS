//
//  gatherAppDelegate_iPhone.m
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "gatherAppDelegate_iPhone.h"
#import "LoginVC.h"

@implementation gatherAppDelegate_iPhone
@synthesize slideView;
- (void)dealloc
{
	[super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"Iphone Launched");
    slideView = [[slideViewController alloc] init];
    [self.window addSubview:slideView.view];
    
    LoginVC *newPage = [[LoginVC alloc] init];
    [slideView addNewPage:newPage];
    
    return YES;
}

@end
