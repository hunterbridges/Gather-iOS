#import <UIKit/UIKit.h>

@interface StaticListView : UIView {
  NSMutableDictionary *nameDict_;
}

- (void)addName:(NSString *)name;
- (void)removeName:(NSString *)name;
@end
