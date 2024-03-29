//
//  Common.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Car.h"
#import "Bonus.h"

#define SCALE 0.4f

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define MAX_CHECKPOINTS 50
#define MAX_BONUSES 50
#define CHP_NAME @"Checkpoint"
#define BNS_NAME @"SpawnObject"
#define TRP_NAME @"Tramplin"
#define OIL_NAME @"oilSpot"
#define HEAL_NAME @"healingPoint"
#define LAPS_CNT 1
#define TRAMPLIN_TAG 3000
#define OILSPOT_TAG 3001
#define HEAL_TAG 3002
#define WALL_TAG 3003
#define CAR_TAG 1990
#define WEAPON_TAG 2000
//#define ROCKET_TAG 2001
//#define MACHINEGUN_TAG 2002

#define SECONDS_TILL_BONUS 3.0f

#define NONE_STRING @"none"

enum game_type { GT_RACE, GT_FREERIDE };

//enum _entityCategory {
//
//    CB_BOUNDARY        =   0x0001,
//    CB_MY_CAR          =   0x0002,
//    CB_ENEMY_CAR       =   0x0004,
//    CB_MY_ROCKET       =   0x0008,
//    CB_ENEMY_ROCKET    =   0x0010,
//};

@interface Common : NSObject {
    
    CGPoint chp[MAX_CHECKPOINTS];
    int chp_cnt;
    CGPoint bns[MAX_BONUSES];
    BOOL bns_occup[MAX_BONUSES];
    int bns_cnt;
    
    NSMutableSet* remove_objects;
    NSDictionary* cd_params;
    NSDictionary* bonus_params;
    NSDictionary* details_order;
    NSDictionary* details;
//    NSDictionary* pl_beavis;
//    NSDictionary* players;
//    NSMutableDictionary* players_ref;
    NSDictionary* jeep_corr;
    NSDictionary* gonkawhite_corr;
    NSMutableDictionary* bodies_ref;
    NSMutableArray* bonuses;

    NSMutableDictionary* profiles;
    NSString* prof_file;
    
    int detail;
}

+ (Common*) instance;
- (CGPoint) getMapObjectPos:(NSString*) name;
- (CGPoint) ort2iso:(CGPoint) pos;
- (CGPoint) iso2ort:(CGPoint) pos;
- (CGPoint) getCheckpointPos:(int) c;
- (int) getCheckpointCnt;
- (void) putBonuses;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (BOOL) bum:(CGPoint) p;
- (void) markObjectForDelete:(CCNode*)obj;
- (void) deleteMarkedObjects;
- (int) getCDCount;
- (NSString*) getCDParam: (int)n;
- (int) getBonusParam: (NSString*)n;
- (NSString*) getDetail:(NSString*)key number:(int)num; 
- (int) getDetailCnt:(NSString*)key;
//- (NSString*) getBeaParam: (NSString*)n player_index: (int)ind;
- (NSString*) getCarParamForSelectedProfile: (NSString*)n;
- (NSString*) getBodyParam: (NSString*)n forBody:(NSString*)bo;
- (NSMutableArray*) getBonuses;
- (int) profilesCnt;
- (NSDictionary*) getProfile: (int) n;
- (NSDictionary*) getTempProfile;
- (void) setProfile: (NSMutableDictionary*) d for:(int) n;
- (void) createProfile: (NSDictionary*) d;
- (NSDictionary*) getSelectedProfile;
- (void) setSelectedProfile: (NSMutableDictionary*) d;

@property (assign, readwrite) CGPoint direction;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic) b2World* world;
@property (assign, readwrite) int laps;
@property (assign, readwrite) int laps_cnt;
@property (assign, readwrite) int gametype;
@property (nonatomic, retain) CCLayer* gamescene;
@property (assign, readwrite) BOOL heal;
@property (assign, readwrite) BOOL machinegun;
@property (assign, readwrite) BOOL started;
@property (assign, readwrite) int cntCD;
@property (assign, readwrite) int enemiesCnt;
@property (nonatomic, retain) NSString* mapType;
@property (nonatomic, retain) NSMutableSet* enemies;
@property (assign, readwrite) int camera;
@property (nonatomic, retain) Car* me;
@property (nonatomic, retain) NSDictionary* w_machinegun;
@property (nonatomic, retain) NSDictionary* w_spearthrower;
@property (nonatomic, retain) NSDictionary* w_rear_machinegun;
@property (nonatomic, retain) NSDictionary* w_flamethrower;

@property (assign, readwrite) int selProfile;

@end
