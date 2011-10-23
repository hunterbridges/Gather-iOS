//
//  splitListViewController.m
//  gather
//
//  Created by Brandon Withrow on 8/8/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "splitListViewController.h"
#import "arrowView.h"
#import "exView.h"
#import "splitListCellView.h"
#import "GatherAPI.h"
#import "plusButtonView.h"
#import "SBJson.h"
#import "PhoneNumberFormatter.h"
@implementation splitListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        //self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
       
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  
}
*/
- (void) getContacts:(id) sender{
    NSLog(@"Button Pressed");
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	
	picker.peoplePickerDelegate = self;
    
	
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
    
}
- (void) connectionFinished:(NSNotification*)notification 
{
    NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
   // NSMutableURLRequest * req = [dict objectForKey:@"request"];
    NSString * str = [[NSString alloc] initWithData:[dict objectForKey:@"data"] encoding:NSUTF8StringEncoding];
    id json = [[str JSONValue] objectForKey:@"friends"];
    NSArray *friends = (NSArray*)json;
    [listArray addObjectsFromArray:friends];
    [listView reloadData];
    NSLog(@"Friends %i", [friends count]);
    NSLog(@"%@", str);

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) friendAdded:(NSNotification*)notification 
{
    NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
   // NSMutableURLRequest * req = [dict objectForKey:@"request"];
    NSString * str = [[NSString alloc] initWithData:[dict objectForKey:@"data"] encoding:NSUTF8StringEncoding];
    id json = [str JSONValue];
    NSDictionary *newFriend = (NSDictionary*)json;
    [listArray addObject:newFriend];
    [staticList addName:[self formattedNameString:[newFriend objectForKey:@"name"]]];
    [selectedArray addObject:newFriend];
    [listView reloadData];
    //NSLog(@"Friends %i", [friends count]);
    NSLog(@"%@", str);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [GatherAPI getNamesAndPlaces];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFinished:) name:@"GETusers/me/favlists/default" object:nil];
    rightContainer = [[UIView alloc] initWithFrame:CGRectMake(162, 0, 158, 460)];
    rightContainer.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
    
    [self.view addSubview:rightContainer];
    listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 158, 405) style:UITableViewStylePlain];
    
    listView.delegate = self;
    listView.dataSource = self;
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.showsVerticalScrollIndicator = NO;
    listView.showsHorizontalScrollIndicator = NO;
    listView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [self.view addSubview:listView];
    
    staticList = [[staticListView alloc] initWithFrame:CGRectMake(20, 60, 100, 300)];
    [rightContainer addSubview:staticList];
    
    UILabel *top = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
    [top setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:24]];
    top.backgroundColor = [UIColor clearColor];
    top.textColor = [UIColor colorWithRed:0.25 green:0.75 blue:0.44 alpha:1];
    top.text = @"People";
    [rightContainer addSubview:top];
    
    plusButtonView *plusButton = [plusButtonView buttonWithType:UIButtonTypeCustom];
    
    [plusButton setFrame:CGRectMake(0, 0, 79, 55)];
     [plusButton addTarget:self action:@selector(getContacts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusButton];
    
    listArray = [[NSMutableArray alloc] init/*WithObjects:[NSString stringWithFormat:@"Steve J"],
                 [NSString stringWithFormat:@"Hunter B"],
                 [NSString stringWithFormat:@"Daniel S"],
                 [NSString stringWithFormat:@"Brandon W"],
                 [NSString stringWithFormat:@"Hunter V"],
                 [NSString stringWithFormat:@"Sheena A"],
                 [NSString stringWithFormat:@"Adam B"],
                 [NSString stringWithFormat:@"Eddie F"],nil*/];
    selectedArray = [[NSMutableArray alloc] init];
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
	return [listArray count];
	
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSString*)formattedNameString:(NSString*)name{
    NSRange sep = [name rangeOfString:@" "];
    
    if (sep.location != NSNotFound) {
        return [name substringToIndex:(sep.location + 2)];
    }else{
        return name; 
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	splitListCellView *newCell;
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle 
				 reuseIdentifier:CellIdentifier] autorelease];
        newCell = [[splitListCellView alloc] init];
        newCell.tag = 447;
        [cell.contentView addSubview:newCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}else {
		newCell = (splitListCellView*)[cell.contentView viewWithTag:447];
	}
    [newCell setText:[self formattedNameString:[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]] selected:[selectedArray containsObject:[listArray objectAtIndex:indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    splitListCellView *newCell;
    newCell = (splitListCellView*)[cell.contentView viewWithTag:447];
    
    if (newCell.isSelected) {
        [staticList removeName:newCell.label.text];
        [selectedArray removeObject:[listArray objectAtIndex:indexPath.row]];
    }else{
    [staticList addName:newCell.label.text];
        [selectedArray addObject:[listArray objectAtIndex:indexPath.row]];
    }
    [newCell switchSelection];
}

//Adress Picker Delegate Methods
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    NSString* phoneNumber;
	NSString* name;
   // [listArray addObject:(NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty)];
   // [listView reloadData];
	NSString *firsName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);	
    if (lastName == NULL) {
        name = firsName;
    }else{
	name = [firsName stringByAppendingFormat:@" %@", lastName];
	}
    
    ABMultiValueRef phoneNumbers = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFRelease(phoneNumbers);
    NSLog(@"%ld", ABMultiValueGetCount(phoneNumbers));
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        PhoneNumberFormatter * pn = [[PhoneNumberFormatter alloc] init];
         phoneNumber = [pn strip:(NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0)];
        [pn release];
        NSLog(@"Phone Number %@", phoneNumber);
    }else{
        //Handle no phone number notification alert here.
        phoneNumber = [NSString stringWithFormat:@""];
    }
    
    [GatherAPI addFriend:name Number:phoneNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendAdded:) name:@"POST/users/me/favlists/default/friends" object:nil];
    NSLog(@"Name:%@ Number:%@", name, phoneNumber);
	//number.text = (NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
    
    
	
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}
@end
