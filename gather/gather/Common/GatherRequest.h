#import <Foundation/Foundation.h>

typedef enum {
  kGatherRequestFailureReasonNotFound = 0,
  kGatherRequestFailureReasonServerError,
  kGatherRequestFailureReasonTimedOut,
  kGatherRequestFailureReasonStatus,
  kGatherRequestFailureReasonCancelled
} GatherRequestFailureReason;

typedef enum {
  kGatherRequestTypeGet = 0,
  kGatherRequestTypePost,
  kGatherRequestTypeMultipartPost
} GatherRequestType;

typedef enum {
  kGatherExpectedDataTypeJson = 0,
  kGatherExpectedDataTypeRaw
} GatherExpectedDataType;

@class GatherServer;
@protocol GatherRequestDelegate;

@interface GatherRequest : NSObject <NSURLConnectionDelegate> {
  GatherServer *server_;
  id<GatherRequestDelegate> delegate_;
  
  NSMutableURLRequest *request_;
  NSURLConnection *connection_;
  NSMutableData *buffer_;
  NSDictionary *params_;
  
  GatherExpectedDataType expectedDataType_;
  GatherRequestType requestType_;
}

- (id)initWithGatherServer:(GatherServer *)server
                    andURL:(NSURL *)url
                 andParams:(NSDictionary *)params
            andRequestType:(GatherRequestType)requestType
       andExpectedDataType:(GatherExpectedDataType)expectedDataType
               andDelegate:(id<GatherRequestDelegate>)delegate;
- (void)startRequest;
- (void)cancelRequest;

@property (nonatomic, assign) BOOL isRawDataRequest;
@property (nonatomic, readonly) NSDictionary *params;
@property (nonatomic, readonly) GatherExpectedDataType expectedDataType;
@property (nonatomic, readonly) GatherRequestType requestType;
@end
