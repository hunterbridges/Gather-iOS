#import "GHRRandomColorVC.h"

@interface GHRRandomColorVC ()

@end

@implementation GHRRandomColorVC

- (UIColor*)randomColor {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return color;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [self randomColor];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
