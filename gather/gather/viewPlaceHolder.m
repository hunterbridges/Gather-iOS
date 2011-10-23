//
//  viewPlaceHolder.m
//  gather
//
//  Created by Brandon Withrow on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "viewPlaceHolder.h"
#import "slideViewController.h"

@implementation viewPlaceHolder

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
-(void)setViewNumber:(int)viewNum{
   
    numberLabel.text = [NSString stringWithFormat:@"Page %i", viewNum];
    
}
#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)aMethod:(id)sender{
    viewPlaceHolder *new = [[viewPlaceHolder alloc] init];
    [[[[UIApplication sharedApplication] delegate] slideView] resetWithPage:new];
    
}

-(void)bMethod:(id)sender{
   
    [[[[UIApplication sharedApplication] delegate] slideView] scrollToPage:1];
    
}

-(void)cMethod:(id)sender{
    
    [[[[UIApplication sharedApplication] delegate] slideView] scrollToLastPage];
    
}
-(void)dMethod:(id)sender{
    
    [[[[UIApplication sharedApplication] delegate] slideView] setScrollStop:[[[[UIApplication sharedApplication] delegate] slideView] currentPage]];
    
}
-(void)eMethod:(id)sender{
    viewPlaceHolder *new = [[viewPlaceHolder alloc] init];
    [[[[UIApplication sharedApplication] delegate] slideView] pushNewPage:new];
    //[[[[UIApplication sharedApplication] delegate] slideView] resetScrollStop];
    
}

- (void)viewDidLoad
{
    UITableView *testTable = [[UITableView alloc] initWithFrame:CGRectMake(170, 0, 150, 480)];
    testTable.backgroundView.backgroundColor = [UIColor clearColor];
    testTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:testTable];
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 100, 22)];
    numberLabel.text =[NSString stringWithFormat:@"Page %i", ([[[[UIApplication sharedApplication] delegate] slideView] pageCount] +1)];
    numberLabel.backgroundColor = [UIColor clearColor];
    float redCol =  ((arc4random()%9)/9.0) + 0.1;
    float blueCol =  ((arc4random()%9)/9.0) + 0.1;
    float greenCol = ((arc4random()%9)/9.0) + 0.1;
    NSLog(@"%f %f %f", redCol, greenCol, blueCol);
    self.view.backgroundColor = [UIColor colorWithRed:redCol green:greenCol blue:blueCol alpha:1];
    [self.view addSubview:numberLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Reset Page" forState:UIControlStateNormal];
    button.frame = CGRectMake(20.0, 210.0, 145.0, 40.0);
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self 
               action:@selector(bMethod:)
     forControlEvents:UIControlEventTouchDown];
    [button2 setTitle:@"First Page" forState:UIControlStateNormal];
    button2.frame = CGRectMake(20.0, 260.0, 145.0, 40.0);
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 addTarget:self 
                action:@selector(cMethod:)
      forControlEvents:UIControlEventTouchDown];
    [button3 setTitle:@"Last Page" forState:UIControlStateNormal];
    button3.frame = CGRectMake(20.0, 300.0, 145.0, 40.0);
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 addTarget:self 
                action:@selector(dMethod:)
      forControlEvents:UIControlEventTouchDown];
    [button4 setTitle:@"Set Stop" forState:UIControlStateNormal];
    button4.frame = CGRectMake(20.0, 350.0, 145.0, 40.0);
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button5 addTarget:self 
                action:@selector(eMethod:)
      forControlEvents:UIControlEventTouchDown];
    [button5 setTitle:@"NEW PAGE" forState:UIControlStateNormal];
    button5.frame = CGRectMake(20.0, 390.0, 145.0, 40.0);
    [self.view addSubview:button5];
    [super viewDidLoad];
}
- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"%@ APPEARED", numberLabel.text);
    [super viewDidAppear:animated];
    
}
- (void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"%@ DISSAPPEARD", numberLabel.text);
    [super viewDidDisappear:animated];
   
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
