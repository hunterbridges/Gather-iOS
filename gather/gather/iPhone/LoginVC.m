//
//  LoginVC.m
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "LoginVC.h"
#import "PhoneNumberFormatter.h"


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
    
    [phoneNumberField becomeFirstResponder];
    
    [phoneNumberLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:60]];
    
    [instructionsLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:20]];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if ([string rangeOfCharacterFromSet:set].location != NSNotFound) {
        return FALSE;
    } else {
        NSString * post = [[textField text] stringByReplacingCharactersInRange:range withString:string];
        
        PhoneNumberFormatter * pn = [[PhoneNumberFormatter alloc] init];
        
        phoneNumberLabel.text = [pn format:post withLocale:@"us"];
        return TRUE;
    }
}

@end
