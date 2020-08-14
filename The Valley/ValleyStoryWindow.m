

// macOS software © Tony Smith 2012-20, based on work
// by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "ValleyStoryWindow.h"

@implementation ValleyStoryWindow

@synthesize initialLocation;



- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSWindowStyleMask)style
                  backing:(NSBackingStoreType)backingStoreType
                    defer:(BOOL)flag
{

    // NOTE Using NSBorderlessWindowMask results in a window without a title bar.

    self = [super initWithContentRect:contentRect
                            styleMask:NSWindowStyleMaskBorderless
                              backing:NSBackingStoreBuffered
                                defer:flag];

    if (self != nil)
    {
        self.alphaValue = 1.0;
        self.backgroundColor = NSColor.clearColor;
        self.opaque = YES;
        self.hasShadow = YES;
    }

    return self;
}



- (void)mouseDown:(NSEvent *)theEvent
{
    // Get the mouse location in window coordinates.

    initialLocation = theEvent.locationInWindow;
}



- (void)mouseDragged:(NSEvent *)theEvent
{
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = self.frame;
    NSPoint newOrigin = windowFrame.origin;

    // Get the mouse location in window coordinates.

    NSPoint currentLocation = [theEvent locationInWindow];

    // Update the origin with the difference between the new mouse location and the old mouse location.

    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);

    // Don't let window get dragged up under the menu bar

    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height))
    {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }

    // Move the window to the new location

    [self setFrameOrigin:newOrigin];
}



- (BOOL)canBecomeKeyWindow
{
    return YES;
}



- (BOOL)canBecomeMainWindow
{
    return NO;
}



@end
