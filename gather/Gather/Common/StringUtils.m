#import "StringUtils.h"

@implementation StringUtils

+ (NSString*)formattedNameString:(NSString*)name{
  name = [name uppercaseString];
  NSRange sep = [name rangeOfString:@" "];
  
  if (sep.location != NSNotFound) {
    return [name substringToIndex:(sep.location + 2)];
  } else{
    return name; 
  }
}

@end
