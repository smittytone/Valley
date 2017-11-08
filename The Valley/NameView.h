

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface NameView : NSView
{
    NSInteger buffer[40];
    NSImage *characterSet;
}


- (void)update:(NSString *)value;
- (void)clearBuffer;


@property (nonatomic, strong, setter=update:) NSString *inputString;
@property (readwrite) BOOL inverse;

@end
