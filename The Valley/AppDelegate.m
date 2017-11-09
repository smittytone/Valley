

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet ValleyWindow *window;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Set up Key and Value arrays as template for Defaults

    NSArray *keyArray = [NSArray arrayWithObjects:@"le_Valley_Ascii_Graphics",
                         @"le_Valley_Save_in_Castles",
                         @"le_Valley_Do_Sounds",
                         nil];

    NSArray *valueArray = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:NO],
                            nil];

    // Drop the arrays into the Defauts

    NSUserDefaults *sd = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    [sd registerDefaults:appDefaults];

    // Initialise game variables

    [self initGameVariables];

    monsterNameView.inverse = YES;
    monsterNameView.hidden = YES;
    monsterStrengthView.inverse = YES;
    monsterStrengthView.hidden = YES;
    monsterGraphic.hidden = YES;

    theMessage.space = kGraphicSpace;

    // Do the initial splash Screen

    [self clearScreen];

    NSImage *image = [NSImage imageNamed:@"valley_logo_digital"];
    theScreen.splashImage = image;

    // Set up sound

    [self setSounds:[sd boolForKey:@"le_Valley_Do_Sounds"]];

    // Give the main window the option to go full-screen

    [_window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [_window center];

    savedfilePath = nil;
    needToSave = NO;

    /*
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self
           selector:@selector(dummy)
               name:@"AFCFileCopyBegin"
             object:nil];
    */
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}



- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApp
{
    return YES;
}



#pragma mark - Full Screen Methods


- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
    [_window setStyleMask:NSWindowStyleMaskBorderless];
}



- (void)windowWillExitFullScreen:(NSNotification *)notification
{
    [_window setStyleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable)];
    [_window setTitle:@"The Valley"];
}



#pragma mark - Timer Methods

- (void)heartbeat
{
    // This method is called every second of game/real time

    // Bail if there's no game in play

    if (!isGameInProgress) return;

    ++heartbeatCount;

    // Are we timing a moment of surprise or a strike opportunity?

    if ((playerHasInitiative || isPlayersTurn || playerCastSpell) && targetTime != 0)
    {
        if (heartbeatCount <= targetTime)
        {
            // Still time to wait, so return

            return;
        }
        else
        {
            // Time's up, so play out the outcome

            [self timeIsUp:nil];
            return;
        }
    }

    // No need to go further if the player is in combat

    if (isInCombat) return;

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

    //if (heartbeatCount % kScrollMessagesTime == 0 && !stairsFlag) theMessage.inputString = @"";
}



- (void)delayIsUp:(NSTimer*)theTimer
{
    // THIS DOES NOTHING, BUT NEED TO FIGURE OUT HOW TO DELAY PROGRAM
}



- (void)midLineDelay:(NSTimeInterval)delay
{
    [NSThread sleepForTimeInterval:delay];
}



#pragma mark - Game Setup


- (void)initGameVariables
{
    // Initialise the core game variables with default values

    for (NSUInteger i = 0 ; i < 78 ; ++i) valleyPath[i] = -1;
    for (NSInteger i = 0 ; i < 7 ; ++i) places[i] = -1;

    timeFactor = 3;
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
    towerData[28] = 6;
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

    isGameInProgress = NO;
    isInCombat = NO;
    playerCastSpell = NO;
    isMonstersTurn = NO;
    isPlayersTurn = NO;
    monsterWasHitHard = NO;
}



#pragma mark - Graphics Methods


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



- (void)print:(NSString *)inputString at:(NSInteger)location
{
    // Prints the input string at the set location

    for (NSUInteger i = 0 ; i < [inputString length] ; ++i)
    {
        char character = [inputString characterAtIndex:i];
        NSInteger b = (character > 63 && character < 126) ? character - 64 : character;
        if (character == 92) b = 77;
        screen[location + i] = b;
    }
}



#pragma mark - Character Methods


- (void)updateStats
{
    // Enforce player stats maxima

    if (player.stamina > (125 - (player.comGain * 12.5))) player.stamina = 125 - (player.comGain * 12.5);
    if (player.comStrength > 77 - 2 * pow(player.comGain, 2)) player.comStrength = 77 - 2 * pow(player.comGain, 2);
    if (player.psiStrength < 7 ) player.psiStrength = 7;
    if (player.psiStrength > (42 * pow((player.psiGain + 1), log(pow(player.psiGain, 3.7)))) + 75) player.psiStrength = (42 * pow((player.psiGain + 1), log(pow(player.psiGain, 3.7)))) + 75;

    // Update Stats

    experienceView.inputValue = player.experience;
    treasureView.inputValue = player.treasure;
    turnCountView.inputValue = player.turns;
    staminaView.inputValue = player.stamina;
    psiView.inputValue = player.psiStrength;
    playerStrengthView.inputValue = player.comStrength;

    if (isInCombat)
    {
        // There's a fight going on, so display the Monster details...

        monsterStrengthView.inputValue = monsterCombatStrength == 0 ? monsterCombatPsi : monsterCombatStrength;
    }
    else
    {
        // There's no fight, so hide all the the monster details

        monsterGraphic.hidden = YES;
        monsterStrengthView.hidden = YES;
        monsterNameView.hidden = YES;
    }

    menuItemSave.enabled = needToSave;
}



