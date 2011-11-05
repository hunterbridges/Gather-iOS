#import "GatherAppDelegate.h"

@implementation GatherAppDelegate
@synthesize window=_window;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self.window makeKeyAndVisible];
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
    [self saveContext];
}

- (void)dealloc {
  [_window release];
  [__managedObjectContext release];
  [__managedObjectModel release];
  [__persistentStoreCoordinator release];
  [super dealloc];
}

- (void)awakeFromNib {
  
}

- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    if ([managedObjectContext hasChanges] && 
        ![managedObjectContext save:&error])
    {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
  if (__managedObjectContext != nil)
  {
    return __managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil)
  {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  
  return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
  if (__managedObjectModel != nil) {
      return __managedObjectModel;
  }
  NSURL *modelURL =
      [[NSBundle mainBundle] URLForResource:@"gather" withExtension:@"momd"];
  __managedObjectModel =
      [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
  return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (__persistentStoreCoordinator != nil) {
    return __persistentStoreCoordinator;
  }
  
  NSURL *storeURL = [[self applicationDocumentsDirectory]
                     URLByAppendingPathComponent:@"gather.sqlite"];
  
  NSError *error = nil;
  __persistentStoreCoordinator = 
      [[NSPersistentStoreCoordinator alloc]
       initWithManagedObjectModel:[self managedObjectModel]];
  if (![__persistentStoreCoordinator
         addPersistentStoreWithType:NSSQLiteStoreType
                      configuration:nil
                                URL:storeURL
                            options:nil
                              error:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] 
               URLsForDirectory:NSDocumentDirectory
                      inDomains:NSUserDomainMask] lastObject];
}

@end
