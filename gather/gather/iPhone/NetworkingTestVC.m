#import "NetworkingTestVC.h"
#import "GatherAPI.h"

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
    
    
    // BEGIN LOGIN REQUEST
    NSString * udid = [[[UIDevice currentDevice] uniqueIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:@"2054753697" forKey:@"phone_number"];
    [dict setObject:udid forKey:@"device_udid"];
    [dict setObject:[[UIDevice currentDevice] model] forKey:@"device_type"];
    NSLog(@"%@", udid);
    
    [GatherAPI request:@"tokens" requestMethod:@"POST" requestData:dict];
    //END LOGIN REQUEST
    
    
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
