#import <UIKit/UIKit.h>

@class AppContext;
@interface StaticListView : UIView {
  AppContext *ctx_;
  NSMutableOrderedSet *names_;
  NSMutableDictionary *labels_;
  
  UILabel *titleLabel_;
}

- (id)initWithContext:(AppContext *)ctx withFrame:(CGRect)frame;
- (void)addName:(NSString *)name;
- (void)removeName:(NSString *)name;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;

- (void)shiftLabelsDownForNamesInRange:(NSRange)range;
- (void)shiftLabelsUpForNamesInRange:(NSRange)range;

@property (nonatomic, assign) NSString *title;
@end
