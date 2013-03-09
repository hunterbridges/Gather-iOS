#import "AppDelegate.h"
#import "GHRCubeNavController.h"

@implementation AppDelegate

- (void)dealloc {
  [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[[UIWindow alloc] initWithFrame:
                  [[UIScreen mainScreen] bounds]] autorelease];

  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  GHRCubeNavController *mainView = [[GHRCubeNavController alloc] init];
  self.window.rootViewController = mainView;
  [mainView release];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
