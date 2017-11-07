

#import "NameView.h"


@implementation NameView

@synthesize inputString;


- (id)initWithFrame:(NSRect)frame
{
    NSString *path;
    
    self = [super initWithFrame:frame];

    if (self)
    {
        [self clearBuffer];

        path = @"petchars_c";
        path = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        characterSet = [[NSImage alloc] initWithContentsOfFile:path];

        inputString = nil;
        stringLength = 0;
        isInverseFlag = NO;
    }
    
    return self;
}



- (void)drawRect:(NSRect)dirtyRect
{
    NSUInteger row, col, theGraphicCode;
    NSRect inputRect;
    
    for (NSUInteger i = 0 ; i < stringLength ; ++i)
    {
        // Run along the string the rows of the buffer and draw the appropriate chars on the screen
        
        theGraphicCode = buffer[i];
        
        // Calculate the co-ords of the char image within the larger petchars image 
        
        row = (theGraphicCode / 16);
        col = theGraphicCode - (row * 16);
        
        // If the inverse video flag is set, shift the row value down EXCEPT on a single space clearing
        
        if (isInverseFlag && [inputString compare:@" "] != NSOrderedSame) row = row + 8;

        inputRect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 0)
                         fromRect: inputRect 
                        operation: NSCompositeCopy 
                         fraction: 1.0];
      }
}



- (void)update
{
    stringLength = [inputString length];
    
    if (stringLength > 33) 
    {
        // The input string is greater than 40 characters, so truncate it and add three dots at the end
        
        stringLength = 29;
        buffer[30] = 43;
        buffer[31] = 43;
        buffer[32] = 43;
    }
    
    if (stringLength > 0)
    {
        for (NSUInteger i = 0 ; i < stringLength ; ++i)
        {
            // Run through each character and obtain the Ascii code and put it in the character store
            
            buffer[i] = [inputString characterAtIndex:i];
        }
        
        [self setNeedsDisplay:YES];
    }
}



- (void)clearBuffer
{
    for (NSUInteger i = 0 ; i < 40 ; ++i) buffer[i] = kGraphicSpace;
}



- (void)inverseVideo
{
    isInverseFlag = !isInverseFlag;
}



- (void)dealloc
{
    [characterSet release];
    [inputString release];
    [super dealloc];
}


@end
