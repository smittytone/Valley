

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "ValleyButton.h"

@implementation ValleyButton

@synthesize enableClicks;



- (void)awakeFromNib
{
    enableClicks = YES;

    [super awakeFromNib];
}



- (void)mouseDown:(NSEvent *)event
{
    if (!enableClicks && (event.type == NSEventTypeLeftMouseDown || event.type == NSEventTypeLeftMouseUp))
    {
        NSEvent *newEvent = [NSEvent mouseEventWithType:event.type
                                               location:NSMakePoint(0, 0)
                                          modifierFlags:event.modifierFlags
                                              timestamp:event.timestamp
                                           windowNumber:event.windowNumber
                                                context:nil
                                            eventNumber:event.eventNumber
                                             clickCount:event.clickCount
                                               pressure:event.pressure];

        [super mouseDown:newEvent];

        return;
    }

    [super mouseDown:event];
}


@end
