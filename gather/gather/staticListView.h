//
//  staticListView.h
//  gather
//
//  Created by Brandon Withrow on 8/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface staticListView : UIView {
    NSMutableDictionary* nameDict;
   
}
-(void)addName:(NSString*)name;
-(void)removeName:(NSString*)name;

@end
