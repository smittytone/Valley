

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "MessageView.h"
#import "Constants.h"


@implementation MessageView

@synthesize inputString, space;



- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self clearBuffer];

        characterSet = [NSImage imageNamed:@"petchars_c"];
        alphaBlend = [NSImage imageNamed:@"alpha"];
        space = 0;
    }
    
    return self;
}



- (void)awakeFromNib
{
    [self clearBuffer];

    characterSet = [NSImage imageNamed:@"petchars_c"];
    alphaBlend = [NSImage imageNamed:@"alpha"];
    space = kGraphicSpace;
}



- (void)drawRect:(NSRect)dirtyRect
{
    for (NSUInteger i = 0 ; i < 39 ; ++i)
    {
        // Row One
        // Calculate the co-ords on the char image from the code
        
        NSInteger theGraphicCode = bufferRowOne[i];
        NSInteger row = theGraphicCode / 16;
        NSInteger col = theGraphicCode - (row * 16);
        NSRect rect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 32) 
                         fromRect: rect
                        operation: NSCompositingOperationCopy 
                         fraction: 1.0];
        
        // Row Two
        // Calculate the co-ords on the char image from the code
        
        theGraphicCode = bufferRowTwo[i];
        row = theGraphicCode / 16;
        col = theGraphicCode - (row * 16);
        rect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 16) 
                         fromRect: rect
                        operation: NSCompositingOperationCopy 
                         fraction: 1.0];
        
        // Row Three
        // Calculate the co-ords on the char image from the code

        theGraphicCode = bufferRowThree[i];
        row = theGraphicCode / 16;
        col = theGraphicCode - (row * 16);
        rect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 0) 
                         fromRect: rect
                        operation: NSCompositingOperationCopy 
                         fraction: 1.0];
    }
    
    // Draw in the blend
    
    [alphaBlend drawAtPoint: NSMakePoint(0, 0) 
                     fromRect: NSMakeRect(0, 0, 640 , 48) 
                  operation: NSCompositingOperationSourceOver 
                     fraction: 0.7];
}



- (void)update:(NSString *)value
{
    // Scroll buffer

    if ([value compare:inputString] == NSOrderedSame) [self clearBuffer];

    inputString = value;

    for (NSUInteger i = 0 ; i < 40 ; ++i)
    {
        // Move rows two and three up, overwriting row one
        
        bufferRowOne[i] = bufferRowTwo[i];
        bufferRowTwo[i] = bufferRowThree[i];
        
        // Fill in the new row three with spaces
        
        bufferRowThree[i] = space;
    }
    
    NSUInteger stringLength = inputString.length;
    
    if (stringLength > 40) stringLength = 40;
    
    NSUInteger lineInset = (40 - stringLength) / 2;
    
    for (NSUInteger i = 0 ; i < stringLength ; ++i)
    {
        // Run through each character and obtain the Ascii code
        
        bufferRowThree[lineInset + i] = [inputString characterAtIndex:i];
    }
    
    [self setNeedsDisplay:YES];
}



- (void)clearBuffer
{
    for (NSUInteger i = 0 ; i < 40 ; ++i)
    {
        bufferRowOne[i] = space;
        bufferRowTwo[i] = space;
        bufferRowThree[i] = space;
    }
    
    inputString = @"";
    
    [self setNeedsDisplay:YES];
}



@end
