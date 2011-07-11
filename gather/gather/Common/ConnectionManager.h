//
//  ConnectionManager.h
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "IndexedURLConnection.h"

static NSString * kConnectionResponseNotification = @"ConnectionManager_connectionResponse";
static NSString * kConnectionFinishedNotification = @"ConnectionManager_connectionFinished";
static NSString * kConnectionFailedNotification = @"ConnectionManager_connectionFailed";

@interface ConnectionManager : NSObject {
    NSMutableDictionary * openConnections;
    
    NSUInteger _hashIndex;
}

+ (ConnectionManager*) sharedInstance;

- (void) resetHashIndex;
- (NSUInteger) genHash;

- (BOOL) connectRequest:(NSMutableURLRequest *) req;
- (void) updateStatusIndicator;

@property (nonatomic, retain) NSMutableDictionary * openConnections;

@end
