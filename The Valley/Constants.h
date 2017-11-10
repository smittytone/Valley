

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


// Valley Graphics

#define    kGraphicSpace           32
#define    kGraphicSpaceAlt        32
#define    kGraphicCharacter       81
#define    kGraphicBorder          214
#define    kGraphicSafeCastle      209
#define    kGraphicPathUp          77
#define    kGraphicPathDown        78
#define    kGraphicWood            216
#define    kGraphicSwamp           102
#define    kGraphicTower           87

// Wood Graphics

#define    kGraphicWoodBorder      96
#define    kGraphicTree            88
#define    kGraphicLake            224
#define    kGraphicCharInLake      209
#define    kGraphicLair            124

// Swamp Graphics

#define    kGraphicSwampBorder     96
#define    kGraphicTuft            104
#define    kGraphicTemple          124

// Tower Graphics

#define    kGraphicTowerBorder     230
#define    kGraphicWall            230
#define    kGraphicStairLeft       189
#define    kGraphicStairRight      189
#define    kGraphicDoor            80
#define    kGraphicTreasure        42

// Player Actions

#define    kActionMove             1
#define    kActionCombat           2
#define    kActionEscape           3
#define    kActionQuit             4
#define    kActionStairs           5
#define    kActionWaitForMonster   6
#define    kActionDead             7
#define    kActionCastSpell        8
#define    kActionPause            9

// Character Types

#define    kCharWizard             1
#define    kCharThinker            2
#define    kCharBarbarian          3
#define    kCharWarrior            4
#define    kCharCleric             5
#define    kCharDolt               6

// Scenario Types

#define    kScenarioValley         1
#define    kScenarioSwamp          2
#define    kScenarioWoods          3
#define    kScenarioTower          4
#define    kScenarioTemple         5
#define    kScenarioLair           6

// Item Types

#define    kAmulet                 0
#define    kAmuletStones           1
#define    kHelm                   2

// Wait for key types

#define    kWaitTypeNone           0
#define    kWaitTypeCombat         1
#define    kWaitTypeSpell          2

// Spells

#define    kSpellSleep             1
#define    kSpellPsilance          2
#define    kSpellCrisp             3

// Combat Stages

#define    kCombatPlayerInitiative 1
#define    kCombatMonsterAttacks   2

// Timings

#define    kScrollMessagesTime     20
