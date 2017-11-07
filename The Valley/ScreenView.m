
#import "ScreenView.h"


@implementation ScreenView



- (id)initWithFrame:(NSRect)frame
{
    NSString *path;
	
	self = [super initWithFrame:frame];
	
    if (self)
	{
        theView = [[NSImage alloc] initWithSize:NSMakeSize(624, 224)];
		path = @"petchars_a";
		path = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
		theGraphics = [[NSImage alloc] initWithContentsOfFile:path];
        splashFlag = NO;
    }
    
	return self;
}



- (void)drawRect:(NSRect)dirtyRect
{
	NSUInteger x, y, row, col, theGraphicCode;
	NSRect inputRect;
	
	if (!splashFlag && screenArray != 0)
    {
        for (y = 0 ; y < 14 ; ++y)
        {
            for (x = 0 ; x < 40 ; ++x)
            {
                // Get the type of graphic to draw out of the GameController screen array

                theGraphicCode = screenArray[y * 40 + x];

                // Calculate the co-ords on the char image from the code

                row = theGraphicCode / 16;
                col = theGraphicCode - (row * 16);

                inputRect = NSMakeRect(col * 16, 240 - (row * 16), 16 , 16);

                [theGraphics drawAtPoint: NSMakePoint((x * 16), 208 - (y * 16))
                                fromRect: inputRect
                               operation: NSCompositeCopy
                                fraction: 1.0];
            }
        }
    }
    else
    {
        splashFlag = NO;
        
        [theSplashImage drawAtPoint: NSMakePoint(0, 0)
                           fromRect: dirtyRect
                          operation: NSCompositeCopy
                           fraction: 1.0];
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
	
	[self setNeedsDisplayInRect:(NSMakeRect(0, 0, 640 , 224))];
}



#pragma mark Responder Methods

- (BOOL)acceptsFirstResponder
{
	return NO;
}


- (BOOL)resignFirstResponder
{
	return NO;
}


- (BOOL)becomeFirstResponder
{
	return YES;
}


- (void)keyDown:(NSEvent *)event
{
	[self interpretKeyEvents:[NSArray arrayWithObject:event]];
}


- (void)insertText:(NSString *)input
{
	// This is where typed text will be dealt with. We send post a
	// 'ValleyKeyClick' notification with the typed key as its packaged
	// object to be dealt with by the main program code.
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ValleyKeyClick" object:input];
}


- (void)splash:(NSImage *)theImage
{
    [theImage retain];
    theSplashImage = theImage;
    splashFlag = YES;
    [self setNeedsDisplayInRect:(NSMakeRect(0, 0, 640 , 224))];
}



#pragma mark Misc Methods

- (void)dealloc
{
	if (theSplashImage) [theSplashImage release];
    [theView release];
	[theGraphics release];
	[super dealloc];
}


@end
