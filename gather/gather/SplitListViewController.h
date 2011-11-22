#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>

#import "AppContext.h"
#import "GatherRequestDelegate.h"
#import "SlideViewController.h"
#import "StaticListView.h"

typedef enum {
  kSplitListViewControllerWhoState = 0,
  kSplitListViewControllerWhereState,
  kSplitListViewControllerWhenState
} SplitListViewControllerState;

@class GatherRequest;
@interface SplitListViewController : SlideViewController <UITableViewDelegate,
    UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate,
    GatherRequestDelegate> {
  UITableView *listView_;
  NSMutableOrderedSet *listArray_;
  NSMutableArray *selectedArray_;
  UIView *rightContainer_;
  StaticListView *whoList_;
      
  AppContext *ctx_;
  GatherRequest *favlistRequest_;
  GatherRequest *addFriendRequest_;
      
  SplitListViewControllerState currentState_;
}

@property (nonatomic, retain) AppContext *ctx;
@end
