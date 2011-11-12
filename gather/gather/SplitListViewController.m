#import "ArrowView.h"
#import "ExView.h"
#import "GatherServer.h"
#import "PhoneNumberFormatter.h"
#import "PlusButtonView.h"
#import "SBJson.h"
#import "SplitListCellView.h"
#import "SplitListViewController.h"

// TODO: Does this need to be generalized so we can use with friends and places?
@implementation SplitListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void) getContacts:(id)sender {
  NSLog(@"Button Pressed");
  ABPeoplePickerNavigationController *picker =
      [[ABPeoplePickerNavigationController alloc] init];
	
	picker.peoplePickerDelegate = self;
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
}

- (void)connectionFinished:(NSNotification*)notification {
  NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
  NSString * str =
      [[NSString alloc] initWithData:[dict objectForKey:@"data"]
                            encoding:NSUTF8StringEncoding];
  id json = [[str JSONValue] objectForKey:@"friends"];
  NSArray *friends = (NSArray*)json;
  [listArray_ addObjectsFromArray:friends];
  [listView_ reloadData];
  NSLog(@"Friends %i", [friends count]);
  NSLog(@"%@", str);

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)friendAdded:(NSNotification*)notification {
  NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
  NSString * str = [[NSString alloc] initWithData:[dict objectForKey:@"data"]
                                         encoding:NSUTF8StringEncoding];
  id json = [str JSONValue];
  NSDictionary *newFriend = (NSDictionary*)json;
  [listArray_ addObject:newFriend];
  [staticList_
      addName:[self formattedNameString:[newFriend objectForKey:@"name"]]];
  [selectedArray_ addObject:newFriend];
  [listView_ reloadData];
  NSLog(@"%@", str);

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [GatherServer getNamesAndPlaces];
  [[NSNotificationCenter defaultCenter] 
      addObserver:self
         selector:@selector(connectionFinished:)
             name:@"GETusers/me/favlists/default"
           object:nil];
  rightContainer_ = [[UIView alloc] initWithFrame:CGRectMake(162, 
                                                            0, 
                                                            158,
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
  listView_.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
  [self.view addSubview:listView_];
  
  staticList_ = [[StaticListView alloc] initWithFrame:CGRectMake(20,
                                                                60,
                                                                100,
                                                                300)];
  [rightContainer_ addSubview:staticList_];
  
  UILabel *top = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                           20,
                                                           100,
                                                           30)];
  // TODO: Centralize font management
  [top setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
  top.backgroundColor = [UIColor clearColor];
  top.textColor = [UIColor colorWithRed:0.25 green:0.75 blue:0.44 alpha:1];
  top.text = @"People";
  [rightContainer_ addSubview:top];
  
  PlusButtonView *plusButton =
      [PlusButtonView buttonWithType:UIButtonTypeCustom];
  
  [plusButton setFrame:CGRectMake(0, 0, 79, 55)];
  [plusButton addTarget:self
                 action:@selector(getContacts:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:plusButton];
  
  listArray_ = [[NSMutableArray alloc] init];
  selectedArray_ = [[NSMutableArray alloc] init];
  [super viewDidLoad];
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

- (NSString*)formattedNameString:(NSString*)name{
  NSRange sep = [name rangeOfString:@" "];

  if (sep.location != NSNotFound) {
      return [name substringToIndex:(sep.location + 2)];
  } else{
      return name; 
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = 
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  SplitListCellView *newCell;

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                   reuseIdentifier:CellIdentifier] autorelease];
    newCell = [[SplitListCellView alloc] init];
    newCell.tag = 447;
    [cell.contentView addSubview:newCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  } else {
    newCell = (SplitListCellView*)[cell.contentView viewWithTag:447];
  }
  
  [newCell setText:[self formattedNameString:
                       [[listArray_ objectAtIndex:indexPath.row] 
                           objectForKey:@"name"]]
          selected:[selectedArray_ containsObject:
                       [listArray_ objectAtIndex:indexPath.row]]];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  SplitListCellView *newCell;
  newCell = (SplitListCellView *)[cell.contentView viewWithTag:447];

  if (newCell.isSelected) {
    [staticList_ removeName:newCell.label.text];
    [selectedArray_ removeObject:[listArray_ objectAtIndex:indexPath.row]];
  } else{
    [staticList_ addName:newCell.label.text];
    [selectedArray_ addObject:[listArray_ objectAtIndex:indexPath.row]];
  }
  
  [newCell switchSelection];
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
  if (lastName == NULL) {
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

  [GatherServer addFriend:name withNumber:phoneNumber];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(friendAdded:)
             name:@"POST/users/me/favlists/default/friends"
           object:nil];
  
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
