

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSImage *theImage;
    NSString *path;

    // Set up Key and Value arrays as template for Defaults

    NSArray *keyArray = [NSArray arrayWithObjects:@"le_Valley_Ascii_Graphics",
                         @"le_Valley_Save_in_Castles", @"le_Valley_Do_Sounds",
                         nil];

    NSArray *valueArray = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                            [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                            nil];

    // Drop the arrays into the Defauts

    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    // Initialise game variables

    [self initGameVariables];
    [monstersName inverseVideo];
    [monsterStrengthView inverseVideo];

    // Do the initial splash Screen

    [self clearScreen];
    [theScreen drawViewScreen];

    theImage = [NSImage imageNamed:@"valley_logo_digital.png"];
    [theScreen splash:theImage];

    // Give the main window the option to go full-screen

    [_window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];

    savedfilePath = nil;
    needSaveFlag = NO;

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self
           selector:@selector(dummy)
               name:@"AFCFileCopyBegin"
             object:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApp
{
    return YES;
}



#pragma mark - Full Screen Methods


- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
    [_window setStyleMask:NSBorderlessWindowMask];
}



- (void)windowWillExitFullScreen:(NSNotification *)notification
{
    [_window setStyleMask:(NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask)];
    [_window setTitle:@"The Valley"];
}



#pragma mark - Timer Methods

- (void)heartbeat
{
    // This method is called every second of game/real time

    // Bail if there's no game in play

    if (!gameInProgress) return;

    ++heartbeatCount;

    // Are we timing a moment of surprise or a strike opportunity?

    if (surpriseFlag || waitingToStrikeFlag)
    {
        if (heartbeatCount <= targetTime)
        {
            // Still time to wait, so return

            return;
        }
        else
        {
            // Time's up, so play out the outcome

            targetTime = 0;
            [self timeIsUp:nil];
            return;
        }
    }

    if (castSpellFlag)
    {
        if (heartbeatCount <= targetTime)
        {
            return;
        }
        else
        {
            targetTime = 0;
            //[self spellOutcome];
            return;
        }
    }

    // No need to go further if the player is in combat

    if (playerCombatFlag) return;

    // Process a general delay

    if (generalDelayFlag)
    {
        if (heartbeatCount <= delayTargetTime)
        {
            return;
        }
        else
        {
            delayTargetTime = 0;
            [self delayIsUp:nil];
            return;
        }
    }

    // Every x seconds, scroll the message field up a line
    // Leave it till last so its doesn't happen in specific waiting periods

    if (heartbeatCount % kScrollMessagesTime == 0)
    {
        theMessage.inputString = @"";
        [theMessage update];
    }
}



- (void)delayIsUp:(NSTimer*)theTimer
{
    // THIS DOES NOTHING, BUT NEED TO FIGURE OUT HOW TO DELAY PROGRAM
}



#pragma mark - Game Setup

- (void)initGameVariables
{
    // Initialise the core game variables with default values

    for (NSUInteger i = 0 ; i < 78 ; ++i) valleyPath[0] = -1;
    for (NSInteger i = 0 ; i < 7 ; ++i) places[i] = -1;

    timeFactor = 3;
    charCombatGain = 0.5;
    charPsiGain = 0.25;
    dataPointer = 1;
    spellCast = 0;
    targetTime = 0;
    delayTargetTime = 0;

    // Initialise Monster Arrays

    monsterName[0] = @"Wolfen";
    monsterName[1] = @"Hobgoblin";
    monsterName[2] = @"Orc";
    monsterName[3] = @"Fire Imp";
    monsterName[4] = @"Rock Troll";
    monsterName[5] = @"Harpy";
    monsterName[6] = @"Ogre";
    monsterName[7] = @"Barrow Wight";
    monsterName[8] = @"Centaur";
    monsterName[9] = @"Fire Giant";
    monsterName[10] = @"Thunder Lizard";
    monsterName[11] = @"Minotaur";
    monsterName[12] = @"Wraith";
    monsterName[13] = @"Wyvern";
    monsterName[14] = @"Dragon";
    monsterName[15] = @"Ring Wraith";
    monsterName[16] = @"Balrog";
    monsterName[17] = @"Water Imp";
    monsterName[18] = @"Kraken";

    monsterCode[0] = @"A";
    monsterCode[1] = @"A";
    monsterCode[2] = @"A";
    monsterCode[3] = @"E";
    monsterCode[4] = @"G";
    monsterCode[5] = @"E";
    monsterCode[6] = @"A";
    monsterCode[7] = @"B";
    monsterCode[8] = @"H";
    monsterCode[9] = @"E";
    monsterCode[10] = @"V";
    monsterCode[11] = @"C";
    monsterCode[12] = @"C";
    monsterCode[13] = @"F";
    monsterCode[14] = @"B";
    monsterCode[15] = @"C";
    monsterCode[16] = @"A";
    monsterCode[17] = @"L";
    monsterCode[18] = @"L";

    monsterPsi[0] = 0;
    monsterPsi[1] = 0;
    monsterPsi[2] = 0;
    monsterPsi[3] = 3;
    monsterPsi[4] = 0;
    monsterPsi[5] = 12;
    monsterPsi[6] = 0;
    monsterPsi[7] = 25;
    monsterPsi[8] = 14;
    monsterPsi[9] = 20;
    monsterPsi[10] = 0;
    monsterPsi[11] = 25;
    monsterPsi[12] = 30;
    monsterPsi[13] = 12;
    monsterPsi[14] = 20;
    monsterPsi[15] = 45;
    monsterPsi[16] = 50;
    monsterPsi[17] = 15;
    monsterPsi[18] = 0;

    monsterStrength[0] = 9;
    monsterStrength[1] = 9;
    monsterStrength[2] = 9;
    monsterStrength[3] = 7;
    monsterStrength[4] = 19;
    monsterStrength[5] = 10;
    monsterStrength[6] = 23;
    monsterStrength[7] = 0;
    monsterStrength[8] = 18;
    monsterStrength[9] = 26;
    monsterStrength[10] = 50;
    monsterStrength[11] = 35;
    monsterStrength[12] = 0;
    monsterStrength[13] = 36;
    monsterStrength[14] = 50;
    monsterStrength[15] = 0;
    monsterStrength[16] = 50;
    monsterStrength[17] = 15;
    monsterStrength[18] = 50;

    // Tower wall data

    towerData[1] = 4;
    towerData[2] = 7;
    towerData[3] = 3;
    towerData[4] = 6;
    towerData[5] = 4;
    towerData[6] = 4;
    towerData[7] = 6;
    towerData[8] = 5;
    towerData[9] = 3;
    towerData[10] = 6;
    towerData[11] = 0;
    towerData[12] = 3;
    towerData[13] = 8;
    towerData[14] = 4;
    towerData[15] = 3;
    towerData[16] = 5;
    towerData[17] = 5;
    towerData[18] = 3;
    towerData[19] = 8;
    towerData[20] = 3;
    towerData[21] = 4;
    towerData[22] = 5;
    towerData[23] = 0;
    towerData[24] = 6;
    towerData[25] = 3;
    towerData[26] = 6;
    towerData[27] = 4;
    towerData[29] = 4;
    towerData[30] = 7;
    towerData[31] = 4;
    towerData[32] = 100;

    // Character Ratings

    charLevels[1] = @"Monster Food";
    charLevels[2] = @"Peasant";
    charLevels[3] = @"Cadet";
    charLevels[4] = @"Cannon Fodder";
    charLevels[5] = @"Path Walker";
    charLevels[6] = @"Novice";
    charLevels[7] = @"Survivor";
    charLevels[8] = @"Adventurer";
    charLevels[9] = @"Assassin";
    charLevels[10] = @"Apprentice Hero";
    charLevels[11] = @"Giant Killer";
    charLevels[12] = @"Hero";
    charLevels[13] = @"Master of the Sword";
    charLevels[14] = @"Champion";
    charLevels[15] = @"Necromancer";
    charLevels[16] = @"Loremaster";
    charLevels[17] = @"Paladin";
    charLevels[18] = @"Superhero";
    charLevels[19] = @"Dragon Slayer";
    charLevels[20] = @"Knight of the Valley";
    charLevels[21] = @"Master of Combat";
    charLevels[22] = @"Dominator";
    charLevels[23] = @"Prince of the Valley";
    charLevels[24] = @"Guardian";
    charLevels[25] = @"War Lord";
    charLevels[26] = @"Demon Killer";
    charLevels[27] = @"Lord of the Valley";
    charLevels[28] = @"Master of Destiny";

    gameInProgress = NO;
    playerCombatFlag = NO;
    castSpellFlag = NO;
    monsterTurn = NO;
}



#pragma mark Graphics Methods

- (void)clearScreen
{
    // Clear the screen by filling the buffer array with spaces

    for (NSUInteger i = 0 ; i < 561 ; ++i) screen[i] = kGraphicSpace;
    [self drawScreen];
}



- (void)drawScreen
{
    // Tell the screen view to update by sending the address of the screen array
    // (as screen is a numeric array) to the instance of the screen view controller

    [theScreen copyScreen:&screen[0]];
    [theScreen drawViewScreen];
}



- (void)clearText
{
    [theMessage clearBuffer];
}



#pragma mark - Character Methods


- (void)updateStats
{
    // Enforce player stats maxima

    if (player.stamina > (125 - (charCombatGain * 12.5))) player.stamina = 125 - (charCombatGain * 12.5);
    if (player.comStrength > 77 - 2 * pow(charCombatGain, 2)) player.comStrength = 77 - 2 * pow(charCombatGain, 2);
    if (player.psiStrength < 7 ) player.psiStrength = 7;
    if (player.psiStrength > (42 * pow((charPsiGain + 1), log(pow(charPsiGain, 3.7)))) + 75) player.psiStrength = (42 * pow((charPsiGain + 1), log(pow(charPsiGain, 3.7)))) + 75;

    // Update Stats

    experienceView.inputValue = player.experience;
    [experienceView update];

    treasureView.inputValue = player.treasure;
    [treasureView update];

    turnCountView.inputValue = player.turns;
    [turnCountView update];

    staminaView.inputValue = player.stamina;
    [staminaView update];

    psiView.inputValue = player.psiStrength;
    [psiView update];

    playerStrengthView.inputValue = player.comStrength;
    [playerStrengthView update];

    if (playerCombatFlag)
    {
        // There's a fight going on, so display the Monster details...

        monsterStrengthView.inputValue = monsterCombatStrength == 0 ? monsterCombatPsi : monsterCombatStrength;
        [monsterStrengthView update];
        monsterGraphic.hidden = NO;
    }
    else
    {
        // There's no fight, so hide all the the monster details

        monsterGraphic.hidden = YES;
        monsterStrengthView.hidden = YES;
        monsterNameView.hidden = YES;
    }
}



