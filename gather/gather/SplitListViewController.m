#import "AppContext.h"
#import "ArrowView.h"
#import "ExView.h"
#import "FontManager.h"
#import "GatherServer.h"
#import "PhoneNumberFormatter.h"
#import "PlusButtonView.h"
#import "SBJson.h"
#import "SplitListCell.h"
#import "SplitListViewController.h"
#import "UIColor+Gather.h"

@interface SplitListViewController ()
- (void)sortFriends;
@end

@implementation SplitListViewController
@synthesize ctx = ctx_;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      
  }
  return self;
}

- (void)dealloc {
  [listView_ release];
  [listArray_ release];
  [selectedArray_ release];
  [rightContainer_ release];
  [whoList_ release];
  [ctx_ release];
  [favlistRequest_ release];
  [addFriendRequest_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void) getContacts:(id)sender {
  ABPeoplePickerNavigationController *picker =
      [[ABPeoplePickerNavigationController alloc] init];
	
	picker.peoplePickerDelegate = self;
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
}

- (void)gatherRequest:(GatherRequest *)request didSucceedWithJSON:(id)json {
  if ([request isEqual:favlistRequest_]) {
    id fJson = [json objectForKey:@"friends"];
    NSArray *friends = (NSArray*)fJson;
    [listArray_ addObjectsFromArray:friends];
    [self sortFriends];
    [listView_ reloadData];
    
    [favlistRequest_ release];
    favlistRequest_ = nil;
  } else if ([request isEqual:addFriendRequest_]) {
    NSDictionary *newFriend = (NSDictionary*)json;
    [listArray_ addObject:newFriend];
    [whoList_ addName:[newFriend objectForKey:@"name"]];
    [selectedArray_ addObject:newFriend];
    [self sortFriends];
    [listView_ reloadData];
    
    [addFriendRequest_ release];
    addFriendRequest_ = nil;
  }
}

- (void)sortFriends {
  [listArray_ sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [[obj1 objectForKey:@"name"] compare:[obj2 objectForKey:@"name"]
                                        options:NSCaseInsensitiveSearch];
  }];
}

- (void)gatherRequest:(GatherRequest *)request
    didFailWithReason:(GatherRequestFailureReason)reason {
  // TODO: Catch failure
}

- (void)viewDidLoad {
  currentState_ = kSplitListViewControllerWhoState;
  
  rightContainer_ = [[UIView alloc] initWithFrame:CGRectMake(160, 
                                                            0, 
                                                            160,
                                                            460)];
  rightContainer_.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
  
  [self.view addSubview:rightContainer_];
  listView_ = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                           55,
                                                           158,
                                                           405)
                                          style:UITableViewStylePlain];
  
  listView_.delegate = self;
  listView_.dataSource = self;
  listView_.separatorStyle = UITableViewCellSeparatorStyleNone;
  listView_.showsVerticalScrollIndicator = NO;
  listView_.showsHorizontalScrollIndicator = NO;
  listView_.backgroundColor = [UIColor selectionCellUnselectedBackgroundColor];
  [self.view addSubview:listView_];
  
  whoList_ = [[StaticListView alloc] initWithContext:ctx_
                                              withFrame:CGRectMake(0,
                                                                   0,
                                                                   160,
                                                                   460)];
  whoList_.title = @"WHO?";
  whoList_.titleColor = [UIColor whoColor];
  [rightContainer_ addSubview:whoList_];
  
  PlusButtonView *plusButton =
      [PlusButtonView buttonWithType:UIButtonTypeCustom];
  
  [plusButton setFrame:CGRectMake(0, 0, 79, 55)];
  [plusButton addTarget:self
                 action:@selector(getContacts:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:plusButton];
  
  listArray_ = [[NSMutableOrderedSet alloc] init];
  selectedArray_ = [[NSMutableArray alloc] init];
  [super viewDidLoad];
}

- (void)viewDidAppearInSlideNavigation {
  [super viewDidAppearInSlideNavigation];
  favlistRequest_ =
      [[self.ctx.server requestFavlistForCurrentUserWithSlug:@"default"
                                                withDelegate:self] retain];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
	return [listArray_ count];
  
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  SplitListCell *cell = 
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[[SplitListCell alloc] initWithContext:ctx_
        withReuseIdentifier:CellIdentifier] autorelease];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  [cell setText:[[listArray_ objectAtIndex:indexPath.row] objectForKey:@"name"]
       selected:[selectedArray_ containsObject:
                    [listArray_ objectAtIndex:indexPath.row]]];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SplitListCell *cell =
      (SplitListCell *)[tableView cellForRowAtIndexPath:indexPath];

  if (cell.isSelected) {
    [whoList_ removeName:cell.name];
    [selectedArray_ removeObject:[listArray_ objectAtIndex:indexPath.row]];
  } else{
    [whoList_ addName:cell.name];
    [selectedArray_ addObject:[listArray_ objectAtIndex:indexPath.row]];
  }
  
  [cell switchSelection];
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark Address Picker Delegate
- (void)peoplePickerNavigationControllerDidCancel:
    (ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
    (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
  NSString* phoneNumber;
	NSString* name;
	NSString *firsName =
      (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
  NSString *lastName =
      (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);	
  if (lastName == nil) {
    name = firsName;
  } else {
    name = [firsName stringByAppendingFormat:@" %@", lastName];
	}
    
  ABMultiValueRef phoneNumbers =
      (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
  CFRelease(phoneNumbers);
  NSLog(@"%ld", ABMultiValueGetCount(phoneNumbers));
  if (ABMultiValueGetCount(phoneNumbers) > 0) {
    PhoneNumberFormatter * pn = [[PhoneNumberFormatter alloc] init];
    phoneNumber =
        [pn strip:(NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0)];
    [pn release];
    NSLog(@"Phone Number %@", phoneNumber);
  } else{
    // TODO: Handle no phone number notification alert here.
    phoneNumber = [NSString stringWithFormat:@""];
  }

  addFriendRequest_ = [[self.ctx.server requestAddFriendWithName:name
                                                 withPhoneNumber:phoneNumber
                                               toFavlistWithSlug:@"default"
                                                    withDelegate:self] retain];
  NSLog(@"Name:%@ Number:%@", name, phoneNumber);
  [self dismissModalViewControllerAnimated:YES];
  return NO;
}

- (BOOL)peoplePickerNavigationController:
    (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
  return NO;
}
@end
