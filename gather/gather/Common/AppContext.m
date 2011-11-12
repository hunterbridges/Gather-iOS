#import "AppContext.h"

@implementation AppContext
@synthesize server = server_;
@synthesize appState = appState_;

- (id)initWithServer:(GatherServer *)server {
  self = [super init];
  if (self) {
    server_ = [server retain];
  }
  return self;
}

- (void)dealloc {
  [server_ release];
  [super dealloc];
}
@end
