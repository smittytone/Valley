
#import "MessageView.h"

@implementation MessageView

@synthesize inputString;



- (id)initWithFrame:(NSRect)frame
{
    NSString *path;
    
    self = [super initWithFrame:frame];

    if (self)
    {
        [self clearBuffer];

        path = @"petchars_b";
        path = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        characterSet = [[NSImage alloc] initWithContentsOfFile:path];

        path = @"alpha";
        path = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        alphaBlend = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    return self;
}



- (void)drawRect:(NSRect)dirtyRect
{
    NSInteger row, col, theGraphicCode;
    NSRect inputRect;
    
    
    for (NSUInteger i = 0 ; i < 39 ; ++i)
    {
        // Run through along the rows of the buffer and draw the appropriate chars on the screen
        // First, row one
        
        theGraphicCode = buffer_row_one[i];
        
        // Calculate the co-ords on the char image from the code
        
        row = (theGraphicCode / 16);
        col = theGraphicCode - (row * 16);
        inputRect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 32) 
                         fromRect: inputRect 
                        operation: NSCompositeCopy 
                         fraction: 1.0];
        
        // Row two
        
        theGraphicCode = buffer_row_two[i];
        
        // Calculate the co-ords on the char image from the code
        
        row = (theGraphicCode / 16);
        col = theGraphicCode - (row * 16);
        
        inputRect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 16) 
                         fromRect: inputRect 
                        operation: NSCompositeCopy 
                         fraction: 1.0];
        
        // Row three
        
        theGraphicCode = buffer_row_three[i];
        
        // Calculate the co-ords on the char image from the code
        
        row = (theGraphicCode / 16);
        col = theGraphicCode - (row * 16);
        
        inputRect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 0) 
                         fromRect: inputRect 
                        operation: NSCompositeCopy 
                         fraction: 1.0];
    }
    
    // Draw in the blend
    
    [alphaBlend drawAtPoint: NSMakePoint(0, 0) 
                     fromRect: NSMakeRect(0, 0, 640 , 48) 
                    operation: NSCompositeSourceOver 
                     fraction: 1.0];
}



- (void)update
{
    extern NSInteger gVariable;
    
    NSUInteger stringLength, lineInset, thing;
    
    // Scroll buffer
    
    for (NSUInteger i = 0 ; i < 40 ; ++i)
    {
        // Move rows two and three up, overwriting row one
        
        buffer_row_one[i] = buffer_row_two[i];
        buffer_row_two[i] = buffer_row_three[i];
        
        thing = 0;
        
        if ((gVariable % 20) == 0) thing = 32;
        
        // Fill in the new row three with spaces
        
        buffer_row_three[i] = thing;
    }
    
    stringLength = [inputString length];
    
    if (stringLength > 40) stringLength = 40;
    
    lineInset = (40 - stringLength) / 2;
    
    for (NSUInteger i = 0 ; i < stringLength ; ++i)
    {
        // Run through each character and obtain the Ascii code
        
        buffer_row_three[lineInset + i] = [inputString characterAtIndex:i];
    }
    
    [self setNeedsDisplay:YES];
}



- (void)clearBuffer
{
    for (NSUInteger i = 0 ; i < 40 ; ++i)
    {
        buffer_row_one[i] = 0;
        buffer_row_two[i] = 0;
        buffer_row_three[i] = 0;
    }
    
    inputString = @"";
    
    [self setNeedsDisplay:YES];
}



- (void)keyDown:(NSEvent *)theEvent
{
    NSString *theArrow = [theEvent charactersIgnoringModifiers];
    unichar keyChar = 0;

    if ([theArrow length] == 0) return;            // reject dead keys

    if ([theArrow length] == 1)
    {
        keyChar = [theArrow characterAtIndex:0];

        if (keyChar == NSDownArrowFunctionKey)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AFCFileCopyBegin" object:self userInfo:nil];
        }
    }
}


@end
