

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "ValleyWindow.h"

@implementation ValleyWindow

@synthesize enableKeys;


- (void)awakeFromNib
{
    enableKeys = YES;

    [super awakeFromNib];
}



- (void)sendEvent:(NSEvent *)event
{
    // Intercept key presses during combat, if 'enableKeys' is false

    if (!enableKeys && (event.type == NSEventTypeKeyUp || event.type == NSEventTypeKeyDown))
    {
        NSString *c = event.characters;
        BOOL value = [c compare:@"B"] || [c compare:@"L"] || [c compare:@"H"];

        if (value)
        {
            NSEvent *newEvent = [NSEvent keyEventWithType:event.type
                                                 location:event.locationInWindow
                                            modifierFlags:event.modifierFlags
                                                timestamp:event.timestamp
                                             windowNumber:event.windowNumber
                                                  context:nil
                                               characters:@" "
                              charactersIgnoringModifiers:@" "
                                                isARepeat:NO
                                                  keyCode:event.keyCode];

            [super sendEvent:newEvent];
            return;
        }
    }

    // Block all key repeat events

    if ((event.type == NSEventTypeKeyUp || event.type == NSEventTypeKeyDown) && event.isARepeat) return;

    [super sendEvent:event];
}


@end