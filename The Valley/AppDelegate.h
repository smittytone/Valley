

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

    NSString *monsterKind, *vg, *scenarioMonsterTypes, *charName;
    NSString *savedfilePath, *charProf;

    NSTimer *fightTimer;

    NSInteger currentScenario, floor, stepCounter, wallDepth, dataPointer;
    NSInteger positionBeforeLair, valleyPos, nextPos, currentPos;
    NSInteger floorPattern, pokeCharacter, scenarioTurnTime;
    NSInteger nextPosContents, savedContents, tempFloor;
    NSInteger heartbeatCount, targetTime, delayTargetTime;
    NSInteger gVariable;
    NSInteger charCombatStrength, charPsiStrength;
    NSInteger charStamina, treasure, experience, timerCount, rating;
    NSInteger experienceGain, charProfession;
    NSInteger monsterCombatStrength, monsterCombatPsi, monsterStamina, waitKind, spellCast;

    NSUInteger turnCount, timeFactor;

    float charPsiGain, charCombatGain;

    BOOL generalDelayFlag, gameInProgress, playerCombatFlag, monsterHitFlag, monsterTurn;
    BOOL waitingToStrikeFlag, castSpellFlag, surpriseFlag, stairsFlag, loadFlag, needSaveFlag;

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

    IBOutlet id button1;
    IBOutlet id button2;
    IBOutlet id button3;
    IBOutlet id button4;
    IBOutlet id button5;
    IBOutlet id button6;
    IBOutlet id button7;
    IBOutlet id button8;
    IBOutlet id button9;

    IBOutlet id cButtonH;
    IBOutlet id cButtonB;
    IBOutlet id cButtonL;
    IBOutlet id cButtonS;

    IBOutlet id bWizard;
    IBOutlet id bThinker;
    IBOutlet id bBarbarian;
    IBOutlet id bWarrior;
    IBOutlet id bCleric;

    IBOutlet id charNameReadout;

    IBOutlet ScreenView *theScreen;
    //IBOutlet AboutBox *aboutBox;
    IBOutlet MessageView *theMessage;
    IBOutlet NSWindow *theCharWindow;

    IBOutlet NSWindow *window;
}


- (void)initGameVariables;
- (float)random;

- (IBAction)closeCharWindow:(id)sender;
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
- (void)monsterFight;
- (void)monsterStrikes;
- (void)monsterPsiAttack;
- (void)monsterPsiStrike;
- (void)launchMonsterAttack;

- (IBAction)newChar:(id)sender;
- (IBAction)aboutMenu:(id)sender;
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