- (void)death
{
    if (player.amuletStones < 6)
    {
        // Player doesn't have the Amulet of Alarian, so has no protection from death

        [self clearScreen];
        theScreen.splashImage = [NSImage imageNamed:@"skull"];
        [theMessage clearBuffer];

<<<<<<< HEAD
        [self print:@"OH, WHAT A FRAIL SHELL" at:89];
        [self print:@"IS THIS THAT WE CALL MAN?" at:127];
=======
        [self print:@"OH, WHAT A FRAIL SHELL" at:88];
        [self print:@"IS THIS THAT WE CALL MAN?" at:126];
        [self print:@"YOUR ADVENTURE IS OVER" at:529];

        [self drawScreen];
>>>>>>> origin/master

        heartbeatCount = 0;
        player.stamina = 0;
        player.psiStrength = 0;
        player.comStrength = 0;
        isInCombat = NO;
        isGameInProgress = NO;

        [self updateStats];
    }
    else
    {
        // Player has the amulet and six stones, so is reincarnated

        theMessage.inputString = @"Alarian's Amulet protects thy soul...";
        theMessage.inputString = @"Live again!";

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

    if (player.helm == 1) theMessage.inputString = @"You have the Helm of Evanna... ";

    if (player.amulet == 1)
    {
        theMessage.inputString = @"You have the Amulet of Alarion...";

        if (player.amuletStones == 0)
        {
            theMessage.inputString = @"...but no Amulet Stones";
        }
        else
        {
            theMessage.inputString = [NSString stringWithFormat:@"...and %ld Amulet Stones", player.amuletStones];
        }

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
    theMessage.inputString = [NSString stringWithFormat:@"Your level is %@", charLevels[player.rating]];
}



- (IBAction)ego:(id)sender
{
    // Player is stroking his ego by checking on his rating
    // Can't do this while fighting

    if (isInCombat)
    {
        if (playerHasInitiative)
        {
            // Pressing E causes player to fumble the srike, so give the monster the initiative

            playerHasInitiative = NO;
            isMonstersTurn = YES;

            [self monsterAttacks];
        }

        return;
    }

    [self rating];

    // There's a cost to this

    player.stamina = player.stamina - 10;
    needToSave = YES;
}



#pragma mark - Movement Methods

- (IBAction)move:(id)sender
{
    if (!isGameInProgress) return;

    NSUInteger buttonValue = 0;

    if (sender == button1) buttonValue = 1;
    if (sender == button2) buttonValue = 2;
    if (sender == button3) buttonValue = 3;
    if (sender == button4) buttonValue = 4;
    if (sender == button5) buttonValue = 5;
    if (sender == button6) buttonValue = 6;
    if (sender == button7) buttonValue = 7;
    if (sender == button8) buttonValue = 8;
    if (sender == button9) buttonValue = 9;

#ifdef DEBUG
    if (buttonValue == 5) {
        [self death];
        return;
    }
#endif
    
    // Are we hitting one of the number keys during a fight?

    if (isInCombat)
    {
        targetTime = 0;

        if (playerHasInitiative)
        {
            // By pressing 1-9, the player fumbled the Attack or Retreat press,
            // so give the monster the initiative

            playerHasInitiative = NO;
            playerCastSpell = NO;
            isPlayersTurn = NO;
            isMonstersTurn = YES;

            // NOTE This is is the only time we go straight to monsterAttacks:
            // (because we've already paused the action while we wait for a key press)

            [self monsterAttacks];
        }

        if (playerCastSpell)
        {
            // The call to playerSpell: checks whether a spell has been cast
            // Number keys are valid in this case

            [self playerSpell:buttonValue];
        }

        if (isPlayersTurn)
        {
            // By pressing 1-9, the player fumbled a strike on the monster,
            // so give the monster the initiative

            isPlayersTurn = NO;
            isMonstersTurn = YES;

            // NOTE This is is the only time we go straight to monsterAttacks:
            // (because we've already paused the action while we wait for a key press)

            [self monsterAttacks];
        }

        return;
    }

    // Are we going up or down stairs?

    // Disable key presses while we process

    [self setKeysAndClicks:NO];

    // Is the player pressing 8 or 2 to go up or down stairs?

    if (stairsFlag)
    {
        if (buttonValue == 2 || buttonValue == 8)
        {
            stairsFlag = NO;
            tempFloor = floor;
            floor = floor + (buttonValue == 8 ? 1 : -1);

            if (floor > 7 || floor < 2)
            {
                theMessage.inputString = @"These stairs are blocked";
                floor = tempFloor;
                [self setKeysAndClicks:YES];
                return;
            }

            // Go to Scenario Control after 1 second to define and draw next floor

            fightTimer = [NSTimer timerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(scenarioControl)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer forMode:NSDefaultRunLoopMode];

            [self setKeysAndClicks:YES];
            return;
        }
    }

    // Calculate the location of square the player is about to enter

    switch (buttonValue)
    {
        case 1:
            nextPos = currentPos + 39;
            break;

        case 2:
            nextPos = currentPos + 40;
            break;

        case 3:
            nextPos = currentPos + 41;
            break;

        case 4:
            nextPos = currentPos - 1;
            break;

        case 5:
        default:
            nextPos = currentPos;
            break;

        case 6:
            nextPos = currentPos + 1;
            break;

        case 7:
            nextPos = currentPos - 41;
            break;

        case 8:
            nextPos = currentPos - 40;
            break;

        case 9:
            nextPos = currentPos - 39;
            break;
    }

    // Increase the number of turns

    player.turns++;
    needToSave = YES;

    // If the player is standing still, don't increase stamina etc.

    if (buttonValue == 5)
    {
        [self updateStats];
        [self setKeysAndClicks:YES];
        return;
    }

    player.stamina = player.stamina + 10;
    pokeCharacter = kGraphicCharacter;

    // What's in the square we're about to enter?

    nextPosContents = screen[nextPos];

    if (nextPosContents == kGraphicPathUp || nextPosContents == kGraphicPathDown)
    {
        // We're about to step on the path - that's OK, so make it so

        theMessage.inputString = @"Safe on the path... Which way?";
        screen[currentPos] = savedContents;
        savedContents = nextPosContents;
        currentPos = nextPos;
        screen[currentPos] = pokeCharacter;
        [self drawScreen];
        [self updateStats];
        [self setKeysAndClicks:YES];
        return;
    }

    if (nextPosContents == kGraphicSafeCastle)
    {
        theMessage.inputString = @"Thou art safe in a castle...";
        screen[currentPos] = savedContents;
        savedContents = nextPosContents;
        currentPos = nextPos;
        screen[currentPos] = pokeCharacter;
        [self drawScreen];

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

        if ([defaults boolForKey:@"le_Valley_Save_in_Castles"] == YES)
        {
            // Only allowed to save the game if we're in a castle

            theMessage.inputString = @"Wilt thou save your game? Here you may.";
        }
        else
        {
            theMessage.inputString = @"Thy wounds healed... thy sword sharp";
        }

        player.stamina = 150;
        if (player.comStrength < 20) player.comStrength = 20;

        theMessage.inputString = @"Go as the gods demand...trust no other";

        [self updateStats];
        [self setKeysAndClicks:YES];
        return;
    }

    if (nextPosContents == kGraphicBorder || nextPosContents == kGraphicWall || nextPosContents == kGraphicTree)
    {
        // Can't move on to these squares, so keep the player where he is and undo the move

        theMessage.inputString = @"That way is blocked, choose another path";
        player.turns--;
        player.stamina = player.stamina - 10;
        [self updateStats];
        [self setKeysAndClicks:YES];
        return;
    }

    if (nextPosContents == kGraphicWood || nextPosContents == kGraphicSwamp || nextPosContents == kGraphicTower)
    {
        // About to enter a new scenario from the Valley - we deal with preserving scenario locations there

        [self scenarioControl];
        return;
    }

    if (nextPosContents == kGraphicDoor || nextPosContents == kGraphicWoodBorder)
    {
        // About to quit a scenario

        // Check enough time has been spent before we quit

        if (player.turns < (scenarioTurnTime + arc4random_uniform((uint32_t)timeFactor)))
        {
            // Player hasn't played enough in the scenario so cancel the move

            theMessage.inputString = @"The way is barred, try again later";
            player.turns--;
            player.stamina = player.stamina - 10;
            [self updateStats];
            [self setKeysAndClicks:YES];
            return;
        }

        [self scenarioControl];
        return;
    }

    if (nextPosContents == kGraphicLake || (buttonValue == 5 && savedContents == kGraphicLake))
    {
        // Is the player staying put in the lake, or entering it?

        pokeCharacter = kGraphicCharInLake;
        player.stamina = player.stamina - 20;
        [self updateStats];
    }

    if (nextPosContents == kGraphicLair && savedContents != kGraphicLake)
    {
        // The player about to enter the Lair or Temple
        // We preserve the current position on the scenario routines

        [self scenarioControl];
        return;
    }

    if (nextPosContents == kGraphicLair && savedContents == kGraphicLake)
    {
        // Is the player trying to enter the Lair/Temple from the water? This is not allowed

        theMessage.inputString = @"You cannot enter the building this way";
        player.turns--;
        player.stamina = player.stamina - 10;
        [self updateStats];
        [self setKeysAndClicks:YES];
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
        [self setKeysAndClicks:YES];
        return;
    }

    if (nextPosContents == kGraphicStairLeft || nextPosContents == kGraphicStairRight)
    {
        // Climb stairs

        stairsFlag = YES;
        theMessage.inputString = @"A stairway...Up (8) or Down (2)?";
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
    [self updateStats];

    if (nextPosContents == kGraphicStairLeft || nextPosContents == kGraphicStairRight)
    {
        [self setKeysAndClicks:YES];
        return;
    }
    
    // Roll for a random find

    NSInteger roll = arc4random_uniform(100) + 1;

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

    theMessage.inputString = @"Nothing of value...search on";
    [self setKeysAndClicks:YES];
}



#pragma mark - Search methods

- (void)find
{
    [theMessage clearBuffer];

    NSInteger roll = arc4random_uniform(6) + 1;

    switch (roll)
    {
        case 1:
            theMessage.inputString = @"A Circle of Evil... Depart in haste!";
            player.stamina = player.stamina - 20;
            player.psiStrength = player.psiStrength - ((floor + 1) / 2);
            player.comStrength = player.comStrength + ((floor + 1) / 2);
            needToSave = YES;
            break;

        case 2:
        case 3:
            theMessage.inputString = @"A Hoard of Gold!";
            player.treasure = player.treasure + 100 + (floor * arc4random_uniform(100));
            needToSave = YES;
            break;

        case 4:
        case 5:
            theMessage.inputString = @"You feel the aura of deep magic...";
            theMessage.inputString = @"...all around you";
            player.psiStrength = player.psiStrength + 2 + (floor * player.psiGain);
            player.comStrength = player.comStrength + 1 + (floor * player.comGain);
            player.stamina = player.stamina + 25;
            needToSave = YES;
            break;

        case 6:
            theMessage.inputString = @"A place of ancient power!";
            player.psiStrength = player.psiStrength + 2 + (floor * player.psiGain);
            player.comStrength = player.comStrength + 1 + (floor * player.comGain);
            player.stamina = player.stamina + 25;
            needToSave = YES;
            break;
    }

    // Wait for 1.5 seconds before displaying next message

    fightTimer = [NSTimer timerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(postFind)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)postFind
{
    theMessage.inputString = @"Your move...Which direction?";

    [self setKeysAndClicks:YES];
    [self updateStats];
}



- (void)specialFind
{
    NSInteger roll = arc4random_uniform(100) + 1;

    if (currentScenario == kScenarioLair && roll > 95 && player.amuletStones == 6 && player.helm == 0 && player.rating > 25)
    {
        player.helm = 1;
        player.treasure = player.treasure + 100 * (player.amulet + player.amuletStones + player.helm + floor);
        theMessage.inputString = @"You find the Helm of Evanna!";
        needToSave = YES;

        fightTimer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(postFind)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    if (currentScenario == kScenarioTemple && roll > 85 && player.amulet == 0)
    {
        player.amulet = 1;
        player.treasure = player.treasure + 100 * (player.amulet + player.amuletStones + player.helm + floor);
        theMessage.inputString = @"You find the Amulet of Alarian...";
        needToSave = YES;

        fightTimer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(amuletEmpty)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    if (currentScenario == kScenarioTower && roll > 70 && player.amulet == 1 && player.amuletStones < 6 && floor > player.amuletStones)
    {
        theMessage.inputString = @"You find an amulet stone...";

        if (roll > 85)
        {
            player.amuletStones++;
            player.treasure = player.treasure + 100 * (player.amulet + player.amuletStones + player.helm + floor);
            theMessage.inputString = @"...and the stone fits!";

            fightTimer = [NSTimer timerWithTimeInterval:1.5
                                                 target:self
                                               selector:@selector(amuletStoneFits)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                         forMode:NSDefaultRunLoopMode];
        }
        else
        {
            theMessage.inputString = @"...but the wrong one...";

            fightTimer = [NSTimer timerWithTimeInterval:1.5
                                                 target:self
                                               selector:@selector(amuletStoneDoesntFit)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                         forMode:NSDefaultRunLoopMode];
        }

        needToSave = YES;
        return;
    }

    if (roll > 43)
    {
        theMessage.inputString = @"A worthless bauble";
    }
    else
    {
        theMessage.inputString = @"A precious stone!";
        needToSave = YES;
        player.treasure = player.treasure + 100 * (player.amulet + player.amuletStones + player.helm + floor);
    }

    fightTimer = [NSTimer timerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(postFind)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)amuletStoneFits
{
    theMessage.inputString = @"...and the stone fits!";

    fightTimer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(postFind)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)amuletStoneDoesntFit
{
    theMessage.inputString = @"...but the wrong one...";

    fightTimer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(postFind)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)amuletEmpty
{
    theMessage.inputString = @"...empty!";

    fightTimer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(postFind)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



#pragma mark - Monster and Combat Methods

- (void)announceMonster
{
    // Announce the appearance of a monster - this is the preliminary round of combat

    [self setKeysAndClicks:NO];

    [theMessage clearBuffer];

    theMessage.inputString = @"Beware... thou hast encountered...";

    // Assume the monster will strike first, to prevent mis-keys

    isInCombat = YES;
    isMonstersTurn = NO;
    isPlayersTurn = NO;
    playerHasInitiative = NO;
    monsterWasHitHard = NO;

    // Wait 1.5 seconds before announcing the monster's type

    fightTimer = [NSTimer timerWithTimeInterval: 1.5
                                         target: self
                                       selector: @selector(chooseMonster)
                                       userInfo: nil
                                        repeats: NO];

    [[NSRunLoop currentRunLoop] addTimer: fightTimer
                                 forMode: NSDefaultRunLoopMode];
}



- (void)chooseMonster
{
    // Randomly roll a monster based on location
    // This is called 1.5 seconds after we announce the player is in combat

    NSInteger rolledFiend = 0;
    BOOL monsterSelected = NO;

    while (!monsterSelected)
    {
        // Roll 0-16 for the monster

        NSInteger rollOne = arc4random_uniform(17);

        // Roll a percentage

        NSInteger rollTwo = arc4random_uniform(100) + 1;

        if (rollOne < 10)
        {
            // Rolled a not-particularly-nasty monster

            rolledFiend = rollOne;

            // If the player is in water, roll a water-living creature (17-18)

            if (nextPosContents == kGraphicLake) rolledFiend = arc4random_uniform(2) + 17;

            // Check that the creature is available to select

            NSRange result = [scenarioMonsterTypes rangeOfString:monsterCode[rolledFiend]];
            if (result.location != NSNotFound) monsterSelected = YES;
        }
        else
        {
            // One of the nasty creatures rolled, but only select it on a further 15% chance

            if (rollTwo > 85)
            {
                rolledFiend = rollOne;

                NSRange result = [scenarioMonsterTypes rangeOfString:monsterCode[rolledFiend]];
                if (result.location != NSNotFound) monsterSelected = YES;

                // Reject a Balrog except in all but 5% of the time

                if (rolledFiend == 16 && rollTwo < 75) monsterSelected = NO;

                // Reject a Ring Wraith on floor levels 0-4

                if (rolledFiend == 15 && floor < 5) monsterSelected = NO;
            }
        }
    }

    monsterCombatStrength = monsterStrength[rolledFiend] == 0 ? 0 : (player.comStrength * 0.3) + (monsterStrength[rolledFiend] * pow(floor, 0.2) / ([self random] + 1));
    monsterCombatPsi = monsterPsi[rolledFiend] == 0 ? 0 : monsterPsi[rolledFiend] * pow(floor, 0.2) / ([self random] + 1);
    experienceGain = (rolledFiend + 1) * pow(floor, 1.5);

    theMessage.inputString = [@"...an evil " stringByAppendingString:monsterName[rolledFiend]];

    // Display monster details in UI

    monsterNameView.inputString = monsterName[rolledFiend];
    monsterNameView.hidden = NO;
    monsterGraphic.hidden = NO;
    monsterStrengthView.inputValue = monsterCombatStrength == 0 ? monsterCombatPsi : monsterCombatStrength;
    monsterStrengthView.hidden = NO;

    // Check to see if the player has surprised the monster

    if ((arc4random_uniform(100) + 1) >= 60)
    {
        // Give the player the initiative on a 40% chance
        // Wait 1.0 seconds before asking the player to strike

        fightTimer = [NSTimer timerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(managePlayerInitiative)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    [self launchMonsterAttack];
}


#pragma mark Monster Combat Methods


- (void)launchMonsterAttack
{
    // The provides a short pause before the monster strikes
    // Wait 1.3 seconds before processing monster's attack

    isMonstersTurn = YES;

    fightTimer = [NSTimer timerWithTimeInterval:1.3
                                         target:self
                                       selector:@selector(monsterAttacks)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)monsterAttacks
{
    if (!isMonstersTurn) return;

    [self setKeysAndClicks:NO];

    // Announce the attack

    theMessage.inputString = @"The creature attacks...";

    // Wait 1.3 seconds before calculatiung the strike

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
    // Post delay routine to continue the monster's attack

    if (!isMonstersTurn) return;

    // The monster hasn't got a body, so it must use magic - launch a psi attack
    // If the Monster is corporeal,it may make a psi attack anyway if its Combat Strength falls below its Psi Strength

    if (monsterCombatStrength == 0 || (monsterCombatStrength < monsterCombatPsi && monsterCombatPsi > 6 && [self random] < 0.5))
    {
        [self monsterPsiAttack];
        return;
    }

    // All physical strikes cost stamina

    monsterCombatStrength = monsterCombatStrength - 1;

    if (monsterCombatStrength < 1)
    {
        // The monster wears itself out

        theMessage.inputString = @"...using its last energy in the attempt";

        player.experience = player.experience + (experienceGain / 2);
        isInCombat = NO;
        isMonstersTurn = NO;
        [self updateStats];

        // Wait 1.5 seconds then end combat

        fightTimer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(postFind)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    monsterStrengthView.inputValue = monsterCombatStrength;

    NSInteger roll = ([self random] * 10) + 1;
    float outcome = 0;

    switch (roll)
    {
        case 1:
            theMessage.inputString = @"It swings at you and misses";
            break;

        case 2:
            theMessage.inputString = @"Your blade deflects the blow";
            break;

        case 3:
            theMessage.inputString = @"...but hestitates, unsure...";
            break;

        case 4:
            theMessage.inputString = @"It strikes your head!";
            outcome = 3;
            break;

        case 5:
        case 6:
            theMessage.inputString = @"Your chest is struck!";
            outcome = 1.5;
            break;

        case 7:
        case 8:
            theMessage.inputString = @"A strike to your swordarm!";
            outcome = 1;
            break;

        case 9:
            theMessage.inputString = @"A blow to your body!";
            outcome = 1.3;
            break;

        case 10:
            theMessage.inputString = @"It catches your legs!";
            outcome = 0.5;
            break;

        default:
            break;
    }

    if (roll > 3)
    {
        // Calculate damage done to player

        float experienceFactor = player.experience == 0 ? 39 * log(1) / 3.14 : 39 * log(player.experience) / 3.14;
        float floatcalc = (((monsterCombatStrength * 75 * [self random]) - (10 * player.comStrength) - experienceFactor) / 100);
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

    // The monster missed so now it's the players turn

    [self launchPlayerAttack];
    return;
}



- (void)monsterDoesDamage
{
    // Get the damage caused during the momnster's physical strike

    NSInteger damage = gVariable;

    if (damage < 1)
    {
        // No damage done

        theMessage.inputString = ([self random] < 0.6) ? @"Saved by your armour!" : @"Shaken... but no damage done";

        // Now it's the player's turn to attack

        [self launchPlayerAttack];
        return;
    }

    theMessage.inputString = [NSString stringWithFormat:@"You take %ld damage", damage];
    player.stamina = player.stamina - damage;

    if (player.stamina < 1)
    {
        // The player is dead

        isGameInProgress = NO;
        isMonstersTurn = NO;
        isInCombat = NO;
        needToSave = NO;

        player.stamina = 0;

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

    // A mighty blow, so do extra damage to the player's ability to fight

    if (damage > 9) player.comStrength = player.comStrength - (damage / 9);

    needToSave = YES;

    [self updateStats];

    // Now it's the player's turn to attack

    [self launchPlayerAttack];
}



- (void)monsterPsiAttack
{
    // The creature launches a mental attack

    if (!isMonstersTurn) return;

    theMessage.inputString = @"...hurling a lightning bolt at you!";

    // Wait 1.3 seconds then process monster Psi attack

    fightTimer = [NSTimer timerWithTimeInterval:1.3
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

    float experienceFactor = player.experience == 0 ? 39 * log(1) / 3.14 : 39 * log(player.experience) / 3.14;
    NSInteger damage = (((180 * monsterCombatPsi * [self random]) - (player.psiStrength + experienceFactor)) / 100);
    monsterCombatPsi = monsterCombatPsi - 5;

    // If the psi attack does extra damage, the monster takes a greater hit

    if (damage > 9) monsterCombatPsi = monsterCombatPsi - (damage / 5);

    if (monsterCombatPsi < 1)
    {
        // The creatures tires itself out

        isInCombat = NO;
        isMonstersTurn = NO;
        playerCastSpell = NO;
        playerHasInitiative = NO;
        isPlayersTurn = NO;

        theMessage.inputString = @"...using its last energy in the attempt";
        monsterCombatPsi = 0;

        player.experience = player.experience + (experienceGain / 2);

        // Call updateStats: to remove the monster stats readout
        
        [self updateStats];

        // Wait 1.5 seconds then end combat

        fightTimer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(postFind)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    monsterStrengthView.inputValue = monsterCombatStrength == 0 ? monsterCombatPsi : monsterCombatStrength;

    if ([self random] < 0.25)
    {
        // Missed!

        theMessage.inputString = @"Missed you!";

        // Player's turn again

        [self launchPlayerAttack];
        return;
    }

    if (damage < 1)
    {
        // No damage done

        theMessage.inputString = @"Your Psi shield protects you!";

        // Now it's the player's turn to attack

        [self launchPlayerAttack];
        return;
    }

    theMessage.inputString = @"It strikes home!";
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



- (void)monsterPsiDamage
{
    // Post-delay routine to present monster's psi attack damage

    NSInteger damage = gVariable;

    player.stamina = player.stamina - damage;

    if (damage > 9) player.psiStrength = player.psiStrength - (damage / 4);

    theMessage.inputString = [NSString stringWithFormat:@"You take %ld damage", (long)damage];

    if (player.stamina < 1)
    {
        // Player is dead

        isGameInProgress = NO;
        isMonstersTurn = NO;
        isInCombat = NO;
        needToSave = NO;

        player.stamina = 0;

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

    needToSave = YES;

    [self updateStats];

    // Now it's the player's turn to attack

    [self launchPlayerAttack];
}



#pragma mark Player Intiative Methods


- (void)managePlayerInitiative
{
    // Player has the initiative

    [self setKeysAndClicks:YES];
    theMessage.inputString = @"You have surprise... Attack or Retreat?";
    playerHasInitiative = YES;

    // Player has 2 seconds to use their advantage by hitting A or R

    targetTime = heartbeatCount + 2;
}



- (IBAction)attack:(id)sender
{
    if (!isInCombat) return;

    // Only worry about this routine if we're checking for surprise results
    // otherwise it will count as a fumble

    targetTime = 0;

    if (playerHasInitiative)
    {
        playerHasInitiative = NO;
        isMonstersTurn = NO;

        // We've already played out a <2 seconds pre-strike pause while waiting
        // for the player to attack or retreat, so go straight to the player's
        // strike routine

        [self playerFight];
    }
}



- (IBAction)retreat:(id)sender
{
    if (!isInCombat) return;

    // Only worry about this routine if we're checking for surprise results
    // otherwise it will count as a fumble

    targetTime = 0;

    if (playerHasInitiative)
    {
        playerHasInitiative = NO;
        isMonstersTurn = NO;
        isInCombat = NO;
        monsterWasHitHard = NO;
        playerCastSpell = NO;

        theMessage.inputString = @"Knavish coward!";

        // Call updateStats: to clear the monster stats readout

        [self updateStats];

        // Wait 1.5 seconds then end combat

        fightTimer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(postFind)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];
    }
}



- (void)launchPlayerAttack
{
    // Wait 1.5 seconds before asking the player to strike

    isMonstersTurn = NO;

    fightTimer = [NSTimer timerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(playerFight)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



#pragma mark Player Combat Methods


- (void)playerFight
{
    // Tell the player it's time to attempt a hit

    if (isMonstersTurn) return;

    theMessage.inputString = @"Strike Quickly!";

    [self setKeysAndClicks:YES];

    isPlayersTurn = YES;

    // Player now has 3 seconds in which to choose Head, Body or Legs to hit (via strike:)

    targetTime = heartbeatCount + 3;
}



- (void)timeIsUp:(NSTimer*)theTimer
{
    // We come here when the player fails to hit H, B or L during an attack period

    targetTime = 0;

    if (isInCombat && (isPlayersTurn || playerHasInitiative || playerCastSpell))
    {
        // The player didn't press a key in time

        isPlayersTurn = NO;
        playerHasInitiative = NO;
        playerCastSpell = NO;
        monsterWasHitHard = NO;

        theMessage.inputString = @"Too slow!";

        // It's the monster's turn now, no matter what

        if (!isMonstersTurn) [self launchMonsterAttack];
    }
}



- (IBAction)strike:(id)sender
{
    if (!isInCombat || isMonstersTurn) return;

    targetTime = 0;
    isPlayersTurn = NO;

    if (playerHasInitiative)
    {
        // By pressing H< B or L, the player fumbled the Attack or Retreat press,
        // so give the monster the initiative

        playerHasInitiative = NO;
        isMonstersTurn = YES;

        [self monsterAttacks];
        return;
    }

    [self setKeysAndClicks:NO];

    float experienceFactor = player.experience == 0 ? 39 * log(1) / 3.14 : 39 * log(player.experience) / 3.14;

    if (monsterCombatStrength == 0)
    {
        // The monster is ethereal and can't be hit by swords - only spells

        theMessage.inputString = @"Your sword avails you nought here.";
        [self launchMonsterAttack];
        return;
    }

    // Spend a point of stamina to make the strike

    player.stamina = player.stamina - 1;

    if (player.stamina < 1)
    {
        // The player died making a final attack

        isGameInProgress = NO;
        isInCombat = NO;
        isMonstersTurn = NO;
        needToSave = NO;

        player.stamina = 0;

        theMessage.inputString = @"You fatally exhaust yourself.";

        fightTimer = [NSTimer timerWithTimeInterval:3
                                             target:self
                                           selector:@selector(death)
                                           userInfo:nil
                                            repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                     forMode:NSDefaultRunLoopMode];

        return;
    }

    [self updateStats];

    needToSave = YES;
    NSInteger roll = [self random] * 10;
    float outcome = 0.0;

    // Set the outcome according to which button was pressed and how successful was the hit

    if (sender == cButtonH && (roll < 5 || player.comStrength > monsterCombatStrength * 4)) outcome = 2.0;
    if (sender == cButtonB && (roll < 7 || player.comStrength > monsterCombatStrength * 4)) outcome = 1.0;
    if (sender == cButtonL && (roll < 9 || player.comStrength > monsterCombatStrength * 4)) outcome = 0.3;

    if (outcome == 0)
    {
        // The player missed the monster

        theMessage.inputString = @"You missed it.";
        monsterWasHitHard = NO;

        [self launchMonsterAttack];
        return;
    }

    NSInteger damage;

    if (monsterWasHitHard)
    {
        // Hit the monster really hard last strike? Do enough damage to finish it off now

        damage = monsterCombatStrength + 1 + ([self random] * 9);
        monsterWasHitHard = NO;
    }
    else
    {
        float floatcalc = (((player.comStrength * 50 * [self random]) - (10 * monsterCombatStrength) + experienceFactor) / 100);
        damage = floatcalc * outcome;

        if (damage < 0) damage = 0;
        if (player.comStrength > (monsterCombatStrength - damage) * 4) monsterWasHitHard = YES;
    }

    if (damage == 0)
    {
        // Didn't hurt the monster

        theMessage.inputString = @"A hit... but no damage";
        monsterWasHitHard = NO;

        [self launchMonsterAttack];
        return;
    }

    monsterCombatStrength = monsterCombatStrength - damage;
    if (monsterCombatStrength < 0) monsterCombatStrength = 0;
    monsterStrengthView.inputValue = monsterCombatStrength;

    theMessage.inputString = [NSString stringWithFormat:@"A hit... %ld damage...", (long)damage];

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

        isInCombat = NO;
        monsterWasHitHard = NO;
        isMonstersTurn = NO;
        needToSave = YES;

        theMessage.inputString = @"...killing the monster";

        player.experience = player.experience + experienceGain;

        // Call updateStats: to clear the

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

    if (monsterWasHitHard)
    {
        // The monster was hit so hard, it is stunned

        theMessage.inputString = [NSString stringWithFormat:@"The %@ staggers, defeated", monsterNameView.inputString];

        // The player gets a quick second hit attempt

        [self launchPlayerAttack];
        return;
    }

    // All things being equal, if we're here, it's the monster's turn to fight

    [self launchMonsterAttack];
}



- (IBAction)castSpell:(id)sender
{
    // The player has hit 'S' to cast a magic spell

    if (!isInCombat || isMonstersTurn) return;

    targetTime = 0;

    if (playerHasInitiative)
    {
        // By pressing S, the player fumbled the Attack or Retreat press,
        // so give the monster the initiative


        playerHasInitiative = NO;
        isPlayersTurn = NO;
        isMonstersTurn = YES;

        // NOTE This is is the only time we go straight to monsterAttacks:
        // (because we've already paused the action while we wait for a key press)

        [self monsterAttacks];
        return;
    }

    theMessage.inputString = @"Which spell seek ye?";
    playerCastSpell = YES;
    isPlayersTurn = NO;

    // Set up a four-second timer and add it to the main run loop.
    // We will cancel it if the player presses a key before the time is up

    targetTime = heartbeatCount + 4;
}



- (void)playerSpell:(NSInteger)keyValue
{
    // Ignore input if we're not in combat or haven't just tried to cast a spell

    if (!isInCombat || !playerCastSpell) return;

    playerCastSpell = NO;

    // Get the result of the spell

    spellCast = [self magic:keyValue];
    if (4 * player.psiStrength * [self random] <= monsterCombatPsi) spellCast = 7;

    // Wait three seconds before announcing result of spell

    fightTimer = [NSTimer timerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(spellOutcome)
                                       userInfo:nil
                                        repeats:NO];

    [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                 forMode:NSDefaultRunLoopMode];
}



- (void)spellOutcome
{
    NSInteger damage;

    switch (spellCast)
    {
        case 1:
            theMessage.inputString = @"Success!";
            player.experience = player.experience + (experienceGain / 2);

            isInCombat = NO;
            isMonstersTurn = NO;
            playerHasInitiative = NO;
            isPlayersTurn = NO;
            playerCastSpell = NO;

            // Wait 1.5 seconds then see what's what

            fightTimer = [NSTimer timerWithTimeInterval:1.5
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
            break;

        case 3:
            theMessage.inputString = @"There is no such spell!";
            break;

        case 4:
            theMessage.inputString = @"It is beyond you!";
            break;

        case 5:
            theMessage.inputString = @"The spell saps your strength!";

            isGameInProgress = NO;
            isInCombat = NO;
            isMonstersTurn = NO;
            needToSave = NO;

            player.stamina = 0;

            fightTimer = [NSTimer timerWithTimeInterval:3
                                                 target:self
                                               selector:@selector(death)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                         forMode:NSDefaultRunLoopMode];

            return;
            break;

        case 6:
            theMessage.inputString = @"...but the spell fails!";
            break;

        case 7:
            theMessage.inputString = @"The beast's Psi shields it!";
            break;

        case 8:
            damage = gVariable;
            theMessage.inputString = [NSString stringWithFormat:@"The Psi-Lance causes %ld damage", (damage * 2)];

            monsterCombatPsi = monsterCombatPsi - (3 * damage);
            if (monsterCombatPsi < 1) monsterCombatPsi = 0;

            monsterCombatStrength = monsterCombatStrength - damage;
            if (monsterCombatStrength < 1) monsterCombatStrength = 0;

            if (monsterCombatStrength + monsterCombatPsi > 0) break;

            theMessage.inputString = @"...killing the creature";
            player.experience = player.experience + experienceGain;

            isInCombat = NO;
            isMonstersTurn = NO;
            playerHasInitiative = NO;
            isPlayersTurn = NO;
            playerCastSpell = NO;

            // Wait 1.5 seconds then see what's what

            fightTimer = [NSTimer timerWithTimeInterval:1.5
                                                 target:self
                                               selector:@selector(postFind)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                         forMode:NSDefaultRunLoopMode];

            return;
            break;

        case 9:
            damage = gVariable;
            theMessage.inputString = [NSString stringWithFormat:@"Crispit causes %ld damage", (damage * 2)];

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

            if ((monsterCombatStrength + monsterCombatPsi) > 0) break;

            theMessage.inputString = @"...killing the creature";
            player.experience = player.experience + experienceGain;

            isInCombat = NO;
            isMonstersTurn = NO;
            playerHasInitiative = NO;
            isPlayersTurn = NO;
            playerCastSpell = NO;

            // Wait 1.5 seconds then see what's what

            fightTimer = [NSTimer timerWithTimeInterval:1.5
                                                 target:self
                                               selector:@selector(postFind)
                                               userInfo:nil
                                                repeats:NO];

            [[NSRunLoop currentRunLoop] addTimer:fightTimer
                                         forMode:NSDefaultRunLoopMode];

            return;
            break;
    }

    // The monster is still alive, so it is its turn to attack

    [self launchMonsterAttack];
}



- (NSInteger)magic:(NSInteger)keyValue
{
    float roll;
    float experienceFactor = 39 * log(player.experience) / 3.14;

    NSInteger damage;
    NSInteger outcome = 0;

    switch (keyValue)
    {
        case kSpellSleep:
            player.stamina = player.stamina - 5;

            if (player.stamina < 1)
            {
                // Player dies attempting to cast the spell

                outcome = 5;
                break;
            }

            needToSave = YES;

            [theMessage clearBuffer];
            theMessage.inputString = @"Sleep, foul fiend, that I may escape";
            [self midLineDelay:1.0];
            theMessage.inputString = @"and preserve my miserable skin";

            // Roll success on 50% and up

            outcome = arc4random_uniform(100) < 50 ? 6 : 1;
            break;

        case kSpellPsilance:
            if (player.experience < 1000 || monsterCombatStrength > player.stamina || player.psiStrength < 49)
            {
                // Not able to cast this one

                outcome = 4;
                break;
            }

            player.stamina = player.stamina - 10;

            if (player.stamina < 1)
            {
                // Player dies attempting to cast the spell

                outcome = 5;
                break;
            }

            if (monsterCombatPsi == 0)
            {
                // The monster must have Psi for this to work

                outcome = 2;
                break;
            }

            [theMessage clearBuffer];
            theMessage.inputString = @"With my mind I battle thee for my life!";
            needToSave = YES;

            roll = [self random];

            if (roll < 0.4 && monsterCombatPsi > 10)
            {
                outcome = 6;
                break;
            }


            damage = ((((player.comStrength * 50 * roll) - 5 * (monsterCombatStrength + monsterCombatPsi) + experienceFactor) / 50) / 4);

            if (damage < 1)
            {
                damage = 0;
                outcome = 7;
                break;
            }

            gVariable = damage;
            outcome = 8;
            break;

        case kSpellCrisp:
            if (player.experience < 5000 || player.psiStrength < 77)
            {
                // Not able to cast this one

                outcome = 4;
                break;
            }

            player.stamina = player.stamina - 20;

            if (player.stamina < 1)
            {
                // Player dies attempting to cast the spell

                outcome = 5;
                break;
            }

            [theMessage clearBuffer];
            theMessage.inputString = @"With the might of my sword I smite thee";
            [self midLineDelay:1.0];
            theMessage.inputString = @"With the power of my spell I curse thee";
            [self midLineDelay:1.0];
            theMessage.inputString = @"Burn ye spawn of Hell and suffer...";

            needToSave = YES;

            roll = [self random];

            if (roll > (player.psiStrength / 780) * (5 - player.psiGain))
            {
                // Not able to cast this one

                outcome = 4;
                break;
            }

            damage = ((player.comStrength + player.psiStrength * [self random])) - (10 * monsterCombatPsi * (arc4random_uniform(10) + 1) * 0.1);

            if (damage < 1)
            {
                damage = 0;
                outcome = 7;
                break;
            }

            gVariable = damage;
            outcome = 9;
            break;

        default:
            outcome = 3;
    }

    return outcome;
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
            if (roomDepth[i] != 5) flag = YES;
        }
        while (!flag);
    }

    towerFloor[2] = [self random] * 30 + 1;

    // If we're leaving the Valley for another scenario, save the player's position in the Valley

    if (currentScenario == kScenarioValley) valleyPos = currentPos;

    // Record the time spent in the scenario

    scenarioTurnTime = player.turns;

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
            [self scenarioValley];
            break;

        case kScenarioSwamp:
        case kScenarioWoods:
            [self scenarioWoods];
            break;

        case kScenarioTower:
            if (floor == 2) theMessage.inputString = @"Prepare to enter.... the Dark Tower...";
            [self scenarioTower];
            break;

        case kScenarioLair:
        case kScenarioTemple:
            [self scenarioTemple];
            break;

        default:
            break;
    }

    [self updateStats];
    [self setKeysAndClicks:YES];
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
        savedContents = kGraphicSafeCastle;
    }

    // Draw the Valley path

    for (NSUInteger i = 0 ; i < 75 ; i = i + 2) screen[valleyPath[i]] = valleyPath[i + 1];

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
    }
    else
    {
        scenarioMonsterTypes = @"FAEHL";
        pokeCharacter = kGraphicTree;
        theMessage.inputString = @"You step under the cover of the Forest canopy...";
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
    // Random y co-ord : 0-9 multplied by 40 to get the correct row

    a = (1 + arc4random_uniform(6)) * 40;

    // Random x co-ord: 0-26 added to the current row

    a = a + (towerFloor[2] > 0 ? towerFloor[2] : towerFloor[2] + 2);

    NSUInteger tempPos = a;

    // Draw the lake

    NSInteger pokeLocations[26] = {0, 1, 39, 40, 41, 42, 43, 78, 79, 82, 83, 84, 118, 119, 122, 123, 124, 159, 160, 161, 162, 164, 165, 201, 202, 242};

    for (NSUInteger i = 0 ; i < 26 ; ++i)
    {
        a = pokeLocations[i];
        if (tempPos + a < 561) screen[tempPos + a] = kGraphicLake;
    }

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
        theMessage.inputString = @"interior of the Temple...";
    }
    else
    {
        theMessage.inputString = @"You slowly step into Vounim's Lair...";
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

                if (i == 3) pokeCode = kGraphicSpaceAlt;
                screen[(tempPos + roomWidth[1] + roomWidth[2])] = pokeCode;
                pokeCode = kGraphicTowerBorder;

                // Place door in third vertical wall

                if (i == 4) pokeCode = kGraphicSpaceAlt;
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

                    screen[tempPos + k] = kGraphicSpaceAlt;
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
        screen[a] = a == 481 ? kGraphicStairLeft : kGraphicStairRight;
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
        BOOL flag = NO;

        do {
            roll1 = [self random] * 19;
            roll2 = [self random] * 12;

            if (screen[(1 + (40 * roll2) + roll1)] == kGraphicSpace)
            {
                // Place a treasure item on an empty space

                screen[(1 + (40 * roll2) + roll1)] = kGraphicTreasure;
                flag = YES;
            }
        }
        while (!flag);
    }

    [self drawScreen];
}



#pragma mark Menu Methods

- (IBAction)newChar:(id)sender
{
    // Add game in progress / unsaved char warning

    if (isInCombat) return;

    if (isGameInProgress)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"You have a game in progress"];
        [alert setInformativeText:@"Are you sure you want to end the current game and begin a new one?"];
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];

        [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == 1000) [self showNewPlayerSheet];
        }];

        return;
    }

    [self showNewPlayerSheet];
}



- (void)showNewPlayerSheet
{
    isGameInProgress = NO;
    newProfession = -1;

    playerPicView.wantsLayer = YES;
    playerPicView.layer.borderColor = [NSColor whiteColor].CGColor;
    playerPicView.layer.borderWidth = 2.0;

    newPlayerWindow.backgroundColor = [NSColor blackColor];

    [_window beginSheet:newPlayerWindow completionHandler:nil];
}



- (IBAction)saveCharSheet:(id)sender
{
    // Hide the sheet

    [_window endSheet:newPlayerWindow];

    player = [[Character alloc] init];
    player.name = playerNameReadout.stringValue;

    if (playerNameReadout.stringValue.length == 0 || [playerNameReadout.stringValue hasPrefix:@" "]) player.name = @"Mungo";
    
    if (newProfession != -1)
    {
        playerNameView.inputString = [NSString stringWithFormat:@"%@ the %@", player.name, newProf];
        player.comStrength = newComStrength;
        player.psiStrength = newPsiStrength;
        player.profession = newProfession;
        player.stamina = newStamina;
        player.comGain = newCombatGain;
        player.psiGain = newPsiGain;
    }
    else
    {
        playerNameView.inputString = [NSString stringWithFormat:@"%@ the Dolt", player.name];
        player.comStrength = 20;
        player.psiStrength = 20;
        player.profession = kCharDolt;
        player.stamina = 113;
        player.comGain = 1.0;
        player.psiGain = 1.0;
    }

    // Update the info display

    [self updateStats];

    [self initGameVariables];

    // Set up one-second heartbeat

    heartbeatCount = 0;

    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(heartbeat)
                                   userInfo:nil
                                    repeats:YES];

    isGameInProgress = YES;
    needToSave = YES;

    // It's a new game, so go straight to the Valley

    currentScenario = kScenarioValley;
    floor = 1;

    [self setKeysAndClicks:YES];
    [self scenarioValley];
}


- (IBAction)cancelCharSheet:(id)sender
{
    [_window endSheet:newPlayerWindow];
}


- (IBAction)setProfession:(id)sender
{
    if (sender == bWizard)
    {
        newProfession = kCharWizard;
        newComStrength = 22;
        newPsiStrength = 28;
        newStamina = 100;
        newProf = @"Wizard";
        newCombatGain = 0.5;
        newPsiGain = 2.0;
        playerPicView.image = [NSImage imageNamed:@"figure_wizard"];
    }

    if (sender == bWarrior)
    {
        newProfession = kCharWarrior;
        newComStrength = 26;
        newPsiStrength = 24;
        newStamina = 113;
        newProf = @"Warrior";
        newCombatGain = 1.25;
        newPsiGain = 1.0;
        playerPicView.image = [NSImage imageNamed:@"figure_warrior"];
    }

    if (sender == bThinker)
    {
        newProfession = kCharThinker;
        newComStrength = 24;
        newPsiStrength = 26;
        newStamina = 113;
        newProf = @"Thinker";
        newCombatGain = 0.75;
        newPsiGain = 1.5;
        playerPicView.image = [NSImage imageNamed:@"figure_thinker"];
    }

    if (sender == bBarbarian)
    {
        newProfession = kCharBarbarian;
        newComStrength = 28;
        newPsiStrength = 22;
        newStamina = 125;
        newProf = @"Barbarian";
        newCombatGain = 2.0;
        newPsiGain = 0.5;
        playerPicView.image = [NSImage imageNamed:@"figure_barbarian"];
    }

    if (sender == bCleric)
    {
        newProfession = kCharCleric;
        newComStrength = 25;
        newPsiStrength = 25;
        newStamina = 113;
        newCombatGain = 1.0;
        newPsiGain = 1.25;
        newProf = @"Cleric";
        playerPicView.image = [NSImage imageNamed:@"figure_cleric"];
    }
}



- (IBAction)showAboutSheet:(id)sender
{
    // Centre aboutBox within main app window (assumes fixed sizes)

    [_window beginSheet:aboutSheet completionHandler:nil];
}



- (IBAction)closeAboutSheet:(id)sender
{
    [_window endSheet:aboutSheet];
}



#pragma mark Save and Load Methods

// Save As... File Menu item

- (IBAction)saveDocument:(id)sender
{
    if (!needToSave || !isGameInProgress || isInCombat) return;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"le_Valley_Save_in_Castles"] == YES)
    {
        if (currentScenario != kScenarioValley || nextPosContents != kGraphicSafeCastle)
        {
            // Can't save mid-game - you have to return to the safe castle

            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"You can't save your game here";
            alert.informativeText = @"You can't save the game unless you enter one of the Valley's two Safe Castles, at either end of the safe path. This can be disabled in the Preferences.";
            [alert addButtonWithTitle:@"OK"];
            [alert beginSheetModalForWindow:_window completionHandler:nil];
            return;
        }
    }

    [self doSave];
}



- (void)doSave
{
    if (savedfilePath != nil)
    {
        // We have saved this file already, so no need to re-present the dialog

        player.cPos = currentPos;
        player.tPos = positionBeforeLair;
        player.vPos = valleyPos;
        player.scenario = currentScenario;
        player.saveSquare = savedContents;
        player.floor = floor;

        player.places0 = places[0];
        player.places1 = places[1];
        player.places2 = places[2];
        player.places3 = places[3];
        player.places4 = places[4];

        for (NSUInteger i = 0 ; i < 78 ; ++i) [player.valleyPath addObject:[NSNumber numberWithInteger:valleyPath[i]]];

        // Create a character model to save

        Character *saveChar = [player copy];
        BOOL result = [NSKeyedArchiver archiveRootObject:saveChar toFile:savedfilePath];

        if (!result)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *path = [savedfilePath stringByAppendingString:@"_tmp"];
            result = [NSKeyedArchiver archiveRootObject:saveChar toFile:path];
            [fileManager removeItemAtPath:savedfilePath error:nil];
            [fileManager copyItemAtPath:path toPath:savedfilePath error:nil];
            [fileManager removeItemAtPath:path error:nil];
        }

        saveChar = nil;

        needToSave = NO;
    }
    else
    {
        // No saved file location, so get one

        [self saveDocumentAs:nil];
    }
}



- (IBAction)saveDocumentAs:(id)sender
{
    if (!isInCombat)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"le_Valley_Save_in_Castles"] == YES)
        {
            // Can't save mid-game - you have to return to the safe castle

            if (currentScenario != kScenarioValley || nextPosContents != kGraphicSafeCastle)
            {
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"You can't save your game here";
                alert.informativeText = @"You can't save the game unless you enter on of the Valley's two Safe Castles. This can be disable in the Preferences.";
                [alert addButtonWithTitle:@"OK"];
                [alert beginSheetModalForWindow:_window completionHandler:nil];
                return;
            }
        }

        __block NSSavePanel *saveDialog = [NSSavePanel savePanel];

        [saveDialog setMessage:@"Choose a folder..."];
        [saveDialog setCanCreateDirectories:YES];
        [saveDialog setNameFieldStringValue:[player.name stringByAppendingString:@".valcr"]];

        [saveDialog beginSheetModalForWindow:_window
                           completionHandler:^(NSInteger result)
         {
             if (result == NSModalResponseOK)
             {
                 // Close sheet first and stop it hogging the event queue

                 NSURL *fileURL = [saveDialog URL];
                 savedfilePath = fileURL.path;
                 [self doSave];
             }

             saveDialog = nil;
         }];
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"You are in combat.";
        alert.informativeText = @"You can't save a game while your character is fighting.";
        [alert addButtonWithTitle:@"OK"];
        [alert beginSheetModalForWindow:_window completionHandler:nil];
    }
}



- (IBAction)openDocument:(id)sender
{
    if (!isInCombat)
    {
        if (isGameInProgress)
        {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"You have a game in progress";
            alert.informativeText = @"Are you sure you want to end the current game and open a different one?";
            [alert addButtonWithTitle:@"Yes"];
            [alert addButtonWithTitle:@"No"];

            [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse returnCode) {
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
        [alert beginSheetModalForWindow:_window completionHandler:nil];
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
         if (result == NSModalResponseOK)
         {
             // Close sheet first and stop it hogging the event queue

             [NSApp stopModal];
             [NSApp endSheet:openDialog];
             [openDialog orderOut: self];

             // Send URLs to be added to table and sync'd

             //[[openDialog URLs] count];
             NSString *path = [[[openDialog URLs] objectAtIndex:0] path];
             [self openFileHandler:path];
         }

         openDialog = nil;
     }];
}


- (void)openFileHandler:(NSString *)path
{
    Character *loadChar = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    if (loadChar != nil)
    {
        player = loadChar;
        nextPosContents = 0;

        currentPos = player.cPos;
        positionBeforeLair = player.tPos;
        valleyPos = player.vPos;
        currentScenario = player.scenario;
        savedContents = player.saveSquare;
        floor = player.floor;

        places[0] = player.places0;
        places[1] = player.places1;
        places[2] = player.places2;
        places[3] = player.places3;
        places[4] = player.places4;

        for (NSUInteger i = 0 ; i < 78 ; ++i)
        {
            NSNumber *n = [player.valleyPath objectAtIndex:i];
            valleyPath[i] = n.integerValue;
        }

        // Set up one-second heartbeat

        heartbeatCount = 0;

        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(heartbeat)
                                       userInfo:nil
                                        repeats:YES];

        isGameInProgress = YES;
        loadFlag = YES;
        needToSave = NO;

        // Write the player's name

        playerNameView.inputString = [NSString stringWithFormat:@"%@ the %@", player.name, [self setProfString:player.profession]];

        [theMessage clearBuffer];
        theMessage.inputString = @"Your adventure continues...";

        // Update the info display

        [self updateStats];

        // Load in the currently running scenario

        [self scenarioControl];

        loadChar = nil;
        savedfilePath = path;
    }
}



- (NSString *)setProfString:(NSInteger)index
{
    switch (index)
    {
        case kCharWizard:
            return @"Wizard";

        case kCharThinker:
            return @"Thinker";

        case kCharBarbarian:
            return @"Barbarian";

        case kCharWarrior:
            return @"Warrior";

        case kCharCleric:
            return @"Cleric";

        default:
            return @"Dolt";
    }
}



#pragma mark Prefs Menu Methods

- (IBAction)prefsPanel:(id)sender
{
    // Bail if there's a fight in progress

    if (isInCombat) return;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    // Set window elements according to the Defaults values

    prefsAsciiCheckbox.state = [defaults boolForKey:@"le_Valley_Ascii_Graphics"] == YES ? NSOnState : NSOffState;
    prefsSaveCheckbox.state = [defaults boolForKey:@"le_Valley_Save_in_Castles"] == YES ? NSOnState : NSOffState;
    prefsSoundCheckbox.state = [defaults boolForKey:@"le_Valley_Do_Sounds"] == YES ? NSOnState : NSOffState;

    // Roll out the Preferences sheet

    [_window beginSheet:prefsSheet completionHandler:nil];
}



- (IBAction)prefsSheetCancel:(id)sender

{
    // User has clicked on the Delete sheet's Cancel button

    [_window endSheet:prefsSheet];
}



- (IBAction)prefsSheetSave:(id)sender

{
    // User has clicked on the Delete sheet's OK-to-delete button

    [_window endSheet:prefsSheet];

    // Tidies up after the Prefs sheet is closed

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    // Apply the new preferences to Defaults based on window element settings

    [defaults setBool:([prefsAsciiCheckbox state] == NSOnState) forKey:@"le_Valley_Ascii_Graphics"];
    [defaults setBool:([prefsSaveCheckbox state] == NSOnState) forKey:@"le_Valley_Save_in_Castles"];
    [defaults setBool:([prefsSoundCheckbox state] == NSOnState) forKey:@"le_Valley_Do_Sounds"];
    [defaults synchronize];

    // Make sure we enable/disable sounds as required by the user

    [self setSounds:([prefsSoundCheckbox state] == NSOnState)];
}



#pragma mark - Utility Methods

- (float)random
{
    // Returns a float between 0.01 and 1

    float roll = arc4random_uniform(100);
    return roll / 100;
}



- (void)setKeysAndClicks:(BOOL)state
{
    _window.enableKeys = state;

    if (isInCombat)
    {
        _window.enableKeys = state;

        cButtonB.enableClicks = state;
        cButtonH.enableClicks = state;
        cButtonL.enableClicks = state;
        cButtonS.enableClicks = state;

        button9.enableClicks = NO;
        button8.enableClicks = NO;
        button7.enableClicks = NO;
        button6.enableClicks = NO;
        button5.enableClicks = NO;
        button4.enableClicks = NO;
    }
    else
    {
        button9.enableClicks = state;
        button8.enableClicks = state;
        button7.enableClicks = state;
        button6.enableClicks = state;
        button5.enableClicks = state;
        button4.enableClicks = state;
        button3.enableClicks = state;
        button2.enableClicks = state;
        button1.enableClicks = state;
    }
}



- (void)setSounds:(BOOL)state
{
    NSSound *clickSound = state ? [NSSound soundNamed:@"click"] : nil;

    button9.sound = clickSound;
    button8.sound = clickSound;
    button7.sound = clickSound;
    button6.sound = clickSound;
    button5.sound = clickSound;
    button4.sound = clickSound;
    button3.sound = clickSound;
    button3.sound = clickSound;
    button1.sound = clickSound;

    cButtonB.sound = clickSound;
    cButtonH.sound = clickSound;
    cButtonL.sound = clickSound;
    cButtonS.sound = clickSound;

    oButtonA.sound = clickSound;
    oButtonR.sound = clickSound;
    oButtonE.sound = clickSound;
}

@end
