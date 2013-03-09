#import <UIKit/UIKit.h>
@class GHRViewController;
@interface GHRCubeNavController : UIViewController
- (void)pushViewController:(GHRViewController *)vc withAnimation:(BOOL)animate;
@end
