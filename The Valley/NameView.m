

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "NameView.h"


@implementation NameView

@synthesize inputString, inverse;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self clearBuffer];

        characterSet = [NSImage imageNamed:@"petchars_c"];
        inverse = NO;
    }
    
    return self;
}



- (void)awakeFromNib
{
    characterSet = [NSImage imageNamed:@"petchars_c"];
    inverse = NO;
}


- (void)drawRect:(NSRect)dirtyRect
{
    for (NSUInteger i = 0 ; i < inputString.length ; ++i)
    {
        // Calculate the co-ords of the char image within the larger petchars image
        
        NSUInteger theGraphicCode = buffer[i];
        NSUInteger row = theGraphicCode / 16;
        NSUInteger col = theGraphicCode - (row * 16);

        // If the inverse video flag is set, shift the row value down EXCEPT on a single space clearing
        
        if (inverse && [inputString compare:@" "] != NSOrderedSame) row = row + 8;

        NSRect rect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);
        
        [characterSet drawAtPoint: NSMakePoint((i * 16), 0)
                         fromRect: rect
                        operation: NSCompositingOperationCopy 
                         fraction: 1.0];
      }
}



- (void)update:(NSString *)value
{
    [self clearBuffer];

    inputString = value;
    NSInteger stringLength = inputString.length;
    
    if (stringLength > 33) 
    {
        // The input string is greater than 33 characters, so truncate it and add three dots at the end
        
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


@end
