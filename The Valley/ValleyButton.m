//
//  ValleyButton.m
//  The Valley
//
//  Created by Tony Smith on 11/8/17.
//  Copyright © 2017 Tony Smith. All rights reserved.
//

#import "ValleyButton.h"

@implementation ValleyButton


- (void)drawRect:(NSRect)dirtyRect {

    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void)mouseUp:(NSEvent *)event
{
    // Intercept mouse clicks

    if (event.type == NSEventTypeLeftMouseUp)
    {
        NSRect bb = self.frame;
        NSPoint mp = event.locationInWindow;

        if (mp.x >= bb.origin.x && mp.x <= bb.origin.x + bb.size.width)
        {
            if (mp.y >= bb.origin.y && mp.y <= bb.origin.y + bb.size.height)
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

                [super mouseUp:newEvent];
                NSBeep();
                return;
            }
        }
    }

    [super mouseUp:event];
}

@end
