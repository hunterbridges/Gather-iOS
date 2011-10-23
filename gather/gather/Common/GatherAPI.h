//
//  GatherAPI.h
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "ConnectionManager.h"

static NSString * apiUrl = (DEBUG_MODE==1?@"http://dev.gather.mdor.co/api/1/":@"http://prod.gather.mdor.co/api/1/");

@interface GatherAPI : NSObject {
    
}
+ (void)getNamesAndPlaces;
+ (void)addFriend:(NSString*)name Number:(NSString*)number;
+ (void) request:(NSString *)apiMethod requestMethod:(NSString *)requestMethod requestData:(NSMutableDictionary *)requestData;

+ (NSString *) dictionaryToQueryString:(NSDictionary *)dictionary;
+ (NSMutableData *) dictionaryToMultipartEncodedData:(NSDictionary *)dictionary boundary:(NSString *)boundary;
+ (NSURL *) urlForMethod:(NSString *)method;
+ (BOOL) request:(NSMutableURLRequest *)request isCallToMethod:(NSString *) method;
@end
