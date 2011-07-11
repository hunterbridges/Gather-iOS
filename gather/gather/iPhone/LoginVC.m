//
//  LoginVC.m
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "LoginVC.h"
#import "PhoneNumberFormatter.h"
#import "ValidateVC.h"
#import "SessionData.h"
#import "gatherAppState.h"

@implementation LoginVC

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
    
    [phoneNumberLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:60]];
    
    [instructionsLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:20]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [phoneNumberField becomeFirstResponder];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [phoneNumberField resignFirstResponder];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if ([string rangeOfCharacterFromSet:set].location != NSNotFound) {
        return FALSE;
    } else {
        NSString * post = [[textField text] stringByReplacingCharactersInRange:range withString:string];
        
        PhoneNumberFormatter * pn = [[PhoneNumberFormatter alloc] init];
        
        phoneNumberLabel.text = [pn format:post withLocale:@"us"];
        
        if ([post length] == 10 && [[[phoneNumberLabel text] substringToIndex:1] isEqualToString:@"("])
        {
            instructionsLabel.text = @"SWIPE LEFT TO LOG IN";
            phoneNumberLabel.textColor = [UIColor colorWithRed:1.0 green:93.0/255.0 blue:53.0/255.0 alpha:1.0];
            
            [[SessionData sharedSessionData] setPhoneNumber:post];
            [[[UIApplication sharedApplication] delegate] setAppState:kGatherAppStateLoggedOutHasPhoneNumber];
            
            ValidateVC *new = [[ValidateVC alloc] initWithNibName:@"ValidateVC" bundle:nil];
            [[[[UIApplication sharedApplication] delegate] slideView] addNewPage: new];
        } else {
            instructionsLabel.text = @"HELLO. WHAT IS YOUR CELL PHONE NUMBER?";
            phoneNumberLabel.textColor = [UIColor blackColor];
            
            [[[UIApplication sharedApplication] delegate] setAppState:kGatherAppStateLoggedOutNeedsPhoneNumber];
            
            if ([[[[UIApplication sharedApplication] delegate] slideView] pageCount] > 1)
            {
                [[[[UIApplication sharedApplication] delegate] slideView] removePage:2];
            }
            
            [[SessionData sharedSessionData] setPhoneNumber:nil];
        }
        
        return TRUE;
    }
}

@end
