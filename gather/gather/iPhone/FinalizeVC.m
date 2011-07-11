//
//  FinalizeVC.m
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "FinalizeVC.h"
#import "GatherAPI.h"
#import "SessionData.h"
#import "gatherAppState.h"

@implementation FinalizeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidAppear:(BOOL)animated
{
    if (!requested)
    {
        NSMutableDictionary * dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setObject:[[SessionData sharedSessionData] token] forKey:@"token"];
        [dict setObject:[[SessionData sharedSessionData] verification] forKey:@"verification"];
        
        [GatherAPI request:@"users/me" requestMethod:@"GET" requestData:dict];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFinished:) name:kConnectionFinishedNotification object:nil];
        
        message.text = kFinalizingText;
        
        [[[UIApplication sharedApplication] delegate] setAppState:kGatherAppStateLoggedOutFinalizing];
        
        requested = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) connectionFinished:(NSNotification*)notification 
{
    NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
    NSMutableURLRequest * req = [dict objectForKey:@"request"];
    
    if ([GatherAPI request:req isCallToMethod:@"users/me"])
    {
        NSString * str = [[NSString alloc] initWithData:[dict objectForKey:@"data"] encoding:NSUTF8StringEncoding];
        id json = [str JSONValue];
        
        if ([json objectForKey:@"id"] != nil)
        {
            [[SessionData sharedSessionData] setCurrentUserId:[[json objectForKey:@"id"] intValue]];
        }
        
        [[SessionData sharedSessionData] setLoggedIn:YES];
        [[SessionData sharedSessionData] saveSession];
        
        [[[UIApplication sharedApplication] delegate] resetNavigationForAuthState];
        
        
        NSLog(@"%@", str);
        [str release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [message setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:20]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
