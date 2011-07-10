//
//  IndexedURLConnection.m
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import "IndexedURLConnection.h"


@implementation IndexedURLConnection

- (id) initWithRequest:(NSURLRequest *)request hash:(NSUInteger)hash delegate:(id)delegate
{
    if ((self = [super initWithRequest:request delegate:delegate]))
    {
        _hash = hash;
    }
    
    return self;
}

- (NSUInteger) hash
{
    return _hash;
}

- (void) setHash:(NSUInteger)newHash
{
    _hash = newHash;
}

- (BOOL) isEqual:(id)object
{
    if ([object isMemberOfClass:[IndexedURLConnection class]])
    { 
        return [self hash] == [object hash];
    } else {
        return NO;
    }
}

- (id) copyWithZone:(NSZone *)zone
{
    IndexedURLConnection * copy = [[IndexedURLConnection allocWithZone:zone] init];
    [copy setHash:[self hash]];
    
    return copy;
}

- (NSString *) hashString
{
    return [NSString stringWithFormat:@"%d", _hash];
}
@end
