//
//  exView.m
//  gather
//
//  Created by Brandon Withrow on 8/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "exView.h"


@implementation exView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 20, 20)];
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
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.20 alpha:1].CGColor);
    CGContextMoveToPoint(context, 1, 1);
    CGContextAddLineToPoint(context, 18, 18);
    CGContextMoveToPoint(context, 18, 1);
    CGContextAddLineToPoint(context, 1, 18);
    CGContextStrokePath(context);
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
