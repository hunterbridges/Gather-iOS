#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>

#import "StaticListView.h"

@interface SplitListViewController : UIViewController <UITableViewDelegate,
    UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {
    UITableView *listView_;
    NSMutableArray *listArray_;
    NSMutableArray *selectedArray_;
    UIView *rightContainer_;
    StaticListView *staticList_;
    
}

- (NSString*)formattedNameString:(NSString*)name;
@end
