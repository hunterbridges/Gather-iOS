#import <Foundation/Foundation.h>

#import "SBJson.h"

typedef enum {
  kGatherConfigObtainError = 0,
  kGatherConfigParseError
} GatherConfigErrorCode;

extern NSString * const kServerRootURL;

@class GatherRequest;
@class SessionData;
@protocol GatherRequestDelegate;
@interface GatherServer : NSObject {
  NSMutableArray *activeRequests_;
  SessionData *sessionData_;
}

- (void)removeFromActiveRequests:(GatherRequest *)request;

// /tokens
- (GatherRequest *)requestTokenWithPhoneNumber:(NSString *)phoneNumber
    withDelegate:(id<GatherRequestDelegate>)delegate;

// /users
- (GatherRequest *)requestInfoForCurrentUserWithDelegate:
    (id<GatherRequestDelegate>)delegate;
- (GatherRequest *)requestFavlistForCurrentUserWithSlug:(NSString *)slug
    withDelegate:(id<GatherRequestDelegate>)delegate;
- (GatherRequest *)requestAddFriendWithName:(NSString *)name
                            withPhoneNumber:(NSString *)phoneNumber
                          toFavlistWithSlug:(NSString *)slug
                               withDelegate:(id<GatherRequestDelegate>)delegate;

@property (nonatomic, readonly) NSUInteger requestsInProgress;
@property (nonatomic, readonly) SessionData *sessionData;
@end
