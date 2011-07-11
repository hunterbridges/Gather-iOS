//
//  WhoVC.m
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "WhoVC.h"
#import "SessionData.h"

@implementation WhoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    header.font = [UIFont fontWithName:@"UniversLTStd-UltraCn" size:60];
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

- (IBAction) logoutClicked:(id)sender
{
    [[SessionData sharedSessionData] clear];
    
    [[[UIApplication sharedApplication] delegate] resetNavigationForAuthState];
}
@end
