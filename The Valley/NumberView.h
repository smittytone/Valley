

#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface NumberView : NSView
{
    NSInteger inputValue, digits;
    NSInteger buffer[10];
    NSImage *characterSet;
    
    BOOL isInverseFlag;
}


- (void)update;
- (void)clearBuffer;
- (void)inverseVideo;


@property (nonatomic) NSInteger inputValue;


@end