- (void)death
{
    if (player.amuletStones < 6)
    {
        // Player doesn't have the Amulet of Alarian, so has no protection from death

        [self clearScreen];
        [self clearText];

        [self print:@"Oh, what a frail shell" at:89];
        [self print:@"is this that we call man?" at:126];

        heartbeatCount = 0;
        player.stamina = 0;
        player.psiStrength = 0;
        player.comStrength = 0;
        playerCombatFlag = NO;
        gameInProgress = NO;

        [self updateStats];
    }
    else
    {
        // Player has the amulet and six stones, so is reincarnated

        theMessage.inputString = @"Alarian's Amulet protects thy soul...";
        [theMessage update];
        theMessage.inputString = @"Live again!";
        [theMessage update];

        heartbeatCount = 0;

        player.treasure = 0;
        player.comStrength = 30;
        player.stamina = 150;
        player.psiStrength = 30;
        player.amulet = 0;
        player.amuletStones = 0;

        // Put the reincarnated player in a Safe Castle

        player.cPos = valleyPath[0];
        nextPos = player.cPos;
        currentScenario = kScenarioValley;

        [self updateStats];
        [self scenarioValley];
    }
}



- (void)rating
{
    // Calculate the player's rating

    float floatcalc = (0.067 * sqrt(player.experience + (player.treasure / 3))) + log(player.experience/(pow((player.turns + 1), 1.5)));
    player.rating = (NSInteger)floatcalc;

    if (player.rating > 28) player.rating = 28;
    if (player.rating < 1) player.rating = 1;

    [theMessage clearBuffer];

    if (player.helm == 1)
    {
        theMessage.inputString = @"You have the Helm of Evanna... ";
        [theMessage update];
    }

    if (player.amulet == 1)
    {
        theMessage.inputString = @"You have the Amulet of Alarion...";
        [theMessage update];

        if (player.amuletStones == 0)
        {
            theMessage.inputString = @"...but no Amulet Stones";
        }
        else
        {
            theMessage.inputString = [NSString stringWithFormat:@"...and %ld Amulet Stones", items[1]];
        }

        [theMessage update];

        fightTimer = [NSTimer timerWithTimeInterval:2
                                             target:self
                                           selector:@selector(ratingExtra)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];
        return;
    }

    [self ratingExtra];
}



- (void)ratingExtra
{
    theMessage.inputString = [NSString stringWithFormat:@"Your rating be %ld", player.rating];
    [theMessage update];

    theMessage.inputString = [NSString stringWithFormat:@"Your level is %@", charLevels[player.rating]];
    [theMessage update];
}



- (IBAction)ego:(id)sender
{
    // Player is stroking his ego by checking on his rating
    // Can't do this while fighting

    if (playerCombatFlag)
    {
        if (surpriseFlag)
        {
            // Pressing E causes player to fumble the srike, so give the monster the initiative

            surpriseFlag = NO;
            monsterTurn = YES;

            [self monsterFight];
        }

        return;
    }

    [self rating];

    // There's a cost to this

    charStamina = charStamina - 10;
    needSaveFlag = YES;
}



- (IBAction)attack:(id)sender
{
    if (!playerCombatFlag) return;

    // Only worry about this routine if we're checking for surprise results

    if (surpriseFlag)
    {
        // Give the player the initiative

        surpriseFlag = NO;
        monsterTurn = NO;
        [self playerFight];
    }
}



- (IBAction)retreat:(id)sender
{
    if (!playerCombatFlag) return;

    // Only worry about this routine if we're checking for surprise results

    if (surpriseFlag)
    {
        surpriseFlag = NO;
        monsterTurn = NO;
        playerCombatFlag = NO;
        theMessage.inputString = @"Knavish coward!";
        [theMessage update];

        [button9 setAcceptsTouchEvents:YES];
        [button8 setAcceptsTouchEvents:YES];
        [button7 setAcceptsTouchEvents:YES];
        [button6 setAcceptsTouchEvents:YES];
        [button5 setAcceptsTouchEvents:YES];
        [button4 setAcceptsTouchEvents:YES];

        [self updateStats];
    }
}


#pragma mark Movement Methods

- (IBAction)move:(id)sender
{
    if (!gameInProgress) return;

    NSUInteger buttonValue = 0;
    NSUInteger roll = 0;

    if (sender == button1) buttonValue = 1;
    if (sender == button2) buttonValue = 2;
    if (sender == button3) buttonValue = 3;
    if (sender == button4) buttonValue = 4;
    if (sender == button5) buttonValue = 5;
    if (sender == button6) buttonValue = 6;
    if (sender == button7) buttonValue = 7;
    if (sender == button8) buttonValue = 8;
    if (sender == button9) buttonValue = 9;

    // Are we hitting one of the number keys to cast a spell during a fight?

    if (playerCombatFlag)
    {
        [self playerSpell:buttonValue]; // playerSpell: checks whether a spell has been cast
        return;
    }

    // Are we going up or down stairs?

    if (stairsFlag)
    {
        tempFloor = floor;

        if (buttonValue == 8) floor++;
        if (buttonValue == 2) floor--;

        if ((buttonValue == 2) || (buttonValue == 8))
        {
            stairsFlag = NO;

            if ((floor > 7) || (floor < 2))
            {
                theMessage.inputString = @"These stairs are blocked";
                [theMessage update];
                floor = tempFloor;
                return;
            }

            [self clearScreen];

            // Go to Scenario Control to define and draw next floor

            fightTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(scenarioControl) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];

            return;
        }
    }

    // Calculate the location of square the player is about to enter

    switch (buttonValue)
    {
        case 1:
        {
            nextPos = currentPos + 39;
            break;
        }

        case 2:
        {
            nextPos = currentPos + 40;
            break;
        }

        case 3:
        {
            nextPos = currentPos + 41;
            break;
        }

        case 4:
        {
            nextPos = currentPos - 1;
            break;
        }

        case 5:
        default:
        {
            nextPos = currentPos;
            break;
        }

        case 6:
        {
            nextPos = currentPos + 1;
            break;
        }

        case 7:
        {
            nextPos = currentPos - 41;
            break;
        }

        case 8:
        {
            nextPos = currentPos - 40;
            break;
        }

        case 9:
        {
            nextPos = currentPos - 39;
            break;
        }
    }

    // Increase the number of turns

    turnCount++;
    needSaveFlag = YES;

    // If the player is standing still, don't increase stamina etc.

    if (buttonValue == 5)
    {
        [self updateStats];
        return;
    }

    charStamina = charStamina + 10;
    pokeCharacter = kGraphicCharacter;

    // What's in the square we're about to enter?

    nextPosContents = screen[nextPos];

    if (nextPosContents == kGraphicPathUp || nextPosContents == kGraphicPathDown)
    {
        // We're about to step on the path - that's OK, so make it so

        [theMessage clearBuffer];
        theMessage.inputString = @"Safe on the path... Which way?";
        [theMessage update];
        screen[currentPos] = savedContents;
        savedContents = nextPosContents;
        currentPos = nextPos;
        screen[currentPos] = pokeCharacter;
        [self drawScreen];
        [self updateStats];
        return;
    }

    if (nextPosContents == kGraphicSafeCastle)
    {
        [theMessage clearBuffer];
        theMessage.inputString = @"Thou art safe in a castle...";
        [theMessage update];

        screen[currentPos] = savedContents;
        savedContents = nextPosContents;
        currentPos = nextPos;
        screen[currentPos] = pokeCharacter;
        [self drawScreen];

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

        if ([defaults boolForKey:@"le_Valley_Save_in_Castles"] == YES)
        {
            // Only allowed to save the game if we're in a castle

            theMessage.inputString = @"Wilt thou save your game? Here you may";
            [theMessage update];
        }
        else
        {
            theMessage.inputString = @"Thy wounds healed... thy sword sharp";
            [theMessage update];
        }

        charStamina = 150;
        if (charCombatStrength < 20) charCombatStrength = 20;

        theMessage.inputString = @"Go as the gods demand... trust no other";
        [theMessage update];

        [self updateStats];
        return;
    }

    if (nextPosContents == kGraphicBorder || nextPosContents == kGraphicWall || nextPosContents == kGraphicTree)
    {
        // Can't move on to these squares, so keep the player where he is and undo the move

        theMessage.inputString = @"That way is blocked... choose another path";
        [theMessage update];

        turnCount = turnCount - 1;
        charStamina = charStamina - 10;
        [self updateStats];
        return;
    }

    if (nextPosContents == kGraphicWood || nextPosContents == kGraphicSwamp || nextPosContents == kGraphicTower)
    {
        // About to enter a new scenario from the Valley - we deal with preserving scenario locations there

        [self scenarioControl];
        [self updateStats];
        return;
    }

    if (nextPosContents == kGraphicDoor || nextPosContents == kGraphicWoodBorder)
    {
        // About to quit a scenario

        // Check enough time has been spent before we quit

        if (turnCount < (scenarioTurnTime + arc4random_uniform((uint32_t)timeFactor)))
        {
            // Player hasn't played enough in the scenario so cancel the move

            theMessage.inputString = @"The way is barred, try again later";
            [theMessage update];
            turnCount--;
            charStamina = charStamina - 10;
            [self updateStats];
            return;
        }

        [self scenarioControl];
        [self updateStats];
        return;
    }

    if (nextPosContents == kGraphicStair)
    {
        // Climb stairs

        stairsFlag = YES;
        theMessage.inputString = @"A stairway... Up (8) or Down (2)?";
        [theMessage update];
        return;
    }

    if (nextPosContents == kGraphicLake || (buttonValue == 5 && savedContents == kGraphicLake))
    {
        // Is the player staying put in the lake, or entering it?

        pokeCharacter = kGraphicCharInLake;
        charStamina = charStamina - 20;
        [self updateStats];
    }

    if (nextPosContents == kGraphicLair && savedContents != kGraphicLake)
    {
        // The player about to enter the Lair or Temple
        // We preserve the current position on the scenario routines

        [self scenarioControl];
        [self updateStats];
        return;
    }

    if (nextPosContents == kGraphicLair && savedContents == kGraphicLake)
    {
        // Is the player trying to enter the Lair/Temple from the water? This is not allowed

        theMessage.inputString = @"You cannot enter the building this way";
        [theMessage update];
        turnCount--;
        charStamina = charStamina - 10;
        [self updateStats];
        return;
    }

    if (nextPosContents == kGraphicTreasure)
    {
        // Treasure!

        [self specialFind];

        // Move onto the treasure space

        screen[currentPos] = savedContents;
        currentPos = nextPos;

        // Replace the treasure image with a space - can't keep coming back for more

        savedContents = kGraphicSpace;
        screen[currentPos] = kGraphicCharacter;

        [self drawScreen];
        [self updateStats];
        return;
    }

    // Player can move and is not entering or exiting a scenario, or dealing with a special character
    // So put the saved contents back into the square we're moving off

    screen[currentPos] = savedContents;

    // Set the current position to the one we're entering

    currentPos = nextPos;

    // Save the new square's contents

    savedContents = nextPosContents;

    // Put the player's graphic into the square he's entering

    screen[currentPos] = pokeCharacter;

    [self drawScreen];

    // Roll for a random find

    roll = arc4random_uniform(100) + 1;

    if (roll < 30)
    {
        // Rolled a wandering monster

        [self announceMonster];
        return;
    }

    if (roll > 75)
    {
        // Rolled a treasure discovery

        [self find];
        return;
    }

    // No monster or treasure found, so give player movement instructions for the next turn

    theMessage.inputString = @"Your move... Which direction?";
    [theMessage update];
    heartbeatCount = 0;
    [self updateStats];
}



