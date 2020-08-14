

// macOS software © Tony Smith 2012-20, based on work
// by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "ValleyWindow.h"

@implementation ValleyWindow

@synthesize enableKeys;


- (void)awakeFromNib
{
    // Enable buttons' key clicks from the start

    enableKeys = YES;

    [super awakeFromNib];
}



- (void)sendEvent:(NSEvent *)event
{
    // Intercept key presses during combat

    if (event.type == NSEventTypeKeyUp || event.type == NSEventTypeKeyDown)
    {
        // If 'enableKeys' is false, trap the key-press for certain keys
        // and replace it with an action-less press

        if (!enableKeys)
        {
            NSString *c = event.characters;
            BOOL value = [c compare:@"B"] || [c compare:@"L"] || [c compare:@"H"] || [c compare:@"S"] ||
            [c compare:@"1"] || [c compare:@"2"] || [c compare:@"3"] || [c compare:@"4"] || [c compare:@"5"] ||
            [c compare:@"6"] || [c compare:@"7"] || [c compare:@"8"] || [c compare:@"9"];

            if (value)
            {
                // B, H or L pressed at a time when we don't want to record those presses
                // So generate an alternative event to replace the incoming one

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

                // And pass it along the chain

                [super sendEvent:newEvent];

                return;
            }
        }

        // If the key press is good to go, just make sure it's not a repeat event

        if (event.isARepeat) return;
    }

    [super sendEvent:event];
}



- (BOOL)canBecomeKeyWindow
{
    return YES;
}



- (BOOL)canBecomeMainWindow
{
    return YES;
}


@end
