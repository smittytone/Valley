
#import <Cocoa/Cocoa.h>
#import "Character.h"
#import "Constants.h"


@interface CharWindow : NSWindowController
{
	NSWindow *charWindow;
	Character *theChar;
	IBOutlet id theView;
	IBOutlet id nameField;
}


- (IBAction)chooseWizard:(id)sender;
- (IBAction)chooseThinker:(id)sender;
- (IBAction)chooseWarrior:(id)sender;
- (IBAction)chooseBarbarian:(id)sender;
- (IBAction)chooseCleric:(id)sender;
- (IBAction)okButton:(id)sender;


@end
