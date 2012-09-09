#include <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "SessionData.h"

@interface SessionData ()
- (NSString *)macAddress;
- (NSString *)shaWithString:(NSString *)input;
@end

@implementation SessionData

@synthesize loggedIn = loggedIn_;
@synthesize token = token_;
@synthesize verification = verification_;
@synthesize phoneNumber = phoneNumber_;
@synthesize currentUserId = currentUserId_;
@synthesize syncing = syncing_;

// TODO: Maybe use Keychain instead of user defaults?
- (id)init {
  if ((self = [super init])) {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
  
    token_ = [prefs objectForKey:@"token"];
    verification_ = [prefs objectForKey:@"verification"];
    loggedIn_ = [prefs boolForKey:@"loggedIn"];
        
    phoneNumber_ = nil;
    currentUserId_ = 0;
  }
  return self;
}

- (void)saveSession {
  NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
  
  if (token_ != nil) {
      [prefs setObject:token_ forKey:@"token"];
  } else {
      [prefs removeObjectForKey:@"token"];
  }
  
  if (verification_ != nil) {
      [prefs setObject:verification_ forKey:@"verification"];
  } else {
      [prefs removeObjectForKey:@"verification"];
  }
  
  [prefs setBool:loggedIn_ forKey:@"loggedIn"];  
  [prefs synchronize];
}

- (void) clear {
  token_ = nil;
  verification_ = nil;
  loggedIn_ = NO;
    
	username_ = nil;
	currentUserId_ = 0;
    
  [self saveSession];
}

- (void) needsSync {
	[self syncWithServer];
}

- (void) syncWithServer {
	syncing_ = YES;
    
  // TODO: Init sync request
}

// TODO: sync store callback

- (void)dealloc {
  [super dealloc];
}

#pragma mark Device Token stuff
- (NSString *)deviceToken {
  if (deviceToken_) {
    return deviceToken_;
  }
  
  deviceToken_ = [[self shaWithString:[self macAddress]] retain];
  return deviceToken_;
}

- (NSString *)deviceType {
  return [[UIDevice currentDevice] model];
}

- (NSString *)macAddress {
  int                 mgmtInfoBase[6];
  char                *msgBuffer = NULL;
  size_t              length;
  unsigned char       macAddress[6];
  struct if_msghdr    *interfaceMsgStruct;
  struct sockaddr_dl  *socketStruct;
  NSString            *errorFlag = NULL;
  
  mgmtInfoBase[0] = CTL_NET;
  mgmtInfoBase[1] = AF_ROUTE;
  mgmtInfoBase[2] = 0;              
  mgmtInfoBase[3] = AF_LINK;
  mgmtInfoBase[4] = NET_RT_IFLIST;
  
  if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) {
    errorFlag = @"if_nametoindex failure";
  } else {
    if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) {
      errorFlag = @"sysctl mgmtInfoBase failure";
    } else {
      if ((msgBuffer = malloc(length)) == NULL) {
        errorFlag = @"buffer allocation failure";
      } else {
        if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) {
          errorFlag = @"sysctl msgBuffer failure";
        }
      }
    }
  }
  
  if (errorFlag != NULL) {
    NSLog(@"Error: %@", errorFlag);
    return errorFlag;
  }
  
  interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
  socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
  memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
  NSString *macAddressString = 
      [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
          macAddress[0], macAddress[1], macAddress[2], 
          macAddress[3], macAddress[4], macAddress[5]];
  NSLog(@"Mac Address: %@", macAddressString);
  
  free(msgBuffer);
  
  return macAddressString;
}

- (NSString *)shaWithString:(NSString *)input {
  const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:input.length];
  
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1(data.bytes, data.length, digest);
  
  NSMutableString* output =
      [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
    [output appendFormat:@"%02x", digest[i]];
  }
  
  return output;
}

@end
