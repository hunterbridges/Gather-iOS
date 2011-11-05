#import "SessionData.h"
#import "SBJson.h"
#import "GatherAPI.h"

static SessionData *globalSessionData = nil;

@implementation SessionData

@synthesize loggedIn = loggedIn_;
@synthesize token = token_;
@synthesize verification = verification_;
@synthesize phoneNumber = phoneNumber_;
@synthesize currentUserId = currentUserId_;
@synthesize syncing = syncing_;

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

- (oneway void)release {
    // never release
}

- (id)autorelease {
    return self;
}

- (id)init {
    if ((self = [super init])) {
		NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
		
        token_ = [prefs objectForKey:@"token"];
        verification_ = [prefs objectForKey:@"verification"];
        loggedIn_ = [prefs boolForKey:@"loggedIn"];
        
		phoneNumber_ = nil;
		currentUserId_ = 0;
    }
    return self;
}

- (void)saveSession {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    if (token_ != nil) {
        [prefs setObject:token_ forKey:@"token"];
    } else {
        [prefs removeObjectForKey:@"token"];
    }
    
    if (verification_ != nil) {
        [prefs setObject:verification_ forKey:@"verification"];
    } else {
        [prefs removeObjectForKey:@"verification"];
    }
    
    [prefs setBool:loggedIn_ forKey:@"loggedIn"];  
    [prefs synchronize];
}

- (void) clear {
    token_ = nil;
    verification_ = nil;
    loggedIn_ = NO;
    
	username_ = nil;
	currentUserId_ = 0;
    
    [self saveSession];
}

- (void) needsSync {
	[self syncWithServer];
}

- (void) syncWithServer {
	syncing_ = YES;
    
    // TODO: Init sync request
}

// TODO: sync store callback

- (void)dealloc {
    // Should never be called, but just here for clarity really.
    //[someProperty release];
	
	
    [super dealloc];
}

@end
