//
//  SessionData.m
//  Gather
//
//  Created by Hunter B on 07/10/11.
//  Copyright 2010 Meedeor. All rights reserved.
//

#import "SessionData.h"
#import "SBJson.h"
#import "GatherAPI.h"

static SessionData *globalSessionData = nil;

@implementation SessionData

@synthesize loggedIn, token, verification, phoneNumber, currentUserId;
@synthesize syncing;

#pragma mark Singleton Methods
+ (id)sharedSessionData {
    @synchronized(self) {
        if(globalSessionData == nil)
            globalSessionData = [[super allocWithZone:NULL] init];
    }
    return globalSessionData;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedSessionData] retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}
- (void)release {
    // never release
}
- (id)autorelease {
    return self;
}
- (id)init {
    if ((self = [super init])) {
		NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
		
		if ([prefs objectForKey:@"token"] != nil && [prefs objectForKey:@"verification"] != nil)
		{
			loggedIn = YES;
		}
		
        token = [prefs objectForKey:@"token"];
        verification = [prefs objectForKey:@"verification"];
        
		phoneNumber = nil;
		currentUserId = 0;
    }
    return self;
}

- (void) clear
{
	username = nil;
	currentUserId = 0;
}


- (void) needsSync
{
	[self syncWithServer];
}

- (void) syncWithServer
{
	syncing = YES;
    
    // TODO: Init sync request
}

// TODO: sync store callback

- (void)dealloc {
    // Should never be called, but just here for clarity really.
    //[someProperty release];
	
	
    [super dealloc];
}

@end
