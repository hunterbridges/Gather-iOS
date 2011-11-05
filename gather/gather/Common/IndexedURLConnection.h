#import <Foundation/Foundation.h>


@interface IndexedURLConnection : NSURLConnection <NSCopying> {
    NSUInteger hash_;
}

- (id)initWithRequest:(NSURLRequest *)request
                 withHash:(NSUInteger)hash
             withDelegate:(id)delegate;
- (void)setHash:(NSUInteger)newHash;
- (NSString *)hashString;

@end
