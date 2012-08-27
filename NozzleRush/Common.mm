//
//  Common.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "RaysCastCallback.h"
#import "QueryCallback.h"
#import "RemBonus.h"
#import "SpeedBonus.h"
#import "GunPowerBonus.h"
#import "SlowEnemyBonus.h"
#import "FightDenyBonus.h"
#import "AddWeaponBonus.h"
#import "BulletTimeBonus.h"

@implementation Common

@synthesize direction;
@synthesize tileMap = _tileMap;
@synthesize world;
@synthesize laps, laps_cnt/*, checkpoint, distToChp*/;
@synthesize gametype;
@synthesize gamescene;
@synthesize heal;
@synthesize machinegun;
//@synthesize enemy, me;
@synthesize started;
@synthesize cntCD;
@synthesize enemies;
@synthesize enemiesCnt;
@synthesize mapType;
//@synthesize myLife;
@synthesize camera;
@synthesize me;

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
            
		}
	}
	return instance;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    
//    int x = position.x / self.tileMap.tileSize.width;
//    int y = ((self.tileMap.mapSize.height * self.tileMap.tileSize.height) - position.y) / self.tileMap.tileSize.height;
//    return ccp(x, y);
    
    float halfMapWidth = self.tileMap.mapSize.width * 0.5f;
    float mapHeight = self.tileMap.mapSize.height;
    float tileWidth = self.tileMap.tileSize.width;
    float tileHeight = self.tileMap.tileSize.height;
    
    CGPoint tilePosDiv = CGPointMake(position.x / tileWidth, position.y / tileHeight);
    float inverseTileY = mapHeight - tilePosDiv.y;
    
    float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
    float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);
    
    return ccp(posX, posY);
}

- (CGPoint) getMapObjectPos:(NSString*) name {
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    
    NSMutableDictionary *spawnPoint = [objects objectNamed:name];        
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    
    float x = [[spawnPoint valueForKey:@"x"] integerValue];
    float y = [[spawnPoint valueForKey:@"y"] integerValue];

    return ccp(x, y);
}

- (int) getCheckpointCnt {
    
    return chp_cnt;
}

//- (int) getBonusesCnt {
//    
//    if (bns_cnt > 0)
//        return bns_cnt;
//    
//    [self doBonuses];
//    
//    return bns_cnt;
//}

- (CGPoint) getCheckpointPos:(int) c {
    
    if(chp_cnt > 0)
        return [self ort2iso: chp[c]];
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found 1");
    
    chp_cnt = 0;
    NSMutableDictionary *sp;
    do {

        NSString* s = [NSString stringWithFormat:@"%@%d", CHP_NAME, (chp_cnt + 1)];
        sp = [objects objectNamed:s];        
        if(sp != nil) {
            
            float x = [[sp valueForKey:@"x"] integerValue];
            float y = [[sp valueForKey:@"y"] integerValue];
            chp[chp_cnt++] = ccp(x, y); 
//            NSLog(@"Checkpoint%d x = %f, y = %f", chp_cnt, x, y);
        }
        
    } while (sp != nil);

    if (chp_cnt > 0)
        return [self ort2iso: chp[c]];

    return ccp(0, 0);
}

- (NSMutableArray*) getBonuses {
    
    return bonuses;
}

