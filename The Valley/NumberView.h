

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface NumberView : NSView
{
    NSInteger digits;
    NSInteger buffer[10];
    NSImage *characterSet;
    NSString *numberString;
}


- (void)update:(NSInteger)value;
- (void)clearBuffer;


@property (nonatomic, readwrite, setter=update:) NSInteger inputValue;
@property (readwrite) BOOL inverse;

@end
