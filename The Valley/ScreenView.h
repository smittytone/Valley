

#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface ScreenView : NSView
{
    NSImage *theView;
    NSImage *theGraphics;
    NSImage *theSplashImage;
    NSInteger *screenArray;

    BOOL splashFlag;
}


- (void)copyScreen:(NSInteger *)arrayAddress;
- (void)drawViewScreen;
- (void)splash:(NSImage *)theImage;


@end
