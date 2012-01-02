#import "EEShape.h"

@interface EERegularPolygon : EEShape {
  int numSides_;
  float radius_;
}

@property (nonatomic, readonly) int numSides;
@property (nonatomic, assign) float radius;

- (id)initWithSides:(int)numSides;
@end
