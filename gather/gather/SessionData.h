//
//  SessionData.h
//  Meedeor
//
//  Created by Hunter B on 07/10/11.
//  Copyright 2010 Meedeor. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionData : NSObject {
	BOOL loggedIn;
	NSString * token;
	NSString * verification;
	NSString * username;
	NSString * phoneNumber;
	int currentUserId;
	
	BOOL syncing;
}

+ (id)sharedSessionData;

- (void) needsSync;
- (void) syncWithServer;
- (void) clear;

@property (nonatomic) BOOL loggedIn;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * verification;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic) int currentUserId;

@property (nonatomic) BOOL syncing;
@end
