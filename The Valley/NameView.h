

#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface NameView : NSView
{
    NSInteger buffer[40];
    NSInteger stringLength;
    NSString *inputString;
    NSImage *characterSet;
    
    BOOL isInverseFlag;
}


- (void)update;
- (void)clearBuffer;
- (void)inverseVideo;


@property (nonatomic, retain) NSString *inputString;


@end
