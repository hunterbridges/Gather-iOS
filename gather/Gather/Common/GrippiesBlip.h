#import <UIKit/UIKit.h>
#import "EEShape.h"
#import "EEEllipse.h"

@interface GrippiesBlip : EEShape {
  uint holdcount_;
  
  EEEllipse *body_;
}

- (id)initWithRadius:(int)radius;
- (void)addHold;
- (void)releaseHold;
- (void)clearHolds;
- (void)tap;

@end
