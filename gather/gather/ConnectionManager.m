//
//  ConnectionManager.m
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "ConnectionManager.h"

static ConnectionManager *_instance;
@implementation ConnectionManager
@synthesize openConnections;

#pragma mark -
#pragma mark Singleton Methods

+ (ConnectionManager*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            // Allocate/initialize any member variables of the singleton class here
            // example
			//_instance.member = @"";
            _instance.openConnections = [[NSMutableDictionary alloc] init];
            [_instance resetHashIndex];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [super allocWithZone:zone];			
            return _instance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

- (void) resetHashIndex
{
    _hashIndex = 1000;
}

- (NSUInteger) genHash
{
    _hashIndex++;
    return _hashIndex;
}

- (BOOL) connectRequest:(NSMutableURLRequest *) req
{
    IndexedURLConnection * conn = [[IndexedURLConnection alloc] initWithRequest:req  hash:[self genHash] delegate:self];
    
    if (conn)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        NSMutableData * data = [[NSMutableData alloc] initWithCapacity:1];
        
        [dict setObject:req forKey:@"request"];
        [dict setObject:conn forKey:@"connection"];
        [dict setObject:data forKey:@"data"];
        
        [openConnections setObject:dict forKey:[conn hashString]];
        
        [self updateStatusIndicator];
        
        return YES;
    } else {
        return NO;
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSMutableDictionary * dict = [openConnections objectForKey:[connection hashString]];
    
    [dict setObject:response forKey:@"response"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kConnectionResponseNotification object:dict];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableDictionary * dict = [openConnections objectForKey:[connection hashString]];
    
    [[dict objectForKey:@"data"] appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSMutableDictionary * dict = [[openConnections objectForKey:[connection hashString]] retain];
    
    [openConnections removeObjectForKey:[connection hashString]];
    
    [self updateStatusIndicator];
    
    [dict setObject:error forKey:@"error"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kConnectionFailedNotification object:nil userInfo:dict];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableDictionary * dict = [[openConnections objectForKey:[connection hashString]] retain];
    
    NSLog(@"%d", [[dict objectForKey:@"connection"] hash]);
    [openConnections removeObjectForKey:[connection hashString]];
    
    [self updateStatusIndicator];
    [[NSNotificationCenter defaultCenter] postNotificationName:kConnectionFinishedNotification object:nil userInfo:dict];
}

- (void) updateStatusIndicator
{
    BOOL set = FALSE;
    
    if ([openConnections count] > 0) set = TRUE;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:set];
}

@end
