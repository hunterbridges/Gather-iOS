#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>

#import "AppContext.h"
#import "GatherRequestDelegate.h"
#import "SlideViewController.h"
#import "StaticListView.h"

@class GatherRequest;
@interface SplitListViewController : SlideViewController <UITableViewDelegate,
    UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate,
    GatherRequestDelegate> {
  UITableView *listView_;
  NSMutableArray *listArray_;
  NSMutableArray *selectedArray_;
  UIView *rightContainer_;
  StaticListView *staticList_;
      
  AppContext *ctx_;
  GatherRequest *favlistRequest_;
  GatherRequest *addFriendRequest_;
}

- (NSString*)formattedNameString:(NSString*)name;

@property (nonatomic, retain) AppContext *ctx;
@end
