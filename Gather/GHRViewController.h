#import <UIKit/UIKit.h>

@class GHRCubeNavController;
@interface GHRViewController : UIViewController
@property (nonatomic, retain) GHRCubeNavController *navController;
@property (nonatomic, readonly) GHRViewController *nextVC;
@end
