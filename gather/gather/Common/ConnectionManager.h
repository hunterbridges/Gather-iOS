#import <Foundation/Foundation.h>

#import "IndexedURLConnection.h"

extern const NSString *kConnectionResponseNotification;
extern const NSString *kConnectionFinishedNotification;
extern const NSString *kConnectionFailedNotification;

@interface ConnectionManager : NSObject {
    NSMutableDictionary *openConnections;
    
    NSUInteger _hashIndex;
}

+ (ConnectionManager*)sharedInstance;

- (void)resetHashIndex;
- (NSUInteger)genHash;

- (BOOL)connectRequest:(NSMutableURLRequest *)req;
- (void)updateStatusIndicator;
- (BOOL)connectRequest:(NSMutableURLRequest *)req
          withCallBack:(NSString*)callBack;

@property (nonatomic, retain) NSMutableDictionary *openConnections;

@end
