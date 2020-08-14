

// macOS software © Tony Smith 2012-20, based on work
// by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface ScreenView : NSView
{
    NSImage *theView;
    NSImage *theGraphics;
    NSInteger *screenArray;

    BOOL splashFlag;
}


- (void)copyScreen:(NSInteger *)arrayAddress;
- (void)drawViewScreen;
- (void)showSplash:(NSImage *)image;


@property (nonatomic, strong, setter=showSplash:) NSImage *splashImage;


@end
