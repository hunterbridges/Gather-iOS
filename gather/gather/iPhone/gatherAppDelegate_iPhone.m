//
//  gatherAppDelegate_iPhone.m
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "gatherAppDelegate_iPhone.h"

@implementation gatherAppDelegate_iPhone

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NetworkingTestVC * vc = [[NetworkingTestVC alloc] initWithNibName:@"NetworkingTestVC" bundle:nil];
    
    [self.window addSubview:vc.view];
    return YES;
}

@end
