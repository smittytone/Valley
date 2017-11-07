

// macOS software © Tony Smith 2012-17, based on work
// by by Henry Budget, Peter Freebrey, Peter Green and Ron Harris.
// Originally published by Computing Today
// magazine in its April 1982 issue.


#import <Cocoa/Cocoa.h>


@interface Character : NSObject <NSCoding>


@property (strong) NSString *name;
@property (assign) NSInteger profession;
@property (assign) NSInteger stamina;
@property (assign) NSInteger experience;
@property (assign) NSInteger rating;
@property (assign) NSInteger treasure;
@property (assign) NSInteger psiStrength;
@property (assign) NSInteger comStrength;

@property (assign) NSInteger amulet;
@property (assign) NSInteger amuletStones;
@property (assign) NSInteger helm;
@property (assign) NSInteger item3;

@property (assign) NSInteger turns;
@property (assign) NSInteger saveSquare;
@property (assign) NSInteger scenario;
@property (assign) NSInteger vPos;
@property (assign) NSInteger tPos;
@property (assign) NSInteger cPos;
@property (assign) NSInteger floor;

@property (assign) NSInteger places0;
@property (assign) NSInteger places1;
@property (assign) NSInteger places2;
@property (assign) NSInteger places3;
@property (assign) NSInteger places4;

@property (strong) NSMutableArray *valleyPath;


@end
