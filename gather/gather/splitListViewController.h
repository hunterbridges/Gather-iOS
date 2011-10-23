//
//  splitListViewController.h
//  gather
//
//  Created by Brandon Withrow on 8/8/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "staticListView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface splitListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {
    UITableView *listView;
    NSMutableArray *listArray;
    NSMutableArray *selectedArray;
    UIView *rightContainer;
    staticListView *staticList;
    
}
- (NSString*)formattedNameString:(NSString*)name;
@end
