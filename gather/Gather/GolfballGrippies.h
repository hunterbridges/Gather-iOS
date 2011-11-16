#import <UIKit/UIKit.h>

typedef enum {
  kGolfballGrippiesAnimationNone = 0,
  kGolfballGrippiesAnimationLeft,
  kGolfballGrippiesAnimationRight
} GolfballGrippiesAnimation;

@interface GolfballGrippies : UIView {
  GolfballGrippiesAnimation currentAnimation_;
  
  CGFloat cellPadding_;
  CGFloat cellSize_;
  NSSet *touches_;
  
  int animationStep_;
  int animationTrail_;
  NSTimer *animationTimer_;
  
  BOOL enabled_;
}

@property (nonatomic, assign) GolfballGrippiesAnimation currentAnimation;
@property (nonatomic, assign) CGFloat cellPadding;
@property (nonatomic, assign) CGFloat cellSize;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, readonly) int columnCount;
@property (nonatomic, readonly) int rowCount;
@property (nonatomic, readonly) CGSize cellOuterSize;
@end
