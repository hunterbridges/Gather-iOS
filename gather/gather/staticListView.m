//
//  staticListView.m
//  gather
//
//  Created by Brandon Withrow on 8/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "staticListView.h"


@implementation staticListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nameDict = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)addName:(NSString*)name{
    if ([nameDict objectForKey:name] == nil) {
    if ([nameDict count] < (self.frame.size.height / 32)) {
        int yPos = [nameDict count] * 32;
        NSLog(@"Less than yPos %i", yPos);
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, 30)];
        [newLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.textColor = [UIColor colorWithWhite:0.10 alpha:1];
        newLabel.text = [NSString stringWithFormat:@"%i %@", ([nameDict count] +1),name];
        newLabel.tag = [nameDict count] + 1;
        [nameDict setObject:newLabel forKey:name];
        
        [self addSubview:newLabel];
        
    }else if([nameDict count] < ((self.frame.size.height / 32)+1)) {
        int yPos = [nameDict count] * 32;
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, 30)];
        [newLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.textColor = [UIColor colorWithWhite:0.10 alpha:1];
        newLabel.text = @"More #";
        newLabel.tag = [nameDict count] + 1;
        [nameDict setObject:newLabel forKey:name];
        
        [self addSubview:newLabel];
    }
    }
    
    
}
-(void)removeName:(NSString*)name{
    UILabel *removeLabel = [nameDict objectForKey:name];
    if (removeLabel != nil) {
        [removeLabel removeFromSuperview];
        if (removeLabel.tag == [nameDict count]) {
            [nameDict removeObjectForKey:name];
        }else{
        int count = removeLabel.tag;
        [UIView beginAnimations:nil context:NULL]; {
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.5];
			[UIView setAnimationDelegate:self];
			
		
        while (count <= [nameDict count] ) {
            count ++;
            UILabel *temp = (UILabel*)[self viewWithTag:count];
            temp.tag = (count - 1);
           // temp.text = [NSString string]
            [temp setFrame:CGRectMake(0, (temp.frame.origin.y - 32), temp.frame.size.width, temp.frame.size.height)];
        }
        } [UIView commitAnimations];
        
         [nameDict removeObjectForKey:name];
        
        }
    }
}
- (void)dealloc
{
    [super dealloc];
}

@end
