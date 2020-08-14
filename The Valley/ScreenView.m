

// macOS software © Tony Smith 2012-20, based on work
// by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "ScreenView.h"


@implementation ScreenView

@synthesize splashImage;



- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self)
	{
        theView = [[NSImage alloc] initWithSize:NSMakeSize(624, 224)];
        theGraphics = [NSImage imageNamed:@"petchars_a"];
        splashImage = nil;
        splashFlag = NO;
    }
    
	return self;
}



- (void)awakeFromNib
{
    theView = [[NSImage alloc] initWithSize:NSMakeSize(624, 224)];
    theGraphics = [NSImage imageNamed:@"petchars_a"];
    splashImage = nil;
    splashFlag = NO;
}



- (void)drawRect:(NSRect)dirtyRect
{
	if (splashFlag)
    {
        splashFlag = NO;

        if (splashImage != nil)
        {
            [splashImage drawAtPoint: NSMakePoint(0, 0)
                            fromRect: NSZeroRect
                           operation: NSCompositingOperationCopy
                            fraction: 1.0];
        }
    }
    else
    {
        if (screenArray)
        {
            for (NSUInteger y = 0 ; y < 14 ; ++y)
            {
                for (NSUInteger x = 0 ; x < 40 ; ++x)
                {
                    // Get the type of graphic to draw out of the GameController screen array

                    NSUInteger theGraphicCode = screenArray[y * 40 + x];

                    // Calculate the co-ords on the char image from the code

                    NSUInteger row = theGraphicCode / 16;
                    NSUInteger col = theGraphicCode - (row * 16);
                    NSRect rect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);

                    [theGraphics drawAtPoint: NSMakePoint((x * 16), 208 - (y * 16))
                                    fromRect: rect
                                   operation: NSCompositingOperationCopy
                                    fraction: 1.0];
                }
            }
        }
    }
}



- (void)copyScreen:(NSInteger *)arrayAddress
{
	// Get the address of the GameController screen[] array
	
	screenArray = arrayAddress;
    [self drawViewScreen];
}
			


- (void)drawViewScreen
{
	// Tell the view to draw itself in its entirety
	
    self.needsDisplay = YES;
}



- (void)showSplash:(NSImage *)image
{
    splashImage = image;
    splashFlag = YES;
    [self setNeedsDisplayInRect:(NSMakeRect(0, 0, 640 , 224))];
}



#pragma mark - Responder Methods

- (BOOL)acceptsFirstResponder
{
	return NO;
}


@end
