#import <Foundation/Foundation.h>

#import "GatherAppState.h"

@class GatherServer;
@interface AppContext : NSObject {
  GatherServer *server_;
  
  GatherAppState appState_;
}

- (id)initWithServer:(GatherServer *)server;

@property (nonatomic, retain) GatherServer *server;
@property (nonatomic, assign) GatherAppState appState;
@end
