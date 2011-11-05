#import "IndexedURLConnection.h"


@implementation IndexedURLConnection

- (id)initWithRequest:(NSURLRequest *)request
             withHash:(NSUInteger)hash
         withDelegate:(id)delegate {
  if ((self = [super initWithRequest:request delegate:delegate])) {
    hash_ = hash;
  }

  return self;
}

- (NSUInteger) hash {
    return hash_;
}

- (void) setHash:(NSUInteger)newHash {
    hash_ = newHash;
}

- (BOOL) isEqual:(id)object {
  if ([object isMemberOfClass:[IndexedURLConnection class]])
  { 
    return [self hash] == [object hash];
  } else {
    return NO;
  }
}

- (id) copyWithZone:(NSZone *)zone {
  IndexedURLConnection * copy =
      [[IndexedURLConnection allocWithZone:zone] init];
  [copy setHash:[self hash]];
  
  return copy;
}

- (NSString *) hashString {
    return [NSString stringWithFormat:@"%d", hash_];
}
@end
