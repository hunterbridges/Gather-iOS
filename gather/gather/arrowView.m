//
//  arrowView.m
//  gather
//
//  Created by Brandon Withrow on 8/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "arrowView.h"


@implementation arrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 12, 18)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.20 alpha:1].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.20 alpha:1].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 12, 9);
    CGContextAddLineToPoint(context, 0, 18);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
