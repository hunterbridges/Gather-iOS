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
    if (![[SessionData sharedSessionData] loggedIn])
    {
        LoginVC *newPage = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        [slideView resetWithPage:newPage];
        [self setAppState:kGatherAppStateLoggedOutNeedsPhoneNumber];
    } else {
        WhoVC *newPage = [[WhoVC alloc] initWithNibName:@"WhoVC" bundle:nil];
        [slideView resetWithPage:newPage];
        [self setAppState:kGatherAppStateLoggedIn];
    }
}
@end
