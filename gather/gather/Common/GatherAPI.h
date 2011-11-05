#import <Foundation/Foundation.h>

#import "ConnectionManager.h"
#import "SBJson.h"

// TODO: Put this in app settings.
static NSString * apiUrl = (DEBUG_MODE==1?@"http://dev.gather.mdor.co/api/1/":@"http://prod.gather.mdor.co/api/1/");

@interface GatherAPI : NSObject {
    
}

+ (void)getNamesAndPlaces;
+ (void)addFriend:(NSString*)name
           withNumber:(NSString*)number;
+ (void)request:(NSString *)apiMethod
  requestMethod:(NSString *)requestMethod
    requestData:(NSMutableDictionary *)requestData;
+ (NSString *)dictionaryToQueryString:(NSDictionary *)dictionary;
+ (NSMutableData *)dictionaryToMultipartEncodedData:(NSDictionary *)dictionary
                                           boundary:(NSString *)boundary;
+ (NSURL *)urlForMethod:(NSString *)method;
+ (BOOL)request:(NSMutableURLRequest *)request isCallToMethod:(NSString *) method;
@end