#pragma mark Search methods

- (void)find
{
    [theMessage clearBuffer];

    NSInteger roll = arc4random_uniform(6) + 1;

    switch (roll)
    {
        case 1:
        {
            theMessage.inputString = @"A Circle of Evil... Depart in haste!";
            [theMessage update];

            charStamina = charStamina - 20;
            charPsiStrength = charPsiStrength - ((floor + 1) / 2);
            charCombatStrength = charCombatStrength + ((floor + 1) / 2);
            needSaveFlag = YES;
            break;
        }

        case 2:
        case 3:
        {
            theMessage.inputString = @"A Hoard of Gold!";
            [theMessage update];

            treasure = treasure + 100 + (floor * arc4random_uniform(100));
            needSaveFlag = YES;
            break;
        }

        case 4:
        case 5:
        {
            theMessage.inputString = @"You feel the aura of deep magic...";
            [theMessage update];
            theMessage.inputString = @"...all around you";
            [theMessage update];

            charPsiStrength = charPsiStrength + 2 + (floor * charPsiGain);
            charCombatStrength = charCombatStrength + 1 + (floor * charCombatGain);
            charStamina = charStamina + 25;
            needSaveFlag = YES;
            break;
        }

        case 6:
        {
            theMessage.inputString = @"A place of ancient power!";
            [theMessage update];

            charPsiStrength = charPsiStrength + 2 + (floor * charPsiGain);
            charCombatStrength = charCombatStrength + 1 + (floor * charCombatGain);
            charStamina = charStamina + 25;
            needSaveFlag = YES;
            break;
        }
    }

    // Wait for 1.5 seconds before displaying next message

    fightTimer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(postFind) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];
}



- (void)postFind
{
    [self updateStats];
    theMessage.inputString = @"Your move... Which direction?";
    [theMessage update];
    heartbeatCount = 0;
}



- (void)specialFind
{
    NSInteger roll = arc4random_uniform(100) + 1;

    if (currentScenario == kScenarioLair && roll > 95 && items[1] == 6 && items[2] == 0 && rating > 25)
    {
        items[2] = 1;
        treasure = treasure + 100 * (items[0] + items[1] + items[2] + floor);
        theMessage.inputString = @"You find the Helm of Evanna!";
        [theMessage update];
        needSaveFlag = YES;
        fightTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(postFind) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];

        return;
    }

    if (currentScenario == kScenarioTemple && roll > 85 && items[0] == 0)
    {
        items[0] = 1;
        treasure = treasure + 100 * (items[0] + items[1] + items[2] + floor);
        theMessage.inputString = @"You find the Amulet of Alarian...";
        [theMessage update];
        needSaveFlag = YES;
        fightTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(amuletEmpty) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];

        return;
    }

    if (currentScenario == kScenarioTower && roll > 70 && items[0] == 1 && items[1] < 6 && floor > items[1])
    {
        theMessage.inputString = @"You find an amulet stone...";
        [theMessage update];

        if (roll > 85)
        {
            items[1] = items[1] + 1;
            treasure = treasure + 100 * (items[0] + items[1] + items[2] + floor);

            fightTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(amuletStoneFits) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];
        }
        else
        {
            fightTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(amuletStoneDoesntFit) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];
        }

        needSaveFlag = YES;
        return;
    }

    if (roll > 43)
    {
        theMessage.inputString = @"A worthless bauble";
        [theMessage update];
    }
    else
    {
        theMessage.inputString = @"A precious stone!";
        [theMessage update];
        needSaveFlag = YES;
        treasure = treasure + (100 * (items[0] + items[1] + items[2] + floor));
    }

    fightTimer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(postFind) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];
}



- (void)amuletStoneFits
{
    theMessage.inputString = @"...and the stone fits!";
    [theMessage update];
}



- (void)amuletStoneDoesntFit
{
    theMessage.inputString = @"...but the wrong one...";
    [theMessage update];
}



- (void)amuletEmpty
{
    theMessage.inputString = @"...empty!";
    [theMessage update];
}


#pragma mark Monster and Combat Methods

