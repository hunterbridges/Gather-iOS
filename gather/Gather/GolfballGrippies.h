#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "GrippiesScene.h"

typedef enum {
  kGolfballGrippiesAnimationNone = 0,
  kGolfballGrippiesAnimationLeft,
  kGolfballGrippiesAnimationRight
} GolfballGrippiesAnimation;

@interface GolfballGrippies : UIView <GLKViewDelegate, GLKViewControllerDelegate> {
  GolfballGrippiesAnimation currentAnimation_;
  
  CGPoint startTouchPosition_;
  CGFloat cellPadding_;
  CGFloat cellSize_;
  NSSet *touches_;
  
  CGSize cachedOuterSize_;
  
  UIScrollView *scrollViewLeft_;
  UIScrollView *scrollViewRight_;
  CGPoint scrollViewLeftStart_;
  CGPoint scrollViewRightStart_;
  
  int animationStep_;
  
  GLKView *glkView_;
  GLKViewController *glkViewController_;
  GrippiesScene *scene_;
  
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
