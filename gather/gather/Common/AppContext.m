#import "AppContext.h"

@implementation AppContext
@synthesize fontManager = fontManager_;
@synthesize server = server_;
@synthesize appState = appState_;

- (id)initWithServer:(GatherServer *)server
     withFontManager:(FontManager *)fontManager {
  self = [super init];
  if (self) {
    server_ = [server retain];
    fontManager_ = [fontManager retain];
  }
  return self;
}

- (void)dealloc {
  [server_ release];
  [fontManager_ release];
  [super dealloc];
}
@end
