//
//  splitListCellView.h
//  gather
//
//  Created by Brandon Withrow on 8/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "arrowView.h"
#import "exView.h"

@interface splitListCellView : UIView {
    arrowView *accesoryArrow;
    exView *accesoryEx;
    UILabel *label;
    BOOL isSelected;
    
}
@property BOOL isSelected;
@property (nonatomic, retain) UILabel *label;
-(id)init;
-(void)setText:(NSString*)text selected:(BOOL)selected;
-(void)switchSelection;
@end