- (void)announceMonster
{
    // Announce the appearance of a monster

    [self clearText];

    theMessage.inputString = @"Beware... thou hast encountered...";
    [theMessage update];
    [self updateStats];

    // Assume the monster will strike first, to prevent mis-keys

    monsterTurn = YES;
    playerCombatFlag = YES;

    // Wait 1.8 seconds before announcing the monster's type

    fightTimer = [NSTimer timerWithTimeInterval:1.8
                                         target:self
                                       selector:@selector(chooseMonster)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)chooseMonster
{
    // Randomly roll a monster based on location

    NSInteger rf, roll_1, roll_2;
    NSRange result;
    BOOL monsterSelectedFlag = NO;
    monsterHitFlag = NO;

    while (monsterSelectedFlag == NO)
    {
        roll_1 = arc4random_uniform(17);         // Roll 0-16 for the monster
        roll_2 = arc4random_uniform(100) + 1;    // Roll a percentage

        if (roll_1 < 10)
        {
            // Rolled a not-particularly-nasty monster

            rf = roll_1;

            // If the player is in water, roll a water-living creature (17-18)

            if (nextPosContents == kGraphicLake) rf = arc4random_uniform(2) + 17;

            // Check that the creature is available to select

            result = [scenarioMonsterTypes rangeOfString:monsterCode[rf]];
            if (result.location != NSNotFound) monsterSelectedFlag = YES;
        }
        else
        {
            // One of the nasty creatures rolled, but only select it on a further 15% chance

            if (roll_2 > 85)
            {
                rf = roll_1;

                result = [scenarioMonsterTypes rangeOfString:monsterCode[rf]];
                if (result.location != NSNotFound) monsterSelectedFlag = YES;

                // Reject a Balrog except in all but 5% of the time

                if (rf == 16 && roll_2 < 75) monsterSelectedFlag = NO;

                // Reject a Ring Wraith on low floor levels 0-4

                if (rf == 15 && floor < 5) monsterSelectedFlag = NO;
            }
        }
    }

    monsterCombatStrength = monsterStrength[rf] == 0 ? 0 : (charCombatStrength * 0.3) + (monsterStrength[rf] * pow(floor, 0.2) / ([self random] + 1));
    monsterCombatPsi = monsterPsi[rf] == 0 ? 0 : monsterPsi[rf] * pow(floor, 0.2) / ([self random] + 1);
    experienceGain = (rf + 1) * pow(floor, 1.5);
    theMessage.inputString = [@"...an evil " stringByAppendingString:monsterName[rf]];
    [theMessage update];

    // Display monster details in UI

    monstersName.inputString = monsterName[rf];
    [monstersName update];
    monstersName.hidden = NO;

    mstrGraphic.hidden = NO;

    monsterStrengthView.inputValue = monsterCombatStrength == 0 ? monsterCombatPsi : monsterCombatStrength;
    [monsterStrengthView update];
    monsterStrengthView.hidden = NO;

    // Close off non-combat buttons

    [button9 setAcceptsTouchEvents:NO];
    [button8 setAcceptsTouchEvents:NO];
    [button7 setAcceptsTouchEvents:NO];
    [button6 setAcceptsTouchEvents:NO];
    [button5 setAcceptsTouchEvents:NO];
    [button4 setAcceptsTouchEvents:NO];

    // Check for surprise

    if ((arc4random_uniform(100) + 1) < 60)
    {
        // Give the monster the initiative

        surpriseFlag = NO;
        [self launchMonsterAttack];
        return;
    }

    // Wait 1.5 seconds before asking the player to strike

    fightTimer = [NSTimer timerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(managePlayerInitiative)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)managePlayerInitiative
{
    // Player has the initiative

    theMessage.inputString = @"You have surprise... Attack or Retreat?";
    [theMessage update];

    waitingToStrikeFlag = NO;
    surpriseFlag = YES;

    // Player has 2 seconds to use his initiative

    targetTime = 2;
    heartbeatCount = 0;
}


- (void)launchPlayerAttack
{
    // Wait 1.5 seconds before asking the player to strike

    fightTimer = [NSTimer timerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(playerFight)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}


- (void)playerFight
{
    // Tell the player it's time to attempt a hit

    theMessage.inputString = @"Strike Quickly!";
    [theMessage update];

    waitingToStrikeFlag = YES;
    playerCombatFlag = YES;
    monsterTurn = NO;

    // Player has 3 seconds in which to choose Head, Body or Legs to hit (via strike:)

    targetTime = 3;
    heartbeatCount = 0;
}



- (void)playerFumbled
{

}



- (void)timeIsUp:(NSTimer*)theTimer
{
    // We come here when the timer fires

    if (playerCombatFlag)
    {
        // The player didn't press a key in time

        waitingToStrikeFlag = NO;
        monsterHitFlag = NO;
        surpriseFlag = NO;

        theMessage.inputString = @"Too slow!";
        [theMessage update];

        // It's the monster's turn now, no matter what

        [self launchMonsterAttack];
    }
}



-(IBAction)strike:(id)sender
{
    // Not in a battle so ignore the key press

    if (!playerCombatFlag || monsterTurn) return;

    // Flag used to record the purpose of the timer

    waitingToStrikeFlag = NO;

    float experienceFactor = experience == 0 ? 39 * log(1) / 3.14 : 39 * log(experience) / 3.14;

    if (monsterCombatStrength == 0)
    {
        // The monster is ethereal and can't be hit by swords - only spells

        theMessage.inputString = @"Your sword avails you nought here.";
        [theMessage update];

        [self launchMonsterAttack];
        return;
    }

    // Spend a point of stamina to make the strike

    charStamina = charStamina - 1;

    if (charStamina < 1)
    {
        // The player killed themself

        theMessage.inputString = @"You fatally exhaust yourself.";
        [theMessage update];
        heartbeatCount = 0;
        gameInProgress = NO;
        [self death];
        return;
    }

    [self updateStats];
    needSaveFlag = YES;
    NSInteger roll = [self random] * 10;
    float outcome = 0.0;

    // Set the outcome according to which button was pressed and how successful was the hit

    if (sender == cButtonH && (roll < 5 || charCombatStrength > monsterCombatStrength * 4)) outcome = 2.0;

    if (sender == cButtonB && (roll < 7 || charCombatStrength > monsterCombatStrength * 4)) outcome = 1.0;

    if (sender == cButtonL && (roll < 9 || charCombatStrength > monsterCombatStrength * 4)) outcome = 0.3;

    if (outcome == 0)
    {
        // Player missed the monster

        theMessage.inputString = @"You missed it.";
        [theMessage update];
        monsterHitFlag = NO;
        heartbeatCount = 0;

        [self launchMonsterAttack];
        return;
    }

    float floatcalc;
    NSInteger damage;

    if (monsterHitFlag)
    {
        // Hit the monster really hard last strike? Do enough damage to finish it off

        damage = monsterCombatStrength + 1 + ([self random] * 9);
        monsterHitFlag = NO;
    }
    else
    {
        floatcalc = (((charCombatStrength * 50 * [self random]) - (10 * monsterCombatStrength) + experienceFactor) / 100);
        damage = floatcalc * outcome;

        if (damage < 0) damage = 0;
        if (charCombatStrength > (monsterCombatStrength - damage) * 4) monsterHitFlag = YES;
    }

    heartbeatCount = 0;

    if (damage == 0)
    {
        // Didn't hurt the monster

        theMessage.inputString = @"A hit... but no damage";
        [theMessage update];
        monsterHitFlag = NO;
        [self launchMonsterAttack];
        return;
    }

    monsterCombatStrength = monsterCombatStrength - damage;
    if (monsterCombatStrength < 0) monsterCombatStrength = 0;
    monsterStrengthView.inputValue = monsterCombatStrength;
    [monsterStrengthView update];

    theMessage.inputString = [NSString stringWithFormat:@"A hit... %ld damage...", (long)damage];
    [theMessage update];

    // Wait 1.5 seconds then process damage done

    fightTimer = [NSTimer timerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(playerDoesDamage)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)playerDoesDamage
{
    // Post delay entry point to determine player's strike outcome

    if (monsterCombatStrength < 1)
    {
        // Monster is dead

        theMessage.inputString = @"...killing the monster";
        [theMessage update];
        heartbeatCount = 0;
        playerCombatFlag = NO;
        monsterHitFlag = NO;
        experience = experience + experienceGain;
        needSaveFlag = YES;

        // Reactivate movement keys

        [button9 setAcceptsTouchEvents:YES];
        [button8 setAcceptsTouchEvents:YES];
        [button7 setAcceptsTouchEvents:YES];
        [button6 setAcceptsTouchEvents:YES];
        [button5 setAcceptsTouchEvents:YES];
        [button4 setAcceptsTouchEvents:YES];

        [self updateStats];


        // Wait 1.5 seconds then see what's what

        fightTimer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(postFind)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    if (monsterHitFlag)
    {
        // The monster was hit so hard, it is stunned

        theMessage.inputString = [NSString stringWithFormat:@"The %@ staggers, defeated", monstersName.inputString];
        [theMessage update];

        // The player gets a quick second hit attempt

        [self launchPlayerAttack];
        return;
    }

    // All things being equal, if we're here, it's the monster's turn to fight

    [self launchMonsterAttack];
}



- (IBAction)castSpell:(id)sender
{
    // Not in a battle or it's the monster's turn, so ignore the key presses

    if (!playerCombatFlag || monsterTurn) return;

    if (surpriseFlag)
    {
        // By pressing 'S', the player fumbled the Attack or Retreat press,
        // so give the monster the initiative

        surpriseFlag = NO;
        monsterTurn = YES;
        [self monsterFight];
        return;
    }

    theMessage.inputString = @"Which spell seek ye?";
    [theMessage update];

    waitingToStrikeFlag = YES;
    playerCombatFlag = YES;
    castSpellFlag = YES;

    // Set up a four-second timer and add it to the main run loop.
    // We will cancel it if the player presses a key before the time is up

    targetTime = 4;
    heartbeatCount = 0;
}



- (void)playerSpell:(NSInteger)keyValue
{
    // Ignore input if we're not in combat or haven't just tried to cast a spell

    if (!playerCombatFlag || !castSpellFlag) return;

    waitingToStrikeFlag = NO;

    if (keyValue > 3)
    {
        // Player press the wrong button

        theMessage.inputString = @"There is no such spell!";
        [theMessage update];

        heartbeatCount = 0;
        castSpellFlag = NO;

        [self launchMonsterAttack];
        return;
    }

    if (4 * charPsiStrength * [self random] <= monsterCombatPsi)
    {
        theMessage.inputString = @"No use, the beast's Psi shields it";
        [theMessage update];

        heartbeatCount = 0;
        castSpellFlag = NO;

        [self launchMonsterAttack];
        return;
    }

    spellCast = [self magic:keyValue];

    // Wait three seconds before announcing result of spell

    fightTimer = [NSTimer timerWithTimeInterval:3
                                         target:self
                                       selector:@selector(spellOutcome)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)spellOutcome
{
    switch (spellCast)
    {
        case 1:
            theMessage.inputString = @"Success!";
            [theMessage update];

            // Wait 2 seconds then see what's what

            fightTimer = [NSTimer timerWithTimeInterval:2
                                                 target:self
                                               selector:@selector(postFind)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                         forMode:NSDefaultRunLoopMode];

            return;
            break;

        case 2:
            theMessage.inputString = @"This beast has no Psi to attack!";
            [theMessage update];
            break;

        case 3:
            theMessage.inputString = @"There is no such spell!";
            [theMessage update];
            break;

        case 4:
            theMessage.inputString = @"It is beyond you!";
            [theMessage update];
            break;

        case 5:
            theMessage.inputString = @"The spell saps your strength!";
            [theMessage update];
            [self death];
            return;
            break;

        case 6:
            theMessage.inputString = @"...but the spell fails!";
            [theMessage update];
            break;

        case 7:
            theMessage.inputString = @"The beast's Psi shields it!";
            [theMessage update];
            break;
    }

    [self launchMonsterAttack];
}



- (NSInteger)magic:(NSInteger)keyValue
{
    NSInteger damage;
    float roll;

    float experienceFactor = 39 * log(experience) / 3.14;
    NSInteger outcome = 0;

    switch (keyValue)
    {
        case kSpellSleep:
            charStamina = charStamina - 5;

            if (charStamina < 1)
            {
                // Player dies casting spell

                outcome = 5;
                break;
            }

            needSaveFlag = YES;

            [theMessage clearBuffer];
            theMessage.inputString = @"Sleep, foul fiend, that I may escape";
            [theMessage update];
            theMessage.inputString = @"and preserve my miserable skin";
            [theMessage update];

            if (arc4random_uniform(100) < 50)
            {
                // Failure

                outcome = 6;
            }
            else
            {
                // Success

                outcome = 1;
                playerCombatFlag = NO;
                experience = experience + (experienceGain / 2);
            }

            break;

        case kSpellPsilance:
            if (experience < 1000 || monsterCombatStrength > charStamina || charPsiStrength < 49)
            {
                // Not able to cast this one
                outcome = 4;
                break;
            }

            charStamina = charStamina - 10;

            if (charStamina < 1)
            {
                outcome = 5;
                break;
            }

            if (monsterCombatPsi == 0)
            {
                outcome = 2;
                break;
            }

            [theMessage clearBuffer];
            theMessage.inputString = @"With my mind I battle thee for my life!";
            [theMessage update];
            needSaveFlag = YES;

            roll = [self random];

            if (roll < 0.4 && monsterCombatPsi > 10)
            {
                outcome = 6;
                break;
            }

            damage = ((((charCombatStrength * 50 * roll) - 5 * (monsterCombatStrength + monsterCombatPsi) + experienceFactor) / 50) / 4);

            if (damage < 1)
            {
                damage = 0;
                outcome = 7;
                break;
            }

            theMessage.inputString = [NSString stringWithFormat:@"The Psi-Lance causes %ld damage", (damage * 2)];
            [theMessage update];
            heartbeatCount = 0;

            monsterCombatPsi = monsterCombatPsi - (3 * damage);
            if (monsterCombatPsi < 1) monsterCombatPsi = 0;

            monsterCombatStrength = monsterCombatStrength - damage;
            if (monsterCombatStrength < 1) monsterCombatStrength = 0;

            // Set outcome value so returned-to method displays no message (that's all done here)

            outcome = 8;

            if (monsterCombatStrength + monsterCombatPsi > 0) break;

            theMessage.inputString = @"...killing the creature";
            [theMessage update];
            experience = experience + experienceGain;
            playerCombatFlag = NO;
            break;

        case kSpellCrisp:
            if (experience < 5000 || charPsiStrength < 77)
            {
                outcome = 4;
                break;
            }

            charStamina = charStamina - 20;

            if (charStamina < 1)
            {
                outcome = 5;
                break;
            }

            [theMessage clearBuffer];
            theMessage.inputString = @"With the might of my sword I smite thee";
            [theMessage update];
            theMessage.inputString = @"With the power of my spell I curse thee";
            [theMessage update];
            theMessage.inputString = @"Burn ye spawn of Hell and suffer...";
            [theMessage update];
            needSaveFlag = YES;

            roll = [self random];

            if (roll > (charPsiStrength / 780) * (5 - charPsiGain))
            {
                outcome = 2;
                break;
            }

            damage = ((charCombatStrength + charPsiStrength * [self random])) - (10 * monsterCombatPsi * (arc4random() % 10) * 0.1);

            if (damage < 1)
            {
                damage = 0;
                outcome = 7;
                break;
            }

            theMessage.inputString = [NSString stringWithFormat:@"Crispit causes %ld damage", (damage * 2)];
            [theMessage update];

            if (monsterCombatStrength == 0)
            {
                monsterCombatPsi = monsterCombatPsi - damage;
            }
            else
            {
                monsterCombatStrength = monsterCombatStrength - damage;

                if (damage > 10)
                {
                    // A particularly big hit damages the monster's Psi by a third

                    monsterCombatPsi = monsterCombatPsi - (NSInteger)(damage / 3);
                }
            }

            // Set outcome value so returned-to method displays no message (that's all done here)

            outcome = 8;

            if ((monsterCombatStrength + monsterCombatPsi) > 0) break;

            theMessage.inputString = @"...killing the creature";
            [theMessage update];
            heartbeatCount = 0;
            experience = experience + experienceGain;
            playerCombatFlag = NO;
            break;
    }

    return outcome;
}



- (void)launchMonsterAttack
{
    monsterTurn = YES;

    // Wait 1.3 seconds before processing monster's attack

    fightTimer = [NSTimer timerWithTimeInterval:1.3
                                         target:self
                                       selector:@selector(monsterFight)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)monsterFight
{
    // Announce the attack

    theMessage.inputString = @"The creature attacks...";
    [theMessage update];

    // Wait 1.3 seconds before launching the strike

    fightTimer = [NSTimer timerWithTimeInterval:1.3
                                         target:self
                                       selector:@selector(monsterStrikes)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)monsterStrikes
{
    // Post delay routine to continue monster's attack

    NSInteger roll;
    float experienceFactor, floatcalc;

    float outcome = 0;

    if (monsterCombatStrength != 0)
    {
        // Monster is corporeal
        // But will it use Psi anyway? It will if its Combat Strength has fallen below its Psi

        if (monsterCombatStrength < monsterCombatPsi && monsterCombatPsi > 6 && [self random] < 0.5)
        {
            // The creature goes for spell anyway

            [self monsterPsiAttack];
            return;
        }

        monsterCombatStrength = monsterCombatStrength - 1;

        if (monsterCombatStrength < 1)
        {
            // The monster wears itself out

            theMessage.inputString = @"...using its last energy in the attempt";
            [theMessage update];

            experience = experience + (experienceGain / 2);
            playerCombatFlag = NO;
            monsterTurn = NO;

            [button9 setAcceptsTouchEvents:YES];
            [button8 setAcceptsTouchEvents:YES];
            [button7 setAcceptsTouchEvents:YES];
            [button6 setAcceptsTouchEvents:YES];
            [button5 setAcceptsTouchEvents:YES];
            [button4 setAcceptsTouchEvents:YES];

            [self updateStats];    // updateStats: wipes the monster strength readout
            return;
        }

        monsterStrengthView.inputValue = monsterCombatStrength;
        [monsterStrengthView update];

        roll = ([self random] * 10) + 1;

        switch (roll)
        {
            case 1:
                theMessage.inputString = @"It swings at you and misses";
                [theMessage update];
                break;

            case 2:
                theMessage.inputString = @"Your blade deflects the blow";
                [theMessage update];
                break;

            case 3:
                theMessage.inputString = @"...but hestitates, unsure...";
                [theMessage update];
                break;

            case 4:
                theMessage.inputString = @"It strikes your head!";
                [theMessage update];
                outcome = 3;
                break;

            case 5:
            case 6:
                theMessage.inputString = @"Your chest is struck!";
                [theMessage update];
                outcome = 1.5;
                break;

            case 7:
            case 8:
                theMessage.inputString = @"A strike to your swordarm!";
                [theMessage update];
                outcome = 1;
                break;

            case 9:
                theMessage.inputString = @"A blow to your body!";
                [theMessage update];
                outcome = 1.3;
                break;

            case 10:
                theMessage.inputString = @"It catches your legs!";
                [theMessage update];
                outcome = 0.5;
                break;

            default:
                break;
        }

        if (roll > 3)
        {
            // Calculate damage done to player

            experienceFactor = experience == 0 ? 39 * log(1) / 3.14 : 39 * log(experience) / 3.14;
            floatcalc = (((monsterCombatStrength * 75 * [self random]) - (10 * charCombatStrength) - experienceFactor) / 100);
            gVariable = floatcalc * outcome;

            // Wait 1.8 seconds then report damage

            fightTimer = [NSTimer timerWithTimeInterval:1.8
                                                 target:self
                                               selector:@selector(monsterDoesDamage)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                         forMode:NSDefaultRunLoopMode];

            return;
        }

        // The monster missed to the player

        [self launchPlayerAttack];
        return;
    }

    // If we're here, the monster hasn't got a body, so must use magic

    [self monsterPsiAttack];
}



- (void)monsterDoesDamage
{
    NSInteger damage = gVariable;

    // Post delay routine to display damage done by monster after a pause

    if (damage < 1) damage = 0;

    if (damage == 0)
    {
        // No damage done

        theMessage.inputString = ([self random] < 0.6) ? @"Saved by your armour!" : @"Shaken... but no damage done";
        [theMessage update];

        // Player's turn again

        [self launchPlayerAttack];
        return;
    }

    theMessage.inputString = [NSString stringWithFormat:@"You take %ld damage", damage];
    [theMessage update];

    charStamina = charStamina - damage;

    if (damage > 9)
    {
        // A mighty blow, so do extra damage to the player's ability to fight

        charCombatStrength = charCombatStrength - (damage / 9);
    }

    if (charStamina < 1)
    {
        // Player is dead

        charStamina = 0;
        gameInProgress = NO;
        monsterTurn = NO;
        playerCombatFlag = NO;

        // Wait 3 seconds then process death

        fightTimer = [NSTimer timerWithTimeInterval:3
                                             target:self
                                           selector:@selector(death)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    needSaveFlag = YES;
    [self updateStats];

    // Hand the baton to the player

    [self launchPlayerAttack];
}



- (void)monsterPsiAttack
{
    // The creature launches a mental attack

    theMessage.inputString = @"...hurling a lightning bolt at you!";
    [theMessage update];

    // Wait 1.8 seconds then process monster Psi attack

    fightTimer = [NSTimer timerWithTimeInterval:1.8
                                         target:self
                                       selector:@selector(monsterPsiStrike)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)monsterPsiStrike
{
    // Post-delay routine to present the impact of the monster's psi attack

    float experienceFactor = experience == 0 ? 39 * log(1) / 3.14 : 39 * log(experience) / 3.14;
    NSInteger damage = (((180 * monsterCombatPsi * [self random]) - (charPsiStrength + experienceFactor)) / 100);
    monsterCombatPsi = monsterCombatPsi - 5;

    if (damage > 9) monsterCombatPsi = monsterCombatPsi - (damage / 5);

    if (monsterCombatPsi < 1)
    {
        // The creatures tires itself out

        theMessage.inputString = @"...using its last energy in the attempt";
        monsterCombatPsi = 0;
        [theMessage update];
        experience = experience + (experienceGain / 2);
        playerCombatFlag = NO;
        monsterTurn = NO;

        [button9 setAcceptsTouchEvents:YES];
        [button8 setAcceptsTouchEvents:YES];
        [button7 setAcceptsTouchEvents:YES];
        [button6 setAcceptsTouchEvents:YES];
        [button5 setAcceptsTouchEvents:YES];
        [button4 setAcceptsTouchEvents:YES];

        [self updateStats];
        return;
    }

    monsterStrengthView.inputValue = monsterCombatStrength == 0 ? monsterCombatPsi : monsterCombatStrength;
    [monsterStrengthView update];

    if ([self random] < 0.25)
    {
        // Missed!

        theMessage.inputString = @"Missed you!";
        [theMessage update];

        // Player's turn again

        [self launchPlayerAttack];
        return;
    }

    if (damage < 1)
    {
        // No damage done

        theMessage.inputString = @"Your Psi shield protects you!";
        [theMessage update];

        // Player's turn again

        [self launchPlayerAttack];
    }
    else
    {
        theMessage.inputString = @"It strikes home!";
        [theMessage update];
        gVariable = damage;

        // Wait 2 seconds then report damage

        fightTimer = [NSTimer timerWithTimeInterval:2
                                             target:self
                                           selector:@selector(monsterPsiDamage)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];
    }
}



- (void)monsterPsiDamage

{
    // Post-delay routine to present monster's psi attack damage

    NSInteger damage = gVariable;

    if (damage > 9) charPsiStrength = charPsiStrength - (damage / 4);

    theMessage.inputString = [NSString stringWithFormat:@"You take %ld damage", (long)damage];
    [theMessage update];
    heartbeatCount = 0;

    if (charStamina < 1)
    {
        // Player is dead

        charStamina = 0;
        gameInProgress = NO;
        monsterTurn = NO;

        // Wait 3 seconds then report deat

        fightTimer = [NSTimer timerWithTimeInterval:3
                                             target:self
                                           selector:@selector(death)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];
        return;
    }

    charStamina = charStamina - damage;
    needSaveFlag = YES;
    [self updateStats];

    // Player's turn again

    [self launchPlayerAttack];
}



#pragma mark - Scenario Control and Setup Methods


- (void)scenarioControl
{
    // We call this routine every time the player moves from one scenario to another, via 'move:'

    BOOL flag = NO;

    // Right at the start? Clear the screen

    if (loadFlag) [self clearScreen];

    // Re-roll the tower data

    for (NSInteger i = 2 ; i < 8 ; ++i)
    {
        towerFloor[i] = 0;

        do
        {
            roomDepth[i] = (NSInteger)([self random] * 5 + 4);

            if (roomDepth[i] != 5)
            {
                // We only set flag to YES if the rolled value doesn't equal 5,
                // otherwise we force a re-roll (if flag is NO)

                flag = YES;
            }
        }
        while (!flag);
    }

    towerFloor[2] = [self random] * 30 + 1;

    // If we're leaving the Valley for another scenario, save the player's position in the Valley

    if (currentScenario == kScenarioValley) valleyPos = currentPos;

    // Record the time spent in the scenario

    scenarioTurnTime = turnCount;

    if (nextPosContents == kGraphicWoodBorder)
    {
        // Player is leaving a Wood or Swamp, and entering the Valley

        currentPos = valleyPos;
        currentScenario = kScenarioValley;
        floor = 1;
    }

    if (nextPosContents == kGraphicDoor && currentScenario == kScenarioTower)
    {
        // Player is leaving a Tower and entering the Valley

        currentPos = valleyPos;
        currentScenario = kScenarioValley;
        floor = 1;
    }

    if (nextPosContents == kGraphicDoor && (currentScenario == kScenarioTemple || currentScenario == kScenarioLair))
    {
        // Player is leaving a Lair or a Temple, and entering a Wood or a Swamp

        currentPos = 999;
        floor = floor - 4;
        currentScenario = currentScenario - 3;
    }

    if (nextPosContents == kGraphicSwamp)
    {
        // Entering a Swamp

        valleyPos = currentPos;
        currentPos = 519 - towerFloor[2];
        currentScenario = kScenarioSwamp;
        floor = 2;
    }

    if (nextPosContents == kGraphicWood)
    {
        // Entering a Wood

        valleyPos = currentPos;
        currentPos = 519 - towerFloor[2];
        currentScenario = kScenarioWoods;
        floor = 3;
    }

    if (nextPosContents == kGraphicTower)
    {
        // Entering a Tower from the Valley

        valleyPos = currentPos;
        currentScenario = kScenarioTower;
        floor = 2;
    }

    if (nextPosContents == kGraphicLair || nextPosContents == kGraphicTemple)
    {
        // Entering a Lair or a Temple from a Swamp or a Wood

        currentScenario = currentScenario + 3;
        floor = floor + 4;
        positionBeforeLair = currentPos;
    }

    switch (currentScenario)
    {
        case kScenarioValley:
            theMessage.inputString = @"You stride into the Valley...";
            [theMessage update];
            [self scenarioValley];
            break;

        case kScenarioSwamp:
        case kScenarioWoods:
            [self scenarioWoods];
            break;

        case kScenarioTower:
            if (floor == 2) theMessage.inputString = @"Prepare to enter.... the Dark Tower...";
            [theMessage update];
            [self scenarioTower];
            break;

        case kScenarioLair:
        case kScenarioTemple:
            [self scenarioTemple];
            break;

        default:
            break;
    }
}



- (void)scenarioValley
{
    // This method presents the Valley

    NSInteger position, pathPokeCode, tempPos, a, roll1, roll2;
    BOOL flag = NO;

    [self clearScreen];

    // Set monster parameter for scenario

    scenarioMonsterTypes = @"VAEGH";

    // Draw Valley frame

    for (NSUInteger i = 0 ; i < 40 ; ++i)
    {
        screen[i] = kGraphicBorder;
        screen[i + 520] = kGraphicBorder;
    }

    for (NSUInteger i = 1 ; i < 14 ; ++i)
    {
        screen[i * 40] = kGraphicBorder;
        screen[i * 40 + 39] = kGraphicBorder;
    }

    // Calculate Valley path only if it hasn't already been done

    if (valleyPath[0] == -1)
    {
        // Place first Safe Castle

        position = 41 + (40 * (1 + arc4random_uniform(5)));

        // Store it in the path array

        valleyPath[0] = position;
        valleyPath[1] = kGraphicSafeCastle;

        // Put the player inside the castle

        valleyPos = position;
        tempPos = position;

        for (NSUInteger i = 2 ; i < 75 ; i = i + 2)
        {
            if ((arc4random_uniform(100) + 1) > 50)
            {
                // Path down

                position = tempPos - 39;

                if (position < 40)
                {
                    // Make sure path doesn't cross border

                    pathPokeCode = kGraphicPathUp;
                    position = tempPos + 41;
                }
                else
                {
                    pathPokeCode = kGraphicPathDown;
                }
            }
            else
            {
                // Path up

                position = tempPos + 41;

                if (position > 519)
                {
                    // Make sure path doesn't cross border

                    pathPokeCode = kGraphicPathDown;
                    position = tempPos - 39;
                }
                else
                {
                    pathPokeCode = kGraphicPathUp;
                }
            }

            valleyPath[i + 1] = pathPokeCode;

            if (i > 2 && valleyPath[i + 1] != valleyPath[i - 1]) position = tempPos + 1;

            valleyPath[i] = position;
            tempPos = position;
        }

        // Place and store right-hand castle

        valleyPath[75] = kGraphicSafeCastle;

        // Compute scenario positions

        if (places[0] == -1)
        {
            for (NSUInteger i = 0 ; i < 5 ; ++i)
            {
                flag = NO;

                while (!flag)
                {
                    roll1 = arc4random_uniform(11) + 1;
                    roll2 = arc4random_uniform(34) + 1;
                    a = 40 + (40 * roll1) + roll2;

                    if (screen[a] == kGraphicSpace && screen[a + 1] == kGraphicSpace)
                    {
                        // Only place a scenario if there's empty space

                        places[i] = a;
                        flag = YES;
                    }
                }
            }
        }

        savedContents = kGraphicSafeCastle;
    }

    // Draw Valley path

    for (NSUInteger i = 0 ; i < 75 ; i = i + 2) screen[valleyPath[i]] = valleyPath[i + 1];

    // Draw scenario locations

    screen[places[0]] = kGraphicSwamp;
    screen[places[0] + 1] = kGraphicSwamp;
    screen[places[1]] = kGraphicSwamp;
    screen[places[1] + 1] = kGraphicSwamp;
    screen[places[2]] = kGraphicWood;
    screen[places[2] + 1] = kGraphicWood;
    screen[places[3]] = kGraphicWood;
    screen[places[3] + 1] = kGraphicWood;
    screen[places[4]] = kGraphicTower;

    currentPos = valleyPos;
    nextPos = valleyPos;

    savedContents = screen[currentPos];
    screen[currentPos] = kGraphicCharacter;

    [self drawScreen];
}



- (void)scenarioWoods
{
    if (currentScenario == kScenarioSwamp)
    {
        scenarioMonsterTypes = @"AFL";
        pokeCharacter = kGraphicTuft;
        theMessage.inputString = @"You cautiously enter the Swamp...";
        [theMessage update];
    }
    else
    {
        scenarioMonsterTypes = @"FAEHL";
        pokeCharacter = kGraphicTree;
        theMessage.inputString = @"You step under the cover of the Forest canopy...";
        [theMessage update];
    }

    [self clearScreen];

    // Draw random woods or swamp

    NSUInteger a;

    for (NSUInteger i = 0 ; i < 200 ; ++i)
    {
        a = arc4random_uniform(515) + 1;
        screen[a] = pokeCharacter;
    }

    // Draw in Lake
    // Random y co-ord : 0-3 multplied by 40 to get the correct row

    a = arc4random_uniform(4) * 40;

    // Random x co-ord: 0-26 added to the current row

    a = a + arc4random_uniform(27);

    NSUInteger tempPos = 85 + a;

    // Draw the lake

    screen[tempPos] = kGraphicLake;
    screen[tempPos + 1] = kGraphicLake;
    screen[tempPos + 39] = kGraphicLake;
    screen[tempPos + 40] = kGraphicLake;
    screen[tempPos + 41] = kGraphicLake;
    screen[tempPos + 42] = kGraphicLake;
    screen[tempPos + 43] = kGraphicLake;
    screen[tempPos + 78] = kGraphicLake;
    screen[tempPos + 79] = kGraphicLake;
    screen[tempPos + 82] = kGraphicLake;
    screen[tempPos + 83] = kGraphicLake;
    screen[tempPos + 84] = kGraphicLake;
    screen[tempPos + 118] = kGraphicLake;
    screen[tempPos + 119] = kGraphicLake;
    screen[tempPos + 122] = kGraphicLake;
    screen[tempPos + 123] = kGraphicLake;
    screen[tempPos + 124] = kGraphicLake;
    screen[tempPos + 159] = kGraphicLake;
    screen[tempPos + 160] = kGraphicLake;
    screen[tempPos + 161] = kGraphicLake;
    screen[tempPos + 162] = kGraphicLake;
    screen[tempPos + 164] = kGraphicLake;
    screen[tempPos + 165] = kGraphicLake;
    screen[tempPos + 201] = kGraphicLake;
    screen[tempPos + 202] = kGraphicLake;
    screen[tempPos + 242] = kGraphicLake;

    // Draw the island

    screen[tempPos + 80] = kGraphicSpace;
    screen[tempPos + 81] = kGraphicSpace;
    screen[tempPos + 120] = kGraphicLair;
    screen[tempPos + 121] = kGraphicSpace;

    // If the player is exiting the temple, put them next to it

    if (currentPos == 999) currentPos = tempPos + 81;

    // Draw in the border

    for (NSUInteger i = 0 ; i < 40 ; ++i)
    {
        screen[i] = kGraphicWoodBorder;
        screen[i + 520] = kGraphicWoodBorder;
    }

    for (NSUInteger i = 1 ; i < 14 ; ++i)
    {
        screen[i * 40] = kGraphicWoodBorder;
        screen[i * 40 + 39] = kGraphicWoodBorder;
    }

    nextPos = currentPos;
    savedContents = screen[currentPos];
    screen[currentPos] = kGraphicCharacter;

    [self drawScreen];
}



- (void)scenarioTemple
{
    scenarioMonsterTypes = @"CBE";
    towerFloor[floor] = towerFloor[2];

    if (currentScenario == kScenarioTemple)
    {
        theMessage.inputString = @"You step into the incense-filled";
        [theMessage update];
        theMessage.inputString = @"interior of the Temple...";
        [theMessage update];
    }
    else
    {
        theMessage.inputString = @"You slowly step into Vounim's Lair...";
        [theMessage update];
    }

    [self scenarioCastles];
}



- (void)scenarioTower
{
    scenarioMonsterTypes = @"CAGE";
    [self scenarioCastles];
}



- (void)scenarioCastles
{
    NSInteger v, pokeCode, tempPos, position, roll1, roll2;

    pokeCharacter = kGraphicSpace;
    floorPattern = 0;
    wallDepth = roomDepth[floor];
    stepCounter = 0;

    [self clearScreen];

    // Draw castle outer walls

    for (NSUInteger i = 0 ; i < 21 ; ++i)
    {
        screen[i] = kGraphicTowerBorder;
        screen[i + 520] = kGraphicTowerBorder;
    }

    for (NSUInteger i = 1 ; i < 14 ; ++i)
    {
        screen[i * 40] = kGraphicTowerBorder;
        screen[i * 40 + 20] = kGraphicTowerBorder;
    }

    dataPointer = 1;

    for (NSUInteger i = 1 ; i < towerFloor[floor] + 1 ; ++i)
    {
        v = towerData[dataPointer];
        dataPointer++;

        // Got to the end of the data array? Put the pointer at the start again

        if (v == 100) dataPointer = 1;
    }

    for (NSUInteger i = 1 ; i < 4 ; ++i)
    {
        roomWidth[i] = towerData[dataPointer];
        floorPattern++;
        dataPointer++;

        if (roomWidth[i] == 100)
        {
            // Got to the end of the data array? Put the pointer at the start again

            roomWidth[i] = 3;
            floorPattern++;
            dataPointer = 1;
        }
    }

    // Draw vertical interior walls

    position = 0;

    do
    {
        for (NSUInteger i = 0 ; i < wallDepth + 1 ; ++i)
        {
            pokeCode = kGraphicTowerBorder;
            tempPos = position + (40 * i);

            if (tempPos < 519)
            {
                if (i == 1) pokeCode = kGraphicSpace;

                if (roomWidth[1] == 0)
                {
                    pokeCode = kGraphicTowerBorder;
                }
                else
                {
                    screen[(tempPos + roomWidth[1])] = pokeCode;
                    pokeCode = kGraphicTowerBorder;
                }

                // Place door in second vertical wall

                if (i == 3) pokeCode = kGraphicSpace;
                screen[(tempPos + roomWidth[1] + roomWidth[2])] = pokeCode;
                pokeCode = kGraphicTowerBorder;

                // Place door in third vertical wall

                if (i == 4) pokeCode = kGraphicSpace;
                screen[(tempPos + roomWidth[1] + roomWidth[2] + roomWidth[3])] = pokeCode;
                pokeCode = kGraphicTowerBorder;
            }
        }

        position = position + (40 * wallDepth) + 40;

    } while (position < 481);

    // Draw horizontal interior walls

    position = 0;
    pokeCode = kGraphicTowerBorder;

    for (NSUInteger j = 1 ; j < 5 ; ++j)
    {
        tempPos = position + (40 * j * (wallDepth + 1));

        for (NSUInteger k = 1 ; k < 20 ; ++k)
        {
            if (tempPos < 441)
            {
                screen[tempPos + k] = pokeCode;

                if (k == 2 || k == 17 || k == 3 * wallDepth)
                {
                    // Put in a door in the wall, and a space above and below it

                    screen[tempPos + k] = kGraphicSpace;
                    screen[tempPos + k - 40] = kGraphicSpace;
                    screen[tempPos + k + 40] = kGraphicSpace;
                }
            }
        }
    }

    // Draw in the stairs

    if (currentScenario == kScenarioTower)
    {
        // Put in the stair case
        // Floor number is even, stair in bottom left corner, else top right corner

        NSUInteger a = (floor % 2 == 0) ? 481 : 59;
        screen[a] = kGraphicStair;
    }

    // Put in outer door on bottom row of castle wall, with a space ahead of it

    if (floor == 2 || currentScenario == kScenarioLair || currentScenario == kScenarioTemple)
    {
        screen[530] = kGraphicDoor;
        screen[490] = kGraphicSpace;
        currentPos = 490;
    }

    if (roomDepth[3] == 0) nextPos = 486;

    if (currentScenario == kScenarioTower || currentScenario == kScenarioTemple)
    {
        roomDepth[floor + 1] = roomDepth[floor] + floorPattern;
    }

    nextPos = currentPos;
    savedContents = screen[currentPos];
    screen[currentPos] = kGraphicCharacter;

    // Give the tower a title

    switch (currentScenario)
    {
        case kScenarioTower:
            [self print:@"THE BLACK TOWER" at:62];
            [self print:@"OF ZAEXON" at:102];
            [self print:[NSString stringWithFormat:@"FLOOR %ld", (floor - 1)] at:182];
            break;

        case kScenarioLair:
            [self print:@"VOUNIM'S LAIR" at:62];
            break;

        case kScenarioTemple:
            [self print:@"THE TEMPLE OF" at:62];
            [self print:@"Y'NAGIOTH" at:102];
            break;

        default:
            break;
    }

    if (floor < 4 || [self random] < 0.3)
    {
        // No treasure on floors below 4, so draw the screen and bail

        [self drawScreen];
        return;
    }

    // Scatter treasure

    NSUInteger a = ([self random] * 5) + 2;

    for (NSUInteger i = 0 ; i < a ; ++i)
    {
        roll1 = [self random] * 19;
        roll2 = [self random] * 12;

        if (screen[(1 + (40 * roll2) + roll1)] == kGraphicSpace)
        {
            // Place a treasure item on an empty space

            screen[(1 + (40 * roll2) + roll1)] = kGraphicTreasure;
        }
    }

    [self drawScreen];
}



- (void)print:(NSString *)inputString at:(NSInteger)location
{
    // Prints the input string at the set location

    for (NSUInteger i = 0 ; i < [inputString length] ; ++i)
    {
        char character = [inputString characterAtIndex:i];
        NSInteger b = character == 92 ? 77 : character - 64;
        screen[location + i] = b;
    }
}



#pragma mark Menu Methods

- (IBAction)newChar:(id)sender
{
    NSAlert *panel;
    NSModalResponse choice;

    // Add game in progress / unsaved char warning

    if (playerCombatFlag == YES) return;

    if (gameInProgress == YES)
    {
        panel = [[NSAlert alloc] init];
        [panel setMessageText:@"You have a game in progress"];
        [panel setInformativeText:@"Are you sure you want to end the current game and begin a new one?"];
        [panel addButtonWithTitle:@"Yes"];
        [panel addButtonWithTitle:@"No"];
        choice = [panel runModal];

        if (choice >= NSAlertSecondButtonReturn) return;
    }

    gameInProgress = NO;

    [_window beginSheet:theCharWindow completionHandler:nil];
}



- (IBAction)closeCharWindow:(id)sender
{
    charName = [charNameReadout stringValue];

    // Hide the sheet

    [theCharWindow orderOut:nil];

    // Return control to the main window

    [NSApp endSheet:theCharWindow returnCode:NSModalResponseOK];

    // Write in the player's name

    playerName.inputString = [charName stringByAppendingString:@" the "];
    playerName.inputString = [playerName.inputString stringByAppendingString:charProf];
    [playerName update];

    // Set up one-second heartbeat

    heartbeatCount = 0;

    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(heartbeat)
                                   userInfo:nil
                                    repeats:YES];

    gameInProgress = YES;
    needSaveFlag = YES;

    // Update the info display

    [self updateStats];

    // It's a new game, so go straight to the Valley

    floor = 1;
    currentScenario = kScenarioValley;

    [self scenarioValley];
}


- (IBAction)cancelCharSheet:(id)sender
{
    [theCharWindow orderOut:nil];
    [NSApp endSheet:theCharWindow returnCode:NSModalResponseCancel];
}


- (IBAction)setProfession:(id)sender
{
    if (sender == bWizard)
    {
        charProfession = kCharWizard;
        charProf = @"Wizard";
        charCombatStrength = 22;
        charPsiStrength = 28;
        charStamina = 100;
        charCombatGain = 0.5;
        charPsiGain = 2.0;
    }

    if (sender == bWarrior)
    {
        charProfession = kCharWarrior;
        charProf = @"Warrior";
        charCombatStrength = 26;
        charPsiStrength = 24;
        charStamina = 113;
        charCombatGain = 1.25;
        charPsiGain = 1.0;
    }

    if (sender == bThinker)
    {
        charProfession = kCharThinker;
        charProf = @"Thinker";
        charCombatStrength = 24;
        charPsiStrength = 26;
        charStamina = 113;
        charCombatGain = 0.75;
        charPsiGain = 1.5;
    }

    if (sender == bBarbarian)
    {
        charProfession = kCharBarbarian;
        charProf = @"Barbarian";
        charCombatStrength = 28;
        charPsiStrength = 22;
        charStamina = 125;
        charCombatGain = 2.0;
        charPsiGain = 0.5;
    }

    if (sender == bCleric)
    {
        charProfession = kCharCleric;
        charProf = @"Cleric";
        charCombatStrength = 25;
        charPsiStrength = 25;
        charStamina = 113;
        charCombatGain = 1.0;
        charPsiGain = 1.25;
    }
}



- (IBAction)aboutMenu:(id)sender
{
    if (!aboutBox)
    {
        aboutBox = [[AboutBox alloc] init];
    }

    // Centre aboutBox within main app window (assumes fixed sizes)

    NSRect windowRect = [_window frame];
    NSPoint pos;
    pos.x = windowRect.origin.x + 31;
    pos.y = windowRect.origin.y + 311;
    [aboutBox.window setFrameOrigin:pos];
    [aboutBox showWindow:self];
}



- (IBAction)toggleFullScreenMenu:(id)sender
{
    [_window toggleFullScreen:nil];
}



#pragma mark Save and Load Methods

// Save As... File Menu item

- (IBAction)saveDocument:(id)sender
{
    NSModalResponse choice;
    NSAlert *panel;
    BOOL result;
    NSString *path;

    if ((gameInProgress == YES) && (playerCombatFlag == NO))
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"le_Valley_Save_in_Castles"] == YES)
        {
            if (currentScenario != kScenarioValley || (currentPos != valleyPath[0] && currentPos != valleyPath[74]))
            {
                // Can't save mid-game - you have to return to the safe castle

                panel = [[NSAlert alloc] init];
                [panel setMessageText:@"You can't save your game here"];
                [panel setInformativeText:@"You can't save the game unless you enter one of the Valley's two Safe Castles, at either end of the safe path. This can be disabled in the Preferences."];
                [panel addButtonWithTitle:@"OK"];
                choice = [panel runModal];
                return;
            }
        }

        if (savedfilePath != nil)
        {
            // We have saved this file already, so no need to re-present the dialog

            if (needSaveFlag == YES)
            {
                // Create a character model to save

                Character *saveChar = [[Character alloc] init];

                saveChar.pcharName = charName;
                saveChar.pcharProf = charProfession;
                saveChar.pcharStam = charStamina;
                saveChar.pcharExp = experience;
                saveChar.pcharTres = treasure;
                saveChar.pcharComStr = charCombatStrength;
                saveChar.pcharPsiStr = charPsiStrength;

                saveChar.pcharItem0 = items[0];
                saveChar.pcharItem1 = items[1];
                saveChar.pcharItem2 = items[2];
                saveChar.pcharItem3 = items[3];

                saveChar.pgameCpos = currentPos;
                saveChar.pgameVpos = valleyPos;
                saveChar.pgameTpos = positionBeforeLair;

                saveChar.pgameTurns = turnCount;
                saveChar.pgameScene = currentScenario;
                saveChar.pgameSaveSq = savedContents;
                saveChar.pgameFloor = floor;

                saveChar.pPlaces1 = places[0];
                saveChar.pPlaces2 = places[1];
                saveChar.pPlaces3 = places[2];
                saveChar.pPlaces4 = places[3];
                saveChar.pPlaces5 = places[4];

                for (NSUInteger i = 0 ; i < 78 ; i++)
                {
                    [saveChar.pVpath addObject:[NSNumber numberWithInteger:valleyPath[i]]];
                }

                result = [NSKeyedArchiver archiveRootObject:saveChar toFile:savedfilePath];

                if (result == NO)
                {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    path = [savedfilePath stringByAppendingString:@"_tmp"];
                    result = [NSKeyedArchiver archiveRootObject:saveChar toFile:path];
                    [fileManager removeItemAtPath:savedfilePath error:nil];
                    [fileManager copyItemAtPath:path toPath:savedfilePath error:nil];
                    [fileManager removeItemAtPath:path error:nil];
                }

                [saveChar release];
            }

            needSaveFlag = NO;
            return;
        }

        // If we are here, the player hasn't save a file for this game before

        [self saveDocumentAs:nil];
    }
}




- (IBAction)saveDocumentAs:(id)sender

{
    if (gameInProgress && !playerCombatFlag)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"le_Valley_Save_in_Castles"] == YES)
        {
            // Can't save mid-game - you have to return to the safe castle

            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"You can't save your game here";
            alert.informativeText = @"You can't save the game unless you enter on of the Valley's two Safe Castles. This can be disable in the Preferences.";
            [alert addButtonWithTitle:@"OK"];
            [alert beginSheetModalForWindow:_window completionHandler:nil];
            return;
        }

        __block NSSavePanel *saveDialog = [NSSavePanel savePanel];

        [saveDialog setMessage:@"Choose a folder..."];
        [saveDialog setCanCreateDirectories:YES];
        [saveDialog setNameFieldStringValue:[charName stringByAppendingString:@".valcr"]];

        [saveDialog beginSheetModalForWindow:_window
                           completionHandler:^(NSInteger result)
         {
             if (result == NSFileHandlingPanelOKButton)
             {
                 // Close sheet first and stop it hogging the event queue

                 [NSApp stopModal];
                 [NSApp endSheet:saveDialog];
                 [saveDialog orderOut: self];

                 [self savePanelDidEnd:[saveDialog URL]];
             }

             saveDialog = nil;
         }
         ];
    }
    else
    {
        if (playerCombatFlag)
        {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"You are in combat.";
            alert.informativeText = @"You can't save a game while your character is fighting.";
            [alert addButtonWithTitle:@"OK"];
            [alert beginSheetModalForWindow:_window completionHandler:nil];
            return;
        }
    }
}



- (void)savePanelDidEnd:(NSURL *)fileURL
{
    NSString *path;
    BOOL result;

    // Create a character model to save

    Character *saveChar = [[Character alloc] init];

    saveChar.pcharName = charName;
    saveChar.pcharProf = charProfession;
    saveChar.pcharStam = charStamina;
    saveChar.pcharExp = experience;
    saveChar.pcharTres = treasure;
    saveChar.pcharComStr = charCombatStrength;
    saveChar.pcharPsiStr = charPsiStrength;

    saveChar.pcharItem0 = items[0];
    saveChar.pcharItem1 = items[1];
    saveChar.pcharItem2 = items[2];
    saveChar.pcharItem3 = items[3];

    saveChar.pgameCpos = currentPos;
    saveChar.pgameVpos = valleyPos;
    saveChar.pgameTpos = positionBeforeLair;

    saveChar.pgameTurns = turnCount;
    saveChar.pgameScene = currentScenario;
    saveChar.pgameSaveSq = savedContents;
    saveChar.pgameFloor = floor;

    saveChar.pPlaces1 = places[0];
    saveChar.pPlaces2 = places[1];
    saveChar.pPlaces3 = places[2];
    saveChar.pPlaces4 = places[3];
    saveChar.pPlaces5 = places[4];

    for (NSUInteger i = 0 ; i < 78 ; ++i) [saveChar.pVpath addObject:[NSNumber numberWithInteger:valleyPath[i]]];

    path = [fileURL path];

    if ([[path pathExtension] compare:@"valcr"] != NSOrderedSame)
    {
        // Add the file extension if the player has deleted it

        path = [path stringByAppendingString:@".valcr"];
    }

    result = [NSKeyedArchiver archiveRootObject:saveChar toFile:path];

    NSLog(result ? @"success" : @"failure");

    needSaveFlag = NO;
    [saveChar release];
}



- (IBAction)openDocument:(id)sender
{
    if (!playerCombatFlag)
    {
        if (gameInProgress)
        {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"You have a game in progress";
            alert.informativeText = @"Are you sure you want to end the current game and open a different one?";
            [alert addButtonWithTitle:@"Yes"];
            [alert addButtonWithTitle:@"No"];
            [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
                if (returnCode == 1000) [self showOpenDialog];
            }];

            return;
        }

        [self showOpenDialog];
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"You are in combat.";
        alert.informativeText = @"You can't save a game while your character is fighting.";
        [alert addButtonWithTitle:@"Yes"];
        [alert beginSheetModalForWindow:window completionHandler:nil];
    }
}



- (void)showOpenDialog
{
    __block NSOpenPanel *openDialog = [NSOpenPanel openPanel];

    openDialog.allowedFileTypes = [NSArray arrayWithObject:@"valcr"];
    openDialog.canChooseFiles = YES;
    openDialog.canChooseDirectories = NO;
    openDialog.allowsMultipleSelection = NO;
    [openDialog setMessage:@"Select a saved game"];

    // Run OpenPanel

    [openDialog beginSheetModalForWindow:_window
                       completionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             // Close sheet first and stop it hogging the event queue

             [NSApp stopModal];
             [NSApp endSheet:openDialog];
             [openDialog orderOut: self];

             // Send URLs to be added to table and sync'd

             [[openDialog URLs] count];
             NSString *path = [[[openDialog URLs] objectAtIndex:0] path];

             [self openFileHandler:path];
         }

         openDialog = nil;
     }];
}


- (void)openFileHandler:(NSString *)path

{
    savedfilePath = [path retain];

    Character *loadGame = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    charName = loadGame.pcharName;

    charProfession = loadGame.pcharProf;
    charStamina = loadGame.pcharStam;
    experience = loadGame.pcharExp;
    treasure = loadGame.pcharTres;
    charCombatStrength = loadGame.pcharComStr;
    charPsiStrength = loadGame.pcharPsiStr;

    items[0] = loadGame.pcharItem0;
    items[1] = loadGame.pcharItem1;
    items[2] = loadGame.pcharItem2;
    items[3] = loadGame.pcharItem3;

    currentPos = loadGame.pgameCpos;
    valleyPos = loadGame.pgameVpos;
    positionBeforeLair = loadGame.pgameTpos;

    turnCount = loadGame.pgameTurns;
    currentScenario = loadGame.pgameScene;
    savedContents = loadGame.pgameSaveSq;
    floor = loadGame.pgameFloor;

    places[0] = loadGame.pPlaces1;
    places[1] = loadGame.pPlaces2;
    places[2] = loadGame.pPlaces3;
    places[3] = loadGame.pPlaces4;
    places[4] = loadGame.pPlaces5;

    for (NSUInteger i = 0 ; i < 78 ; ++i) valleyPath[i] = [[loadGame.pVpath objectAtIndex:i] integerValue];

    nextPosContents = 0;

    // Set up one-second heartbeat

    heartbeatCount = 0;

    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(heartbeat)
                                   userInfo:nil
                                    repeats:YES];

    gameInProgress = YES;
    loadFlag = YES;
    needSaveFlag = NO;

    // Get the player's profession

    charProf = [self setProfString:charProfession];

    // Write the player's name

    playerName.inputString = [charName stringByAppendingString:@" the "];
    playerName.inputString = [playerName.inputString stringByAppendingString:charProf];
    [playerName update];

    // Update the info display

    [self updateStats];

    // Load in the currently running scenario

    [self scenarioControl];
}



