

// macOS software © Tony Smith 2012-20, based on work
// by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface MessageView : NSView
{
    NSInteger bufferRowOne[40];
    NSInteger bufferRowTwo[40];
    NSInteger bufferRowThree[40];
    NSImage *characterSet;
    NSImage *alphaBlend;
    BOOL same;
}


- (void)update:(NSString *)value;
- (void)clearBuffer;


@property (nonatomic, strong, setter=update:) NSString *inputString;
@property (readwrite) NSInteger space;
@property (readwrite) BOOL doDelay;


@end