- (void) putBonuses {

//    NSLog(@"putBonuses");
    
    if (bns_cnt == 0)
        [self doBonuses];
    
    int bmax = bns_cnt / 3;
    
    NSMutableArray *to_delete = [[NSMutableArray alloc] init];
    for (Bonus* bb in bonuses)
        if(bb.forDelete) {
            bns_occup[bb.spawnPoint] = NO;
//            [bonuses removeObject:bb];
            [to_delete addObject:bb];
            [bb release];
        }
    
    [bonuses removeObjectsInArray:to_delete];
    [to_delete release];
    
    while ([bonuses count] < bmax) {
        
        float b1 = CCRANDOM_0_1() * [self getBonusParam:@"RemontWeight"];
        int c = 1; float cc = b1;
        
        float b2 = CCRANDOM_0_1() * [self getBonusParam:@"SpeedWeight"];
        if (b2 > cc) { cc = b2; c = 2; }

        float b3 = CCRANDOM_0_1() * [self getBonusParam:@"GunPowerWeight"];
        if (b3 > cc) { cc = b3; c = 3; }

        float b4 = CCRANDOM_0_1() * [self getBonusParam:@"SlowEnemyWeight"];
        if (b4 > cc) { cc = b4; c = 4; }

        float b5 = CCRANDOM_0_1() * [self getBonusParam:@"AddWeaponWeight"];
        if (b5 > cc) { cc = b5; c = 5; }

        float b6 = CCRANDOM_0_1() * [self getBonusParam:@"FightDenyWeight"];
        if (b6 > cc) { cc = b6; c = 6; }

        float b7 = CCRANDOM_0_1() * [self getBonusParam:@"BulletTimeWeight"];
        if (b7 > cc) { cc = b7; c = 7; }
        
        b2PolygonShape shape;
//        int num = 4;
//        b2Vec2 vertices[] = {
//            b2Vec2(1.0f, 1.0f),
//            b2Vec2(1.0f, -1.0f),
//            b2Vec2(-1.0f, -1.0f),
//            b2Vec2(-1.0f, 1.0f),
//        };
//        
//        shape.Set(vertices, num);
        shape.SetAsBox(1.0f, 1.0f);

        int bp = -1;
        while (bp < 0) {

            int i = CCRANDOM_0_1() * bns_cnt;
//            NSLog(@"        CCRANDOM_0_1() %d, %d", bns_cnt, i);
            if (!bns_occup[i]) {
                bp = i;
                bns_occup[i] = YES;
            }
        }
        
        NSLog(@"Bonus type %d selected!", c);
        
        switch (c) {

            default:
            case 1:
                [bonuses addObject:[[RemBonus alloc]initWithShape:shape X:bns[bp].x Y:bns[bp].y spawn:bp]];
                break;
            case 2:
                [bonuses addObject:[[SpeedBonus alloc]initWithShape:shape X:bns[bp].x Y:bns[bp].y spawn:bp]];
                break;
            case 3:
                [bonuses addObject:[[GunPowerBonus alloc]initWithShape:shape X:bns[bp].x Y:bns[bp].y spawn:bp]];
                break;
            case 4:
                [bonuses addObject:[[SlowEnemyBonus alloc]initWithShape:shape X:bns[bp].x Y:bns[bp].y spawn:bp]];
                break;
            case 5:
                [bonuses addObject:[[AddWeaponBonus alloc]initWithShape:shape X:bns[bp].x Y:bns[bp].y spawn:bp]];
                break;
            case 6:
                [bonuses addObject:[[FightDenyBonus alloc]initWithShape:shape X:bns[bp].x Y:bns[bp].y spawn:bp]];
                break;
            case 7:
                [bonuses addObject:[[BulletTimeBonus alloc]initWithShape:shape X:bns[bp].x Y:bns[bp].y spawn:bp]];
                break;
        }

    }
    
}

- (void) doBonuses {

    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found 2");
    
    bns_cnt = 0;
    NSMutableDictionary *sp;
    do {
        
        NSString* s = [NSString stringWithFormat:@"%@%d", BNS_NAME, (bns_cnt + 1)];
        sp = [objects objectNamed:s];
        if(sp != nil) {
            
            float x = [[sp valueForKey:@"x"] integerValue];
            float y = [[sp valueForKey:@"y"] integerValue];
            bns[bns_cnt++] = ccp(x, y);

            NSLog(@"Bonus%d x = %f, y = %f", bns_cnt, x, y);
        }
        
    } while (sp != nil);

}

//
//- (CGPoint) getBonusPos:(int) c {
//    
//    if(bns_cnt > 0)
//        return [self ort2iso: bns[c]];
//    
//    [self doBonuses];
//        
//    if (bns_cnt > 0)
//        return [self ort2iso: bns[c]];
//    
//    return ccp(0, 0);
//}

