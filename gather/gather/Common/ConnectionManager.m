#import "ConnectionManager.h"
#import "SBJson.h"

NSString const *kConnectionResponseNotification =
    @"ConnectionManager_connectionResponse";
NSString const *kConnectionFinishedNotification =
    @"ConnectionManager_connectionFinished";
NSString const *kConnectionFailedNotification =
    @"ConnectionManager_connectionFailed";

static ConnectionManager *instance_;
@implementation ConnectionManager
@synthesize openConnections;

#pragma mark -
#pragma mark Singleton Methods

+ (ConnectionManager*)sharedInstance {
  @synchronized(self) {
    if (instance_ == nil) {
      instance_ = [[self alloc] init];

      instance_.openConnections = [[NSMutableDictionary alloc] init];
      [instance_ resetHashIndex];
    }
  }
  return instance_;
}

+ (id)allocWithZone:(NSZone *)zone {	
    @synchronized(self) {
        if (instance_ == nil) {
            instance_ = [super allocWithZone:zone];			
            return instance_;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone {
    return self;	
}

- (id)retain {	
    return self;	
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;	
}

#pragma mark -
#pragma mark Custom Methods
- (void)resetHashIndex {
    _hashIndex = 1000;
}

- (NSUInteger)genHash {
    _hashIndex++;
    return _hashIndex;
}

- (BOOL)connectRequest:(NSMutableURLRequest *)req {
  IndexedURLConnection *conn =
      [[IndexedURLConnection alloc] initWithRequest:req  
                                           withHash:[self genHash] 
                                       withDelegate:self];
  
  if (conn) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:1];
    [dict setObject:kConnectionFinishedNotification forKey:@"callBack"];
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

- (BOOL)connectRequest:(NSMutableURLRequest *)req
          withCallBack:(NSString*)callBack {
  IndexedURLConnection *conn = 
      [[IndexedURLConnection alloc] initWithRequest:req
                                               withHash:[self genHash]
                                           withDelegate:self];
    
  if (conn) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:1];
    [dict setObject:callBack forKey:@"callBack"];
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

- (void)connection:(IndexedURLConnection *)connection
    didReceiveResponse:(NSURLResponse *)response {
	NSMutableDictionary * dict =
      [openConnections objectForKey:[connection hashString]];
    
  [dict setObject:response forKey:@"response"];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:kConnectionResponseNotification
                    object:dict];
}

- (void)connection:(IndexedURLConnection *)connection
    didReceiveData:(NSData *)data {
  NSMutableDictionary * dict =
      [openConnections objectForKey:[connection hashString]];
    
  [[dict objectForKey:@"data"] appendData:data];
}

- (void)connection:(IndexedURLConnection *)connection
  didFailWithError:(NSError *)error {
  NSMutableDictionary * dict =
      [[openConnections objectForKey:[connection hashString]] retain];

  [openConnections removeObjectForKey:[connection hashString]];
  [self updateStatusIndicator];
  [dict setObject:error forKey:@"error"];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:kConnectionFailedNotification
                    object:nil
                  userInfo:dict];
}

- (void)connectionDidFinishLoading:(IndexedURLConnection *)connection {
  NSMutableDictionary * dict =
      [[openConnections objectForKey:[connection hashString]] retain];
  
  NSLog(@"%d", [[dict objectForKey:@"connection"] hash]);
  [openConnections removeObjectForKey:[connection hashString]];
  
  [self updateStatusIndicator];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:[dict objectForKey:@"callBack"]
                    object:nil
                  userInfo:dict];
}

- (void)updateStatusIndicator {
  BOOL set = FALSE;
  if ([openConnections count] > 0) {
    set = TRUE;
  }
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:set];
}

@end
