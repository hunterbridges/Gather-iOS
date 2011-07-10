//
//  IndexedURLConnection.h
//  gather
//
//  Created by Hunter B on 7/9/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IndexedURLConnection : NSURLConnection <NSCopying> {
    NSUInteger _hash;
}

- (id) initWithRequest:(NSURLRequest *)request hash:(NSUInteger)hash delegate:(id)delegate;

@end
