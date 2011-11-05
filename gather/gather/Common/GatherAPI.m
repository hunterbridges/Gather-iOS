#import "GatherAPI.h"
#import "SessionData.h"

@implementation GatherAPI

#pragma mark Base
+ (void)request:(NSString *)apiMethod
  requestMethod:(NSString *)requestMethod
    requestData:(NSMutableDictionary *)requestData {
  if (requestData == nil) {
    requestData = [[NSMutableDictionary alloc] init];
  }

  if ([[SessionData sharedSessionData] loggedIn]) {
    [requestData setObject:[[SessionData sharedSessionData] token]
                    forKey:@"token"];
    [requestData setObject:[[SessionData sharedSessionData] verification]
                    forKey:@"verification"];
  }

  NSMutableURLRequest * req = nil;

  if ([requestMethod isEqualToString:@"GET"]) {
    NSString * queryString = [self dictionaryToQueryString:requestData];

    NSURL * assembledURL =
        [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?%@", 
                                       apiUrl, apiMethod, queryString]];
    NSLog(@"%@",assembledURL);

    req = [[NSMutableURLRequest alloc] initWithURL:assembledURL];

    [assembledURL release];
  } else if ([requestMethod isEqualToString:@"POST"] ||
             [requestMethod isEqualToString:@"DELETE"] ||
             [requestMethod isEqualToString:@"PUT"]) {
    NSURL * assembledURL =
      [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@",
                                     apiUrl, apiMethod]];
    NSString * boundary = @"0xKhTmLbOuNdArY";

    NSMutableData * requestBody =
      [[self dictionaryToMultipartEncodedData:requestData
                                     boundary:boundary] retain];
    req = [[NSMutableURLRequest alloc] initWithURL:assembledURL];
    [req setHTTPMethod:@"POST"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                   boundary]
        forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:requestBody];
    [req setValue:[NSString stringWithFormat:@"%d", [requestBody length]]
        forHTTPHeaderField:@"Content-Length"];
  }

  if (DEBUG_MODE == 1) {
    NSString * bodyString =
        [[NSString alloc] initWithData:[req HTTPBody]
                              encoding:NSASCIIStringEncoding];
    NSLog(@"%@ %@ %@", [req HTTPMethod], [req URL],bodyString);
  }
  
  [[ConnectionManager sharedInstance] connectRequest:req
                                        withCallBack:[NSString stringWithFormat:
                                                      @"%@%@", requestMethod,
                                                      apiMethod]];
}

+ (void)getNamesAndPlaces {
  NSMutableDictionary * dict =
      [[[NSMutableDictionary alloc] init] autorelease];
    
  [self request:@"users/me/favlists/default"
      requestMethod:@"GET"
      requestData:dict];    
}

+ (void)addFriend:(NSString*)name
       withNumber:(NSString*)number {
  NSMutableDictionary * dict =
      [[[NSMutableDictionary alloc] init] autorelease];
  [dict setObject:number forKey:@"phone_number"];
  [dict setObject:name forKey:@"name"];
  [self request:@"/users/me/favlists/default/friends"
      requestMethod:@"POST"
      requestData:dict];
}

#pragma mark Util
+ (NSString *)dictionaryToQueryString:(NSDictionary *)dictionary {
	NSMutableArray *parts = [NSMutableArray array];
  
	for (id key in dictionary) {
		id value = [dictionary objectForKey: key];
		NSString * encodedKey =
        [[NSString stringWithFormat: @"%@", key]
         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString * encodedValue =
        [[NSString stringWithFormat: @"%@", value]
         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
	
}

+ (NSMutableData *) dictionaryToMultipartEncodedData:(NSDictionary *)dictionary
                                            boundary:(NSString *)boundary {
	NSArray *myDictKeys = [dictionary allKeys];
  NSMutableData *myData = [NSMutableData dataWithCapacity:1];
  NSString *myBoundary = [NSString stringWithFormat:@"--%@\r\n", boundary];
    
  for(int i = 0;i < [myDictKeys count];i++) {
    id myValue = [dictionary valueForKey:[myDictKeys objectAtIndex:i]];
    [myData appendData:[myBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    if ([myValue isKindOfClass:[NSString class]]) {
      [myData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", [myDictKeys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:[[NSString stringWithFormat:@"Content-Type: text/plain; charset=utf-8\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:[[NSString stringWithFormat:@"%@", myValue] dataUsingEncoding:NSUTF8StringEncoding]];
    } else if(([myValue isKindOfClass:[NSURL class]]) && ([myValue isFileURL])) {
      [myData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [myDictKeys objectAtIndex:i], [[myValue path] lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:[NSData dataWithContentsOfFile:[myValue path]]];
    } else if(([myValue isKindOfClass:[NSData class]])) {
      [myData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [myDictKeys objectAtIndex:i], [myDictKeys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
      [myData appendData:myValue];
    }
  
    [myData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  [myData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  return myData;
}

+ (NSURL *) urlForMethod:(NSString *)method {
  NSString * _str =
      [NSString stringWithFormat:@"%@%@",apiUrl,method];
  return [NSURL URLWithString:_str];
}

+ (BOOL) request:(NSMutableURLRequest *)request
  isCallToMethod:(NSString *) method {
  NSURL * url = [request URL];
  NSURL * newURL = [[[NSURL alloc] initWithScheme:[url scheme]
                                            host:[url host]
                                            path:[url path]] autorelease];

  if ([newURL isEqual:[GatherAPI urlForMethod:method]]) {
    return YES;
  } else {
    return NO;
  }
}
@end
