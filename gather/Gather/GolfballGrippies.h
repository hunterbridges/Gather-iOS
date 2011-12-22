#import <UIKit/UIKit.h>

typedef enum {
  kGolfballGrippiesAnimationNone = 0,
  kGolfballGrippiesAnimationLeft,
  kGolfballGrippiesAnimationRight
} GolfballGrippiesAnimation;

@interface GolfballGrippies : UIView {
  GolfballGrippiesAnimation currentAnimation_;
  
  CGPoint startTouchPosition;
  CGFloat cellPadding_;
  CGFloat cellSize_;
  NSSet *touches_;
  
  UIScrollView *scrollViewLeft_;
  UIScrollView *scrollViewRight_;
  CGPoint scrollViewLeftStart;
  CGPoint scrollViewRightStart;
  
  int animationStep_;
  int animationTrail_;
  NSTimer *animationTimer_;
  
  BOOL enabled_;
}
@property (nonatomic, assign) UIScrollView *scrollViewLeft;
@property (nonatomic, assign) UIScrollView *scrollViewRight;
@property (nonatomic, assign) GolfballGrippiesAnimation currentAnimation;
@property (nonatomic, assign) CGFloat cellPadding;
@property (nonatomic, assign) CGFloat cellSize;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, readonly) int columnCount;
@property (nonatomic, readonly) int rowCount;
@property (nonatomic, readonly) CGSize cellOuterSize;
@end
