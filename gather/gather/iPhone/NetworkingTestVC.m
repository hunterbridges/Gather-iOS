//
//  NetworkingTestVC.m
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "NetworkingTestVC.h"


@implementation NetworkingTestVC

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
    
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com/"]];
    [[ConnectionManager sharedInstance] connectRequest:req];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFinished:) name:kConnectionFinishedNotification object:nil];
}

- (void) connectionFinished:(NSNotification*)notification 
{
    NSDictionary * dict = [notification userInfo];
    
    NSString * str = [[NSString alloc] initWithData:[dict objectForKey:@"data"] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    [str release];
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

@end
