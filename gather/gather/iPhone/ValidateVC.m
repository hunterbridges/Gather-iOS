//
//  ValidateVC.m
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "ValidateVC.h"
#import "SessionData.h"
#import "GatherAPI.h"
#import "SBJson.h"
#import "NSObject+SBJson.h"
#import "gatherAppState.h"
#import "FinalizeVC.h"

@implementation ValidateVC

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
    
    [verificationLabel setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:60]];
    [message setFont:[UIFont fontWithName:@"UniversLTStd-UltraCn" size:20]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalVerification:) name:@"verification_from_link" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    if (!requested)
    {
        NSString * udid = [[[UIDevice currentDevice] uniqueIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSMutableDictionary * dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setObject:[[SessionData sharedSessionData] phoneNumber] forKey:@"phone_number"];
        [dict setObject:udid forKey:@"device_udid"];
        [dict setObject:[[UIDevice currentDevice] model] forKey:@"device_type"];
        
        [GatherAPI request:@"tokens" requestMethod:@"POST" requestData:dict];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFinished:) name:@"POSTtokens" object:nil];
        
        message.text = kCommunicatingText;
        
        requested = YES;
    }
    
    if ([message.text isEqualToString:kEnterVerificationText] || [message.text isEqualToString:kSwipeLeftText])
    {
        [verificationField becomeFirstResponder];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [verificationField resignFirstResponder];
}
- (void) connectionFinished:(NSNotification*)notification 
{
    NSMutableDictionary * dict = (NSMutableDictionary *)[notification userInfo];
    NSMutableURLRequest * req = [dict objectForKey:@"request"];
    
    if ([GatherAPI request:req isCallToMethod:@"tokens"])
    {
        NSString * str = [[NSString alloc] initWithData:[dict objectForKey:@"data"] encoding:NSUTF8StringEncoding];
        id json = [str JSONValue];
        
        if ([json objectForKey:@"token"] != nil)
        {
            [[SessionData sharedSessionData] setToken:[json objectForKey:@"token"]];
            
            [[[UIApplication sharedApplication] delegate] setAppState:kGatherAppStateLoggedOutNeedsVerification];
            message.text = kEnterVerificationText;
            [verificationField becomeFirstResponder];
        }
        
        NSLog(@"%@", str);
        [str release];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) externalVerification:(NSNotification*)notification
{
    verificationField.text = [[notification userInfo] objectForKey:@"verification"];
    [self verificationDisplayFilter:[[notification userInfo] objectForKey:@"verification"]];
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
        
        [self verificationDisplayFilter:post];
        
        return TRUE;
    }
}

- (void) verificationDisplayFilter:(NSString *) post
{
    verificationLabel.text = post;
    
    if ([post length] == 6)
    {
        message.text = kSwipeLeftText;
        
        [[[UIApplication sharedApplication] delegate] setAppState:kGatherAppStateLoggedOutHasVerification];
        
        verificationLabel.textColor = [UIColor colorWithRed:1.0 green:93.0/255.0 blue:53.0/255.0 alpha:1.0];
        
        [[SessionData sharedSessionData] setVerification:post];
        
        FinalizeVC *new = [[FinalizeVC alloc] initWithNibName:@"FinalizeVC" bundle:nil];
        [[[[UIApplication sharedApplication] delegate] slideView] addNewPage: new];
    } else {
        message.text = kEnterVerificationText;
        [[[UIApplication sharedApplication] delegate] setAppState:kGatherAppStateLoggedOutNeedsVerification];
        
        [[SessionData sharedSessionData] setVerification:nil];
        verificationLabel.textColor = [UIColor blackColor];
        
   /*     if ([[[[UIApplication sharedApplication] delegate] slideView] pageCount] > 2)
        {
            [[[[UIApplication sharedApplication] delegate] slideView] removePage:3];
        }*/
    }
}
@end
