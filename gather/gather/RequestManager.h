//
//  RequestManager.h
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject {
    NSMutableArray * activeRequests;
}

+ (RequestManager*) sharedInstance;

@property (nonatomic, retain) NSMutableArray * activeRequests;

@end
