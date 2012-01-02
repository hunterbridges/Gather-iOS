#import "EEScene.h"

@class GolfballGrippies;
@interface GrippiesScene : EEScene {
  GolfballGrippies *grippies_;
  
  NSMutableArray *blips_;
}

@property (nonatomic, readonly) GolfballGrippies *grippies;

- (id)initWithGrippies:(GolfballGrippies *)grippies;
- (NSArray *)blipsInRow:(int)row;
- (NSArray *)blipsInColumn:(int)column;
@end
