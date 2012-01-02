#import "GrippiesScene.h"
#import "GrippiesBlip.h"
#import "GolfballGrippies.h"

@implementation GrippiesScene
@synthesize grippies = grippies_;

- (id)initWithGrippies:(GolfballGrippies *)grippies {
  self = [super init];
  if (self) {
    blips_ = [[NSMutableArray alloc] init];
    
    grippies_ = grippies;
    [self setProjectionMatrixWithLeft:0
                                right:grippies.bounds.size.width
                                  top:grippies.bounds.size.height
                               bottom:0];
    
    
    for (int row = 0; row < grippies.rowCount; row++) {
      for (int col = 0; col < grippies.columnCount; col++) {
        GrippiesBlip *blip =
            [[GrippiesBlip alloc] initWithRadius:grippies.cellSize / 2];
        blip.position =
            GLKVector2Make((col + 1) * grippies.cellOuterSize.width -
                               grippies.cellOuterSize.width / 2.0,
                           grippies.frame.size.height -
                               (row + 1) * grippies.cellOuterSize.height +
                               grippies.cellOuterSize.height / 2.0);
        [blips_ addObject:blip];
        [self.shapes addObject:blip];
        [blip release];
      }
    }
  }
  return self;
}

- (NSArray *)blipsInRow:(int)row {
  NSArray *blips = [blips_ filteredArrayUsingPredicate:
      [NSPredicate predicateWithBlock:^BOOL(GrippiesBlip *blip, NSDictionary *bindings) {
    return [blips_ indexOfObject:blip] / grippies_.rowCount == row;
  }]];
  return blips;
}

- (NSArray *)blipsInColumn:(int)column {
  NSArray *blips = [blips_ filteredArrayUsingPredicate:
                    [NSPredicate predicateWithBlock:^BOOL(GrippiesBlip *blip, NSDictionary *bindings) {
    return [blips_ indexOfObject:blip] % grippies_.columnCount ==
        grippies_.columnCount - column;
  }]];
  return blips;
}

- (void)dealloc {
  [blips_ release];
  [super dealloc];
}
@end
