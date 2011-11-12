#import <Foundation/Foundation.h>
#import "GatherRequest.h"

@protocol GatherRequestDelegate <NSObject>
- (void)gatherRequest:(GatherRequest *)request
     didFailWithReason:(GatherRequestFailureReason)reason;
@optional
- (void)gatherRequest:(GatherRequest *)request 
    didSucceedWithJSON:(id)json;
- (void)gatherRequest:(GatherRequest *)request 
    didSucceedWithData:(NSData *)data;
@end

