#import "SBJson.h"
#import "GatherRequest.h"
#import "GatherRequestDelegate.h"
#import "GatherServer.h"

@interface GatherRequest ()
- (NSString *)urlEscape:(NSString *)unencodedString;
- (NSURL *)url:(NSURL *)url withAppendedParams:(NSDictionary *)params;
- (NSString *)queryStringWithParams:(NSDictionary *)dictionary;
- (NSMutableData *)multipartEncodedDataWithParams:(NSDictionary *)dictionary
                                     withBoundary:(NSString *)boundary;
@end

@implementation GatherRequest
@synthesize isRawDataRequest = isRawDataRequest_;
@synthesize params = params_;
@synthesize expectedDataType = expectedDataType_;
@synthesize requestType = requestType_;

- (id)initWithGatherServer:(GatherServer *)server
                    andURL:(NSURL *)url
                 andParams:(NSDictionary *)params
            andRequestType:(GatherRequestType)requestType
       andExpectedDataType:(GatherExpectedDataType)expectedDataType
               andDelegate:(id<GatherRequestDelegate>)delegate {
  self = [super init];
  if (self) {
    server_ = [server retain];
    delegate_ = delegate;
    requestType_ = requestType;
    expectedDataType_ = expectedDataType;
    
    if (params) {
      params_ = [params retain];
    }
    
    request_ = [[NSMutableURLRequest alloc] init];
    switch (requestType) {
      case kGatherRequestTypeGet:
          if (params) {
            NSURL *newURL = url;
            newURL = [self url:url withAppendedParams:params];
            request_.URL = newURL;
          }
        break;
        
      case kGatherRequestTypePost:
        request_.HTTPMethod = @"POST";
        if (params) {
          NSString *queryString = [self queryStringWithParams:params];
          NSData *body = [queryString dataUsingEncoding:NSUTF8StringEncoding];
          request_.URL = url;
          request_.HTTPBody = body;
        }
        break;
        
      case kGatherRequestTypeMultipartPost:
        request_.HTTPMethod = @"POST";
        if (params) {
          NSString *boundary = @"0xKhTmLbOuNdArY";
          NSData *body = [self multipartEncodedDataWithParams:params
                                                 withBoundary:boundary];
          NSString *contentType =
              [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                         boundary];
          NSString *contentLength = 
              [NSString stringWithFormat:@"%d", [body length]];
          request_.URL = url;
          request_.HTTPBody = body;
          [request_ setValue:contentType forHTTPHeaderField:@"Content-Type"];
          [request_ setValue:contentLength
              forHTTPHeaderField:@"Content-Length"];
        }
        break;
    }
    connection_ = [[NSURLConnection alloc] initWithRequest:request_
                                                  delegate:self];
    NSLog(@"Creating request to %@", [request_.URL absoluteString]);
  }
  return self;
}

- (void)startRequest {
  [connection_ start];
}

- (void)cancelRequest {
  [connection_ cancel];
  [delegate_ gatherRequest:self
          didFailWithReason:kGatherRequestFailureReasonCancelled];
}

- (void)dealloc {
  [server_ release];
  [request_ release];
  [connection_ release];
  [buffer_ release];
  [super dealloc];
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection
    didReceiveResponse:(NSURLResponse *)response {
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if ([httpResponse statusCode] == 404) {
    [connection_ cancel];
    [delegate_ gatherRequest:self
            didFailWithReason:kGatherRequestFailureReasonNotFound];
  } else if ([httpResponse statusCode] >= 500) {
    [connection_ cancel];
    [delegate_ gatherRequest:self
            didFailWithReason:kGatherRequestFailureReasonServerError];
  }
  [server_ removeFromActiveRequests:self];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
  if (buffer_ == nil) {
    buffer_ = [[NSMutableData alloc] init];
  }
  [buffer_ appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
  [(id<GatherRequestDelegate>)delegate_ gatherRequest:self
      didFailWithReason:kGatherRequestFailureReasonServerError];
  [server_ removeFromActiveRequests:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if (expectedDataType_ == kGatherExpectedDataTypeRaw) {
    [delegate_ gatherRequest:self
           didSucceedWithData:buffer_];
  } else {
    NSString *response = [[NSString alloc] initWithData:buffer_
                                               encoding:NSUTF8StringEncoding];
    [delegate_ gatherRequest:self
          didSucceedWithJSON:[response JSONValue]];
    [response release];
  }
  [server_ removeFromActiveRequests:self];
}

#pragma mark URL Utils
- (NSString*)urlEscape:(NSString *)unencodedString {
	NSString *s = (NSString *)
      CFURLCreateStringByAddingPercentEscapes(NULL,
          (CFStringRef)unencodedString, NULL, 
          (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
	return [s autorelease];
}

- (NSURL *)url:(NSURL *)url withAppendedParams:(NSDictionary *)params {
	NSMutableString *urlWithQuerystring =
      [NSMutableString stringWithString:[url absoluteString]];
	if (params) {
		[urlWithQuerystring appendString:[self queryStringWithParams:params]];
	}
	return [NSURL URLWithString:urlWithQuerystring];
}

- (NSString *)queryStringWithParams:(NSDictionary *)dictionary {
	NSMutableArray *parts = [NSMutableArray array];
  
	for (id key in dictionary) {
		id value = [dictionary objectForKey: key];
		NSString * encodedKey =
    [[NSString stringWithFormat: @"%@", key]
     stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString * encodedValue =
    [[NSString stringWithFormat: @"%@", value]
     stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSString *part =
        [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}

- (NSMutableData *)multipartEncodedDataWithParams:(NSDictionary *)dictionary
                                     withBoundary:(NSString *)boundary {
  NSMutableData *buffer = [NSMutableData data];
  NSString *boundaryStarter = [NSString stringWithFormat:@"--%@\r\n", boundary];
  
  for(NSString *key in dictionary) {
    id value = [dictionary valueForKey:key];
    [buffer appendData:
        [boundaryStarter dataUsingEncoding:NSUTF8StringEncoding]];
    if ([value isKindOfClass:[NSString class]]) {
      NSString *disposition = [NSString stringWithFormat:
          @"Content-Disposition: form-data; name=\"%@\"\r\n", key];
      [buffer appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];

      NSString *contentType =
          @"Content-Type: text/plain; charset=utf-8\r\n\r\n";
      [buffer appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
      
      NSString *content = [NSString stringWithFormat:@"%@", value];
      [buffer appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    } else if(([value isKindOfClass:[NSData class]])) {
      NSString *disposition = [NSString stringWithFormat:
          @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
          key, key];
      [buffer appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
      
      NSString *contentType = @"Content-Type: image/jpeg\r\n";
      [buffer appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
      
      NSString *transferEncoding = @"Content-Transfer-Encoding: binary\r\n\r\n";
      [buffer appendData:
          [transferEncoding dataUsingEncoding:NSUTF8StringEncoding]];
      [buffer appendData:value];
    }
    
    [buffer appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  NSString *endBoundary = [NSString stringWithFormat:@"--%@--\r\n", boundary];
  [buffer appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
  return buffer;
}

@end
