

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import <Cocoa/Cocoa.h>
#import "Constants.h"
#import "MessageView.h"
#import "NameView.h"
#import "NumberView.h"
#import "ScreenView.h"
#import "Character.h"
#import "ValleyWindow.h"
#import "ValleyButton.h"
#import "ValleyStoryWindow.h"



@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
    // Game Arrays

    NSInteger valleyPath[78], places[6], screen[561];
    NSInteger towerFloor[9], roomWidth[4], roomDepth[9], towerData[34];
    NSInteger monsterStrength[19], monsterPsi[19];
    NSString *monsterName[19], *monsterCode[19], *charLevels[29];

    NSString *monsterKind, *scenarioMonsterTypes, *savedfilePath;

    NSTimer *fightTimer;

    NSString *newProf;
    NSInteger newProfession, newStamina, newComStrength, newPsiStrength;
    float newCombatGain, newPsiGain;

    NSInteger currentScenario, floor, stepCounter, wallDepth, dataPointer;
    NSInteger positionBeforeLair, valleyPos, nextPos, currentPos;
    NSInteger floorPattern, pokeCharacter, scenarioTurnTime;
    NSInteger nextPosContents, savedContents, tempFloor;
    NSInteger heartbeatCount, targetTime, delayTargetTime;
    NSInteger gVariable;
    NSInteger experienceGain;
    NSInteger monsterCombatStrength, monsterCombatPsi, monsterStamina, spellCast, timeFactor;

    BOOL isInCombat, monsterWasHitHard, playerHasInitiative, isMonstersTurn, isPlayersTurn, playerCastSpell;
    BOOL needToSave, isGameInProgress, stairsFlag, loadFlag;

    Character *player;

    // Main GameWindow

    IBOutlet NSWindow *mainWindow;
    IBOutlet ScreenView *theScreen;
    IBOutlet MessageView *theMessage;
    IBOutlet NSImageView *theBackground;

    IBOutlet NameView *playerNameView;
    IBOutlet NumberView *turnCountView;
    IBOutlet NumberView *experienceView;
    IBOutlet NumberView *treasureView;
    IBOutlet NumberView *staminaView;
    IBOutlet NumberView *psiView;
    IBOutlet NumberView *playerStrengthView;

    IBOutlet NameView *monsterNameView;
    IBOutlet NumberView *monsterStrengthView;
    IBOutlet NSImageView *monsterGraphic;

    IBOutlet ValleyButton *button1;
    IBOutlet ValleyButton *button2;
    IBOutlet ValleyButton *button3;
    IBOutlet ValleyButton *button4;
    IBOutlet ValleyButton *button5;
    IBOutlet ValleyButton *button6;
    IBOutlet ValleyButton *button7;
    IBOutlet ValleyButton *button8;
    IBOutlet ValleyButton *button9;

    IBOutlet ValleyButton *cButtonH;
    IBOutlet ValleyButton *cButtonB;
    IBOutlet ValleyButton *cButtonL;
    IBOutlet ValleyButton *cButtonS;

    IBOutlet ValleyButton *oButtonA;
    IBOutlet ValleyButton *oButtonR;
    IBOutlet ValleyButton *oButtonE;

    // New Player Sheet

    IBOutlet NSWindow *newPlayerWindow;
    IBOutlet NSTextField *playerNameReadout;
    IBOutlet NSImageView *playerPicView;
    IBOutlet NSButton *bWizard;
    IBOutlet NSButton *bThinker;
    IBOutlet NSButton *bBarbarian;
    IBOutlet NSButton *bWarrior;
    IBOutlet NSButton *bCleric;

    // About Sheet

    IBOutlet NSWindow *aboutSheet;

    // Preferences Sheet

    IBOutlet NSWindow *prefsSheet;
    IBOutlet NSButton *prefsAsciiCheckbox;
    IBOutlet NSButton *prefsSaveCheckbox;
    IBOutlet NSButton *prefsSoundCheckbox;

    // Story Window

    IBOutlet ValleyStoryWindow *storySheet;
    IBOutlet NSView *storyView;
    IBOutlet NSTextView *storyTextView;

    // Menu outlets

    IBOutlet NSMenuItem *menuItemSave;
}


// Timing Methods

- (void)heartbeat;

// Game Setup

- (void)initGameVariables;

// Graphics Methods

- (void)clearScreen;
- (void)drawScreen;
- (void)print:(NSString *)inputString at:(NSInteger)location;

// Character Methods

- (void)updateStats;
- (void)death;
- (void)rating;
- (void)ratingExtra;
- (IBAction)ego:(id)sender;

// Movement Methods

- (IBAction)move:(id)sender;

// Search methods

- (void)find;
- (void)postFind;
- (void)specialFind;
- (void)amuletStoneFits;
- (void)amuletStoneDoesntFit;
- (void)amuletEmpty;

// Monster and Combat Methods

- (void)announceMonster;
- (void)chooseMonster;
- (void)launchMonsterAttack;
- (void)monsterAttacks;
- (void)monsterStrikes;
- (void)monsterDoesDamage;
- (void)monsterPsiAttack;
- (void)monsterPsiStrike;
- (void)monsterPsiDamage;
- (void)managePlayerInitiative;
- (IBAction)attack:(id)sender;
- (IBAction)retreat:(id)sender;
- (void)launchPlayerAttack;
- (void)playerFight;
- (void)timeIsUp:(NSTimer*)theTimer;
- (IBAction)strike:(id)sender;
- (void)playerDoesDamage;
- (IBAction)castSpell:(id)sender;
- (void)playerSpell:(NSInteger)keyValue;
- (void)spellOutcome;
- (NSInteger)magic:(NSInteger)keyValue;

// Scenario Control and Setup Methods

- (void)scenarioControl;
- (void)scenarioValley;
- (void)scenarioWoods;
- (void)scenarioTemple;
- (void)scenarioTower;
- (void)scenarioCastles;

// Menu Methods

- (IBAction)newChar:(id)sender;
- (void)showNewPlayerSheet;
- (IBAction)saveCharSheet:(id)sender;
- (IBAction)cancelCharSheet:(id)sender;
- (IBAction)setProfession:(id)sender;
- (IBAction)showAboutSheet:(id)sender;
- (IBAction)closeAboutSheet:(id)sender;

//  Save and Load Methods

- (IBAction)saveDocument:(id)sender;
- (void)doSave;
- (IBAction)saveDocumentAs:(id)sender;
- (IBAction)openDocument:(id)sender;
- (void)showOpenDialog;
- (void)openFileHandler:(NSString *)path;
- (NSString *)setProfString:(NSInteger)index;

// Prefs Methods

- (IBAction)prefsPanel:(id)sender;
- (IBAction)prefsSheetCancel:(id)sender;
- (IBAction)prefsSheetSave:(id)sender;

// Story Methods

- (IBAction)showStory:(id)sender;
- (IBAction)closeStory:(id)sender;

// Utility Methods

- (float)random;
- (void)setKeysAndClicks:(BOOL)state;



@end