- (BOOL) bum:(CGPoint) p {
  
//    NSLog(@"bum x = %f, %f, %f y = %f, %f, %f", p.x, [self.enemy getGroundPosition].x, fabs(p.x-[self.enemy getGroundPosition].x), p.y, [self.enemy getGroundPosition].y, fabs(p.y-[self.enemy getGroundPosition].y));
 
    
//    for(Car* enemy in self.enemies)
//        if(fabs((p.x-[enemy getGroundPosition].x) < 30) && (fabs(p.y-[enemy getGroundPosition].y) < 30))
//            return YES;    
    
//    RaysCastCallback callback;
//    CGPoint ort = [self iso2ort:p];
//    b2Vec2 eye = b2Vec2(ort.x / PTM_RATIO, ort.y / PTM_RATIO);
//    b2Vec2 eye1 = b2Vec2((ort.x + 100) / PTM_RATIO, (ort.y + 100) / PTM_RATIO);
//    [Common instance].world->RayCast(&callback, eye, eye1);    
//    if (callback.m_fixture) {
//        
//        b2Body* body = callback.m_fixture->GetBody();
//        CCNode* n = (CCNode*)body->GetUserData();
//        if(n.tag == CAR_TAG) {
//            
//            if( ((Car*)n).typ != CT_ME)
//                return YES;
//            
//        }
//    }

    CGPoint ort = [self iso2ort:p];
    b2Vec2 eye = b2Vec2(ort.x / PTM_RATIO, ort.y / PTM_RATIO);
    b2AABB aabb;
	b2Vec2 d = b2Vec2(0.001f, 0.001f);
	aabb.lowerBound = eye - d;
	aabb.upperBound = eye + d;
    
	// Query the world for overlapping shapes.
	QueryCallback callback(eye);
	world->QueryAABB(&callback, aabb);
    
	if (callback.m_fixture) {
        
        b2Body* body = callback.m_fixture->GetBody();
        CCNode* n = (CCNode*)body->GetUserData();
//        NSLog(@"!!! %d", n.tag);
        if(n.tag == CAR_TAG) {
            
            if( ((Car*)n).typ == CT_ME)
                return NO;
            
        }
        
        return YES;
    }
    
    return NO;
}

-(void) initPhysics {
    
    //	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	self.world = new b2World(gravity);
	// Do we want to let bodies sleep?
	self.world->SetAllowSleeping(true);
//	self.world->SetContinuousPhysics(true);
        
}

- (id) init {	
	
	self = [super init];
	if(self !=nil) {
 
        [self initPhysics];
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"moon_dim_dif3_4.tmx"];
//        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"moon_dim_dif2_10.tmx"];
        
        chp_cnt = -1;
        
        mapType = @"MOON";
        
        remove_objects = [[NSMutableSet alloc] init];
        
        self.enemies = [[NSMutableSet alloc] init];
        
		NSString *appFile = [[NSBundle mainBundle] pathForResource:@"countdown" ofType:@"plist"];
		cd_params = [[NSDictionary alloc] initWithContentsOfFile:appFile];

		NSString *appFile1 = [[NSBundle mainBundle] pathForResource:@"bonus" ofType:@"plist"];
		bonus_params = [[NSDictionary alloc] initWithContentsOfFile:appFile1];
        
		NSString *order_file = [[NSBundle mainBundle] pathForResource:@"order1" ofType:@"plist"];
        details_order = [[NSDictionary alloc] initWithContentsOfFile:order_file];
        detail = 0;

		NSString *plbeav_file = [[NSBundle mainBundle] pathForResource:@"pl_beavis" ofType:@"plist"];
        pl_beavis = [[NSDictionary alloc] initWithContentsOfFile:plbeav_file];
        
		NSString *players_file = [[NSBundle mainBundle] pathForResource:@"players1" ofType:@"plist"];
        players = [[NSDictionary alloc] initWithContentsOfFile:players_file];

        players_ref = [[NSMutableDictionary alloc] init];
        [players_ref setObject:pl_beavis forKey:@"beavis"];

		NSString *jeep_file = [[NSBundle mainBundle] pathForResource:@"jeep" ofType:@"plist"];
        jeep_corr = [[NSDictionary alloc] initWithContentsOfFile:jeep_file];

        bodies_ref = [[NSMutableDictionary alloc] init];
        [bodies_ref setObject:jeep_corr forKey:@"jeep"];
        
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(putBonuses) userInfo:nil repeats:YES];
        
        
        bonuses = [[NSMutableArray alloc] init];
    }
	return self;	
}

- (NSString*) getBeaParam: (NSString*)n player_index: (int)ind {
    
//	NSString *s = [pl_beavis objectForKey:n];
//	return s;
    
    NSString* s = [players objectForKey:[NSString stringWithFormat:@"pl_%02d",ind]];
    NSDictionary* d = [players_ref objectForKey:s];
    NSString *s1 = [d objectForKey:n];
    
    return s1;

}

