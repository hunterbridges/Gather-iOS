//
//  gatherAppDelegate_iPhone.m
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "gatherAppDelegate_iPhone.h"
#import "LoginVC.h"
#import "SessionData.h"
#import "WhoVC.h"
#import "viewPlaceHolder.h"
#import "splitListViewController.h"

@implementation gatherAppDelegate_iPhone
@synthesize slideView, appState;

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
    
  /*  splitListViewController *newSplit = [[splitListViewController alloc] init];
    [slideView addNewPage:newSplit];
    
    viewPlaceHolder *page1 = [[viewPlaceHolder alloc] init];
    [slideView addNewPage:page1];
    
    viewPlaceHolder *page2 = [[viewPlaceHolder alloc] init];
    [slideView addNewPage:page2];
    
    viewPlaceHolder *page3 = [[viewPlaceHolder alloc] init];
    [slideView addNewPage:page3];
    */
    
  [self resetNavigationForAuthState];
    
    return YES;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString * _stripped = [[url absoluteString] stringByReplacingOccurrencesOfString:@"gather://" withString:@""];
    NSArray * uriSegments = [_stripped componentsSeparatedByString:@"/"];
    
    if ([[uriSegments objectAtIndex:0] isEqualToString:@"verify"])
    {
        NSLog(@"Verify with code %@", [uriSegments objectAtIndex:1]);
        
        if (appState == kGatherAppStateLoggedOutNeedsVerification)
        {
            NSMutableDictionary * _userData = [[[NSMutableDictionary alloc] init] autorelease];
            [_userData setObject:[uriSegments objectAtIndex:1] forKey:@"verification"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"verification_from_link" object:nil userInfo:_userData];
        }
        
        return YES;
    }
    
    return NO;
}

- (void) resetNavigationForAuthState
{
    NSLog(@"Resetting Naviation State");
    if (![[SessionData sharedSessionData] loggedIn])
    {
        LoginVC *newPage = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        [slideView resetWithPage:newPage];
        [self setAppState:kGatherAppStateLoggedOutNeedsPhoneNumber];
    } else {
        
        splitListViewController *newSplit = [[splitListViewController alloc] init];
        [slideView resetWithPage:newSplit];
        [self setAppState:kGatherAppStateLoggedIn];
    }
}
@end
