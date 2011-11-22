#import <Foundation/Foundation.h>

#import "GatherAppState.h"

@class FontManager;
@class GatherServer;
@interface AppContext : NSObject {
  GatherServer *server_;
  GatherAppState appState_;
  FontManager *fontManager_;
}

- (id)initWithServer:(GatherServer *)server
     withFontManager:(FontManager *)fontManager;

@property (nonatomic, retain) GatherServer *server;
@property (nonatomic, retain) FontManager *fontManager;
@property (nonatomic, assign) GatherAppState appState;
@end
