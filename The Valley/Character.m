

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import "Character.h"


@implementation Character

@synthesize name, profession, turns, stamina, experience, treasure;
@synthesize comStrength, psiStrength, rating;
@synthesize tPos, vPos, cPos, valleyPath, floor, scenario, saveSquare;
@synthesize places0, places1, places2, places3, places4;
@synthesize amulet, amuletStones, helm, item3;



- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"tv_pcharName"];
    [coder encodeInteger:profession forKey:@"tv_pcharProf"];
    [coder encodeInteger:stamina forKey:@"tv_pcharStam"];
    [coder encodeInteger:experience forKey:@"tv_pcharExp"];
    [coder encodeInteger:rating forKey:@"tv_pcharRat"];
    [coder encodeInteger:treasure forKey:@"tv_pcharTres"];
    [coder encodeInteger:psiStrength forKey:@"tv_pcharPsiStr"];
    [coder encodeInteger:comStrength forKey:@"tv_pcharComStr"];
    [coder encodeInteger:amulet forKey:@"tv_pcharItem0"];
    [coder encodeInteger:amuletStones forKey:@"tv_pcharItem1"];
    [coder encodeInteger:helm forKey:@"tv_pcharItem2"];
    [coder encodeInteger:item3 forKey:@"tv_pcharItem3"];
    [coder encodeInteger:turns forKey:@"tv_pgameTurns"];
    [coder encodeInteger:saveSquare forKey:@"tv_pgameSaveSq"];
    [coder encodeInteger:scenario forKey:@"tv_pgameScene"];
    [coder encodeInteger:vPos forKey:@"tv_pgameVpos"];
    [coder encodeInteger:cPos forKey:@"tv_pgameCpos"];
    [coder encodeInteger:tPos forKey:@"tv_pgameTpos"];
    [coder encodeInteger:floor forKey:@"tv_pgameFloor"];
    [coder encodeInteger:places0 forKey:@"tv_pPlaces0"];
    [coder encodeInteger:places1 forKey:@"tv_pPlaces1"];
    [coder encodeInteger:places2 forKey:@"tv_pPlaces2"];
    [coder encodeInteger:places3 forKey:@"tv_pPlaces3"];
    [coder encodeInteger:places4 forKey:@"tv_pPlaces4"];
	[coder encodeObject:valleyPath forKey:@"tv_pVpath"];
}



- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    if (self)
    {
        name = [coder decodeObjectForKey:@"tv_pcharName"];
        profession = [coder decodeIntForKey:@"tv_pcharProf"];
        stamina = [coder decodeIntForKey:@"tv_pcharStam"];
        experience = [coder decodeIntForKey:@"tv_pcharExp"];
        rating = [coder decodeIntForKey:@"tv_pcharRat"];
        treasure = [coder decodeIntForKey:@"tv_pcharTres"];
        psiStrength = [coder decodeIntForKey:@"tv_pcharPsiStr"];
        comStrength = [coder decodeIntForKey:@"tv_pcharComStr"];
        amulet = [coder decodeIntForKey:@"tv_pcharItem0"];
        amuletStones = [coder decodeIntForKey:@"tv_pcharItem1"];
        helm = [coder decodeIntForKey:@"tv_pcharItem2"];
        item3 = [coder decodeIntForKey:@"tv_pcharItem3"];
        turns = [coder decodeIntForKey:@"tv_pgameTurns"];
        saveSquare = [coder decodeIntForKey:@"tv_pgameSaveSq"];
        scenario = [coder decodeIntForKey:@"tv_pgameScene"];
        vPos = [coder decodeIntForKey:@"tv_pgameVpos"];
        tPos = [coder decodeIntForKey:@"tv_pgameTpos"];
        cPos = [coder decodeIntForKey:@"tv_pgameCpos"];
        floor = [coder decodeIntForKey:@"tv_pgameFloor"];
        places1 = [coder decodeIntForKey:@"tv_pPlaces1"];
        places2 = [coder decodeIntForKey:@"tv_pPlaces2"];
        places3 = [coder decodeIntForKey:@"tv_pPlaces3"];
        places4 = [coder decodeIntForKey:@"tv_pPlaces4"];
        places0 = [coder decodeIntForKey:@"tv_pPlaces0"];
        valleyPath = [[coder decodeObjectForKey:@"tv_pVpath"] mutableCopy];
    }
    
    return self;
}



- (id)init
{
	self = [super init];
	if (self) valleyPath = [[NSMutableArray alloc] init];
	return self;
}


@end
