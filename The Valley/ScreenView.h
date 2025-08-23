

// macOS software © Tony Smith 2012-25, based on work
// by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface ScreenView : NSView
{
    NSImage *theView;
    NSImage *theGraphics;
    NSImage *altGraphics;
    NSInteger *screenArray;

    BOOL splashFlag;
    BOOL useAltGraphics;
}


- (void)copyScreen:(NSInteger *)arrayAddress;
- (void)drawViewScreen;
- (void)showSplash:(NSImage *)image;
- (void)useAltGraphics:(BOOL)doUse;


@property (nonatomic, strong, setter=showSplash:) NSImage *splashImage;


@end
