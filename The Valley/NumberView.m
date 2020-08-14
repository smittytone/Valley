

// macOS software © Tony Smith 2012-20, based on work
// by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "NumberView.h"

@implementation NumberView

@synthesize inputValue, inverse;



- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self clearBuffer];

        characterSet = [NSImage imageNamed:@"petchars_a"];
        inverse = NO;
    }
    
    return self;
}



- (void)awakeFromNib
{
    numberString = @"000000";
    [self clearBuffer];

    characterSet = [NSImage imageNamed:@"petchars_a"];
    inverse = NO;
}



- (void)drawRect:(NSRect)dirtyRect
{
    for (NSUInteger i = 0 ; i < numberString.length ; ++i)
    {
        // Calculate the co-ords on the char image from the code
        
        NSUInteger theGraphicCode = buffer[i];
        NSUInteger row = theGraphicCode / 16;
        NSUInteger col = theGraphicCode - (row * 16);
        
        // If the inverse video flag is set, shift the row value down EXCEPT on a single space clearing
        
        if (inverse) row = row + 8;
        
        NSRect rect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 0) 
                         fromRect: rect
                        operation: NSCompositingOperationCopy 
                         fraction: 1.0];
    }
}



- (void)clearBuffer
{
    // Zeroes the data
    
    for (NSUInteger i = 0 ; i < 10 ; ++i) buffer[i] = kGraphicSpace;
}



- (void)update:(NSInteger)value
{
    [self clearBuffer];
    
    inputValue = value;
    numberString = [NSString stringWithFormat:@"%ld", inputValue];
    if (numberString.length > 10) numberString = [numberString substringToIndex:10];
    for (NSUInteger i = 0 ; i < numberString.length ; ++i) buffer[i] = [numberString characterAtIndex:i];
    
    [self setNeedsDisplay:YES];
}


@end
