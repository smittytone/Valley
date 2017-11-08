

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


@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
    // Game Arrays

    NSInteger valleyPath[78], places[6], screen[561];
    NSInteger towerFloor[9], n[9], roomWidth[4], roomDepth[9], items[4];
    NSInteger monsterStrength[19], monsterPsi[19], towerData[34];

    NSString *monsterName[19], *monsterCode[19], *charLevels[29];

    NSString *monsterKind, *vg, *scenarioMonsterTypes, *savedfilePath;

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
    NSInteger monsterCombatStrength, monsterCombatPsi, monsterStamina, waitKind, spellCast;
    NSUInteger turnCount, timeFactor;

    BOOL isInCombat, monsterWasHitHard, playerHasInitiative, isMonstersTurn, isPlayersTurn, playerCastSpell;
    BOOL needToSave, isGameInProgress, generalDelayFlag, stairsFlag, loadFlag;

    Character *player;


    // Preferences Sheet

    IBOutlet id prefsSheet;
    IBOutlet id prefsAsciiCheckbox;
    IBOutlet id prefsSaveCheckbox;
    IBOutlet id prefsSoundCheckbox;

    // Menu outlets

    IBOutlet id menuItemSave;

    // IBOutlet id messageField;

    // Outlets on GameWindow

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

    IBOutlet NSButton *button1;
    IBOutlet NSButton *button2;
    IBOutlet NSButton *button3;
    IBOutlet NSButton *button4;
    IBOutlet NSButton *button5;
    IBOutlet NSButton *button6;
    IBOutlet NSButton *button7;
    IBOutlet NSButton *button8;
    IBOutlet NSButton *button9;

    IBOutlet NSButton *cButtonH;
    IBOutlet NSButton *cButtonB;
    IBOutlet NSButton *cButtonL;
    IBOutlet NSButton *cButtonS;

    IBOutlet ScreenView *theScreen;
    IBOutlet MessageView *theMessage;

    IBOutlet NSWindow *newPlayerWindow;
    IBOutlet NSTextField *playerNameReadout;
    IBOutlet NSButton *bWizard;
    IBOutlet NSButton *bThinker;
    IBOutlet NSButton *bBarbarian;
    IBOutlet NSButton *bWarrior;
    IBOutlet NSButton *bCleric;

    IBOutlet NSWindow *aboutSheet;

    IBOutlet NSWindow *mainWindow;
}


- (void)initGameVariables;
- (float)random;

- (IBAction)saveCharSheet:(id)sender;
- (IBAction)cancelCharSheet:(id)sender;
- (IBAction)setProfession:(id)sender;

- (void)clearScreen;
- (void)drawScreen;
- (void)updateStats;
- (void)clearText;

- (IBAction)move:(id)sender;
- (IBAction)ego:(id)sender;
- (IBAction)attack:(id)sender;
- (IBAction)retreat:(id)sender;
- (void)rating;
- (void)ratingExtra;
- (void)death;

- (void)scenarioControl;
- (void)scenarioValley;
- (void)scenarioWoods;
- (void)scenarioTemple;
- (void)scenarioTower;
- (void)scenarioCastles;

- (void)find;
- (void)postFind;
- (void)specialFind;
- (void)amuletStoneFits;
- (void)amuletStoneDoesntFit;
- (void)amuletEmpty;
// - (void)stairs;

- (void)announceMonster;
- (void)chooseMonster;
- (void)playerFight;
- (void)playerDoesDamage;
- (void)managePlayerInitiative;
- (void)launchPlayerAttack;

- (IBAction)strike:(id)sender;
- (IBAction)castSpell:(id)sender;
- (void)playerSpell:(NSInteger)keyValue;
- (NSInteger)magic:(NSInteger)keyValue;
- (void)spellOutcome;

//- (void)startMonsterFight;
- (void)launchMonsterAttack;
- (void)monsterAttacks;
- (void)monsterStrikes;
- (void)monsterPsiAttack;
- (void)monsterPsiStrike;


- (IBAction)newChar:(id)sender;
- (IBAction)showAboutSheet:(id)sender;
- (IBAction)closeAboutSheet:(id)sender;
- (IBAction)toggleFullScreenMenu:(id)sender;

- (IBAction)saveDocument:(id)sender;
- (IBAction)saveDocumentAs:(id)sender;
- (void)savePanelDidEnd:(NSURL *)fileURL;
- (IBAction)openDocument:(id)sender;
- (void)openFileHandler:(NSString *)path;
- (NSString *)setProfString:(NSInteger)index;

- (void)heartbeat;
- (void)timeIsUp:(NSTimer*)theTimer;
- (void)delayIsUp:(NSTimer*)theTimer;

- (void)print:(NSString *)inputString at:(NSInteger)location;
- (void)dummy;

@end

