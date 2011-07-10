//
//  gatherAppDelegate_iPhone.m
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "gatherAppDelegate_iPhone.h"

#import "viewPlaceHolder.h"
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
    
    viewPlaceHolder *newPage = [[viewPlaceHolder alloc] init];
    [slideView addNewPage:newPage];
    
    viewPlaceHolder *newPage2 = [[viewPlaceHolder alloc] init];
    [slideView addNewPage:newPage2];
    
    viewPlaceHolder *newPage3 = [[viewPlaceHolder alloc] init];
    [slideView addNewPage:newPage3];
    
    [slideView setScrollStop:2];
    return YES;
}

@end
