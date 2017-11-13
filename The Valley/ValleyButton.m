

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "ValleyButton.h"

@implementation ValleyButton

@synthesize enableClicks;



- (void)awakeFromNib
{
    // Enable clicks on UI buttons from the get-go

    enableClicks = YES;

    [super awakeFromNib];
}



- (void)mouseDown:(NSEvent *)event
{
    // Trap mouse clicks if 'enableClicks' is false

    if (!enableClicks)
    {
        // Create a dummy event to pass up the chain
        
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
