#import "GrippiesBlip.h"
#import "UIColor+Gather.h"

@interface GrippiesBlip ()
- (void)allHoldsDidRelease;
@end

@implementation GrippiesBlip

- (id)initWithRadius:(int)radius {
  self = [super init];
  if (self) {
    EEEllipse *shadow = [[EEEllipse alloc] init];
    shadow.radiusX = radius;
    shadow.radiusY = radius;
    shadow.position = GLKVector2Make(0, 1);
    shadow.color = [UIColor grippiesShadowColor].GLKVector4;
    [self addChild:shadow];
    [shadow release];
    
    EEEllipse *highlight = [[EEEllipse alloc] init];
    highlight.radiusX = radius;
    highlight.radiusY = radius;
    highlight.position = GLKVector2Make(0, -1);
    highlight.color = [UIColor grippiesHighlightColor].GLKVector4;
    [self addChild:highlight];
    [highlight release];
    
    body_ = [[EEEllipse alloc] init];
    body_.radiusX = radius;
    body_.radiusY = radius;
    body_.position = GLKVector2Make(0, 0);
    body_.color = [UIColor grippiesInactiveBodyColor].GLKVector4;
    [self addChild:body_];
  }
  return self;
}

- (void)addHold {
  holdcount_++;
  [body_.animations removeAllObjects];
  body_.color = [UIColor grippiesActiveBodyColor].GLKVector4;
}

- (void)releaseHold {
  holdcount_--;
  holdcount_ = MAX(holdcount_, 0);
  if (holdcount_ == 0) {
    [self allHoldsDidRelease];
  }
}

- (void)clearHolds {
  holdcount_ = 0;
  [self allHoldsDidRelease];
}

- (void)allHoldsDidRelease {
  body_.color = [UIColor grippiesActiveBodyColor].GLKVector4;
  [body_ animateWithDuration:1 animations:^{
    body_.color = [UIColor grippiesInactiveBodyColor].GLKVector4;
  }];
}

- (void)tap {
  [self addHold];
  [self releaseHold];
}

- (void)dealloc {
  [body_ release];
  [super dealloc];
}

@end
