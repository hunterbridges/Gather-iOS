//
//  splitListCellView.m
//  gather
//
//  Created by Brandon Withrow on 8/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "splitListCellView.h"


@implementation splitListCellView
@synthesize label, isSelected;
- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 158, 65)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.10 alpha:1];
        accesoryArrow = [[arrowView alloc] initWithFrame:CGRectMake(128, 23, 0, 0)];
        accesoryEx = [[exView alloc] initWithFrame:CGRectMake(128, 22, 0, 0)];
        accesoryEx.hidden = YES;
        [self addSubview:accesoryArrow];
        [self addSubview:accesoryEx];
        isSelected = NO;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 110, 30)];
        [label setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:0.80 alpha:1];
        [self addSubview:label];
        
       // label.text = @"Steve J";
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.20 alpha:1].CGColor);
    CGContextMoveToPoint(context, 2, 0);
    CGContextAddLineToPoint(context, 158, 0);
    CGContextStrokePath(context);
    
   // CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:1].CGColor);
    CGContextMoveToPoint(context, 2, 65);
    CGContextAddLineToPoint(context, 158, 65);
    CGContextStrokePath(context);
    // Drawing code
}
-(void)setText:(NSString*)text selected:(BOOL)selected{
    label.text = text;
    if (selected == YES) {
        accesoryArrow.hidden = YES;
        accesoryEx.hidden = NO;
        isSelected = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.11 alpha:1];
    }else{
        accesoryArrow.hidden = NO;
        accesoryEx.hidden = YES;
        isSelected = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    }
}

-(void)switchSelection{
    if (isSelected == NO) {
        accesoryArrow.hidden = YES;
        accesoryEx.hidden = NO;
        isSelected = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.11 alpha:1];
    }else{
        accesoryArrow.hidden = NO;
        accesoryEx.hidden = YES;
        isSelected = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
