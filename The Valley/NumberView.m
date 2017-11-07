
#import "NumberView.h"

@implementation NumberView

@synthesize inputValue;


- (id)initWithFrame:(NSRect)frame
{
    NSString *path;
    
    self = [super initWithFrame:frame];

    if (self)
    {
        [self clearBuffer];

        path = @"petchars_a";
        path = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        characterSet = [[NSImage alloc] initWithContentsOfFile:path];

        inputValue = 0;
        isInverseFlag = NO;
    }
    
    return self;
}



- (void)drawRect:(NSRect)dirtyRect
{
    NSUInteger theGraphicCode, row, col;
    NSRect inputRect;
    
    for (NSUInteger i = 0 ; i < digits ; ++i)
    {
        theGraphicCode = buffer[i];
        
        // Calculate the co-ords on the char image from the code
        
        row = (theGraphicCode / 16);
        col = theGraphicCode - (row * 16);
        
        // If the inverse video flag is set, shift the row value down EXCEPT on a single space clearing
        
        if (isInverseFlag) row = row + 8;
        
        inputRect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 0) 
                         fromRect: inputRect 
                        operation: NSCompositeCopy 
                         fraction: 1.0];
    }
}



- (void)clearBuffer
{
    // Zeroes the data
    
    for (NSUInteger i = 0 ; i < 10 ; ++i) buffer[i] = kGraphicSpace;
}



- (void)inverseVideo
{
    isInverseFlag = !isInverseFlag;
}



- (void)update
{
    NSString *numberString;
    
    [self clearBuffer];
    
    /* 
     if (inputValue < 10) digits = 1;
    if ((inputValue > 9) && (inputValue < 100)) digits = 2;
    if ((inputValue > 99) && (inputValue < 1000)) digits = 3;
    if ((inputValue > 999) && (inputValue < 10000)) digits = 4;
    if ((inputValue > 9999) && (inputValue < 100000)) digits = 5;
    if ((inputValue > 99999) && (inputValue < 1000000)) digits = 6;
    */
    
    numberString = [NSString stringWithFormat:@"%ld", inputValue];
    digits = [numberString length];
    
    for (NSUInteger i = 0 ; i < digits ; ++i) buffer[i] = [numberString characterAtIndex:i];
    
    [self setNeedsDisplay:YES];
}


@end
