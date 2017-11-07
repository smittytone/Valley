
#import "CharWindow.h"


@implementation CharWindow



- (id)init
{
	// Load window data in from nib file: "CharWindow[.xib]"
	
	self = [super initWithWindowNibName:@"CharWindow"];
	
	if (self)
	{
		theChar = [[Character alloc] init];
		theChar.pcharProf = 0;
	}
	
	return self;
}



- (void)windowDidLoad
{
	[nameField setStringValue:@"Waldo"];
	[[self window] center];
}



- (IBAction)chooseWizard:(id)sender
{
	theChar.pcharProf = kCharWizard;
}
	


- (IBAction)chooseThinker:(id)sender
{
	theChar.pcharProf = kCharThinker;
}



- (IBAction)chooseWarrior:(id)sender
{
	theChar.pcharProf = kCharWarrior;
}



- (IBAction)chooseBarbarian:(id)sender
{
	theChar.pcharProf = kCharBarbarian;
}



- (IBAction)chooseCleric:(id)sender
{
	theChar.pcharProf = kCharCleric;
}



- (IBAction)okButton:(id)sender
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	if (theChar.pcharProf == 0) theChar.pcharProf = kCharDolt;
	
	theChar.pcharName = [nameField stringValue];
	
	if ([theChar.pcharName length] == 0) theChar.pcharName = @"Wonko";
	
	[nc postNotificationName:@"ValleyCharChoice" object:theChar];

	[[self window] close];
}



- (void)dealloc
{
	[theChar release];
	[super dealloc];
}


@end
