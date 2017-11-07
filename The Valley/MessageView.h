

#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface MessageView : NSView
{
    // Screen row value stores
    
    NSInteger buffer_row_one[40];
    NSInteger buffer_row_two[40];
    NSInteger buffer_row_three[40];
    NSString *inputString;
    NSImage *characterSet;
    NSImage *alphaBlend;
}


- (void)update;
- (void)clearBuffer;


@property (nonatomic, retain) NSString *inputString;


@end