- (NSString *)setProfString:(NSInteger)index
{
    switch (index)
    {
        case kCharWizard:
            charCombatGain = 0.5;
            charPsiGain = 2.0;
            return @"Wizard";

        case kCharThinker:
            charCombatGain = 0.75;
            charPsiGain = 1.5;
            return @"Thinker";

        case kCharBarbarian:
            charCombatGain = 2.0;
            charPsiGain = 0.5;
            return @"Barbarian";

        case kCharWarrior:
            charCombatGain = 1.25;
            charPsiGain = 1.0;
            return @"Warrior";

        case kCharCleric:
            charCombatGain = 1.0;
            charPsiGain = 1.25;
            return @"Cleric";

        default:
            charCombatGain = 1.0;
            charPsiGain = 1.0;
            return @"Dolt";
    }
}


#pragma mark Prefs Menu Methods

- (IBAction)prefsPanel:(id)sender
{
    // Bail if there's a fight in progress

    if (playerCombatFlag) return;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    // Set window elements according to the Defaults values

    if ([defaults boolForKey:@"le_Valley_Ascii_Graphics"] == YES)
    {
        [prefsAsciiCheckbox setState:NSOnState];
    }
    else
    {
        [prefsAsciiCheckbox setState:NSOffState];
    }

    if ([defaults boolForKey:@"le_Valley_Save_in_Castles"] == YES)
    {
        [prefsSaveCheckbox setState:NSOnState];
    }
    else
    {
        [prefsSaveCheckbox setState:NSOffState];
    }

    if ([defaults boolForKey:@"le_Valley_Do_Sounds"] == YES)
    {
        [prefsSoundCheckbox setState:NSOnState];
    }
    else
    {
        [prefsSoundCheckbox setState:NSOffState];
    }

    // Roll out the Preferences sheet

    [_window beginSheet:prefsSheet completionHandler:nil];
}