- (NSString*) getBodyParam: (NSString*)n forBody:(NSString*)bo {
    
	NSDictionary* d = [bodies_ref objectForKey:bo];
    NSString *s = [d objectForKey:n];
	return s;
}

- (NSString*) getNextDetail:(NSString*)key {
    
    NSString* s = [details_order objectForKey:key];
    if (detail * 3 >= s.length) {
        
        detail = 0;
        return nil;
    }
	NSString* s1 = [s substringWithRange:NSMakeRange(detail * 3, 2)];
    detail++;
    return s1;
    
}

- (NSString*) getDetail:(NSString*)key number:(int)num {
    
    NSString* s = [details_order objectForKey:key];
	NSString* s1 = [s substringWithRange:NSMakeRange(num * 3, 2)];
    return s1;
    
}

- (int) getDetailCnt:(NSString*)key {

    NSString* s = [details_order objectForKey:key];
    return [s length]/3;
}


- (int) getCDCount { //CD - CountDown

	return [cd_params count];
    
}

- (NSString*) getCDParam: (int)n {
    
	NSString *s = [cd_params objectForKey:[NSString stringWithFormat:@"msg%d", n]];
	return s;
}

- (int) getBonusParam: (NSString*)n {
    
	NSNumber* s = [bonus_params valueForKey:n];
	return [s intValue];
}

- (CGPoint) ort2iso:(CGPoint) pos {
    
//    CCTMXLayer* l = [[Common instance].tileMap layerNamed:@"BackBackgroundLayer"];
//    return [l positionForIsoAt:pos];
    
    float mapHeight = _tileMap.mapSize.height;
    float mapWidth = _tileMap.mapSize.width;
    float tileHeight = _tileMap.tileSize.height;
    float tileWidth = _tileMap.tileSize.width;
    float ratio = tileWidth / tileHeight;
    
    float x = tileWidth /2 * ( mapWidth + pos.x/(tileWidth / ratio) - pos.y/tileHeight);// + 0.49f;
    float y = tileHeight /2 * (( mapHeight * 2 - pos.x/(tileWidth / ratio) - pos.y/tileHeight) +1);// + 0.49f;
    return ccp(x / CC_CONTENT_SCALE_FACTOR(), (y - 0.5f * tileHeight) / CC_CONTENT_SCALE_FACTOR());
//    return ccp(x , (y - 0.5f * tileHeight) );
}

- (CGPoint) iso2ort:(CGPoint) pos {
    
    float mapHeight = _tileMap.mapSize.height;
    float mapWidth = _tileMap.mapSize.width;
    float tileHeight = _tileMap.tileSize.height;
    float tileWidth = _tileMap.tileSize.width;
    float ratio = tileWidth / tileHeight;
    
    float xx = pos.x * CC_CONTENT_SCALE_FACTOR();
    float yy = pos.y * CC_CONTENT_SCALE_FACTOR();
    float px1 = mapHeight * 2 - mapWidth + xx / tileWidth * 2 - yy / tileHeight * 2;
    float px = px1;// * CC_CONTENT_SCALE_FACTOR();
    float x = px / 2 * (tileWidth /ratio);
    float py = (mapWidth + px1 - xx / tileWidth * 2);// * CC_CONTENT_SCALE_FACTOR();
    float y = py * tileHeight - x;
    return ccp(x,y);
}

-(void) dealloc {
   
    [_tileMap release];
    
    delete world;
	world = NULL;

    [remove_objects release];
    
    [cd_params release];
    
    [details_order release];
    [pl_beavis release];
    [jeep_corr release];
    
    [players release];
    [players_ref release];
    
    [bodies_ref release];
    
    [bonuses release];
    
    [super dealloc];
}

- (void) markObjectForDelete:(CCNode*)obj {
    
    [remove_objects addObject:obj];
}

- (void) deleteMarkedObjects {
    
    for(CCNode* foo in remove_objects) {
        
        [foo release];
        foo = nil;
    }
    
    [remove_objects removeAllObjects];
    
    for (Bonus* bb in bonuses)
        if (bb.predie) {
            [bb preDie];
        }

}

@end