- (IBAction)prefsSheetCancel:(id)sender

{
    // User has clicked on the Delete sheet's Cancel button

    [_window endSheet:prefsSheet];
    [self closePrefsSheet:NSModalResponseCancel];
}



- (IBAction)prefsSheetSave:(id)sender

{
    // User has clicked on the Delete sheet's OK-to-delete button

    [_window endSheet:prefsSheet];[self closePrefsSheet:NSModalResponseOK];
}



- (void)closePrefsSheet:(NSInteger)outcome
{
    // Tidies up after the Prefs sheet is closed

    if (outcome == NSModalResponseCancel) return;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    // Apply the new preferences to Defaults based on window element settings

    if ([prefsAsciiCheckbox state] == NSOnState)
    {
        [defaults setBool:YES forKey:@"le_Valley_Ascii_Graphics"];
    }
    else
    {
        [defaults setBool:NO forKey:@"le_Valley_Ascii_Graphics"];
    }

    if ([prefsSaveCheckbox state] == NSOnState)
    {
        [defaults setBool:YES forKey:@"le_Valley_Save_in_Castles"];
    }
    else
    {
        [defaults setBool:NO forKey:@"le_Valley_Save_in_Castles"];
    }

    if ([prefsSoundCheckbox state] == NSOnState)
    {
        [defaults setBool:YES forKey:@"le_Valley_Do_Sounds"];
    }
    else
    {
        [defaults setBool:NO forKey:@"le_Valley_Do_Sounds"];
    }

    [defaults synchronize];
}



pragma mark - Utility Methods

- (float)random
{
    // Returns a float between 0.01 and 1

    float roll = arc4random_uniform(100);
    return roll / 100;
}



- (void)dummy

{
    NSLog(@"Standing on: %ld. About to step on: %ld", (long)savedContents, (long)nextPosContents);
}



@end
