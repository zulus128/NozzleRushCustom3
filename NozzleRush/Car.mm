//
//  Car.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Car.h"
#import "Common.h"
#import "RaysCastCallback.h"
#import "MachParticleSystem.h"

@implementation Car
@synthesize body;
@synthesize target, target1, target2, eye, target3, target4;

@synthesize targetChp;

@synthesize jump;
@synthesize oil/*, heal*/;
@synthesize typ;
@synthesize diskname, wheelname;
@synthesize checkpoint;
@synthesize distToChp;
@synthesize life;
@synthesize speedKoeff;

- (id) initWithType:(int) type {
    
    if((self = [super init])) {				
        
        typ = type;
        
        speed = 1;
        
        self.life = 1;
        self.speedKoeff = 1;
        
        NSLog(@"car created");
        
        self.tag = CAR_TAG;
        rocket = nil;
        
        sprite = [CCSprite spriteWithFile:@"transparent.png"];
        [[Common instance].tileMap addChild:sprite z:0];   //corrected by Andrew Osipov 28.05.12
        

        sprite.scale = 0.5f / 2.1f;
        
        
        
//        for (int i = 0; i < SPRITES_CNT; i++) {
//
//            sprites[i] = [CCSprite spriteWithFile:@"jeep_NE.png"];
////            sprites[i] = [CCSprite spriteWithFile:@"transparent.png"];
////            sprites[i].scale = 0.5;
//            [sprite addChild:sprites[i] z:(-i)];
//            
//        }
        
//        [Common instance].direction = ccp(1,1);
        
        firsttime = YES;
        
        bodyDef.type = b2_dynamicBody;
        
        self.body = [Common instance].world->CreateBody(&bodyDef);
        self.body->SetLinearDamping(1.0f);
//        self.body->SetUserData(sprite);
        self.body->SetUserData(self);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        //        dynamicBox.SetAsBox(2.1f, 2.1f);
        dynamicBox.SetAsBox(1.0f, 1.0f);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.02f;
        //        fixtureDef.friction = 4.3f;
        
        if (typ == CT_ME) {

//            fixtureDef.filter.categoryBits = CB;
//            fixtureDef.filter.maskBits = maskBits;
            fixtureDef.filter.groupIndex = -1;
        }
        else {
            
        }
        
        self.body->CreateFixture(&fixtureDef);
        
        
        hdir = 1;

        emitter = [[CCParticleSmoke alloc] initWithTotalParticles:25];
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"smoke.png"];
        emitter.gravity = CGPointZero;
        emitter.posVar = CGPointZero;
        emitter.positionType = kCCPositionTypeRelative;
        emitter.emitterMode = kCCParticleModeRadius;
        [[Common instance].tileMap addChild:emitter z:-1];
        
        mach = [[MachParticleSystem alloc]initWithFile:@"mgun.plist"];
        
        //            mach = [[MachParticleSystem particleWithFile:@"machinegun.plist"] retain];
        mach.positionType = kCCPositionTypeRelative;
        [[Common instance].tileMap addChild:mach z:0];
        [mach stopSystem];

        expl = [[CCParticleExplosion alloc]initWithFile:@"em_ring_explosion.plist"];
        expl.position = ccp(0,0);
        [[Common instance].tileMap addChild:expl z:-1];
        [expl stopSystem];

        if (typ == CT_ME) {

            


//            mach = [[MachParticleSystem particleWithFile:@"mgun.plist"] retain];
            
            
            rocketFlame = [[CCParticleMeteor particleWithFile:@"rocketFlame.plist"] retain];
            rocketFlame.positionType = kCCPositionTypeRelative;
            [[Common instance].tileMap addChild:rocketFlame z:0];
//            [rocketFlame stopSystem];
        }
        
    }
    return self;
}

-(void) dealloc {

    [emitter release];

    if (typ == CT_ME)        
        [mach release];
    
    [super dealloc];
}

- (void) setPosX:(int)x Y:(int)y {

    CGPoint p = ccp(x, y);
    sprite.position = [[Common instance] ort2iso:p];
//    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    body->SetTransform(b2Vec2(x / PTM_RATIO, y / PTM_RATIO), 0);

    [[Common instance] getCheckpointPos:1];
    
    angle = 180;
    
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"jeep7.png"];
    [sprite setTexture: tex];

//    mach_angle = 315;
    //////////////////////////////////////////
    // - Changed by MSyasko on 28.06.2012 - //
    //////////////////////////////////////////
    mach_angle = 301; ////
    
    emitter.position = [[Common instance] ort2iso:p];

    if (typ == CT_ME)
        mach.position = [[Common instance] ort2iso:p];

}

- (CGPoint) getGroundPosition {
    
//    NSLog(@"hh = %d", hh);
//    return ccp(sprite.position.x, sprite.position.y - ((hh<0)?0:(hh>hmax?hmax:hh)));
    
    return groundPosition;
}

- (void) update {
   
    if (rocket != nil) {
        
        [rocket update];
        
        //        NSLog(@"vel = %f", rocket.body->GetLinearVelocity().Normalize());
        
        if ((rocket.body->GetLinearVelocity().Normalize() < 0.4) || rocket.died) {
            
            //            [rocket release];
            [[Common instance] markObjectForDelete:rocket];
            
            expl.position = rocket.sprite.position;

            rocket = nil;
            
            [expl resetSystem];
        }
        
//        rocketFlame.position = rocket.position;
        
    }
    
//    if(typ == CT_ME)
//    NSLog(@"%f",self.body->GetLinearVelocity().Normalize() );

    float ss =  self.body->GetLinearVelocity().Normalize();
    if(ss > 5)
        speed = 0;
    else
        if(ss > 1)
            speed = 1;
    else
        speed = 1000;
    
//    if(typ == CT_ME)
//        NSLog(@"%f, %f, %d", self.body->GetLinearVelocity().Normalize(), ss, speed );
    
    float rot = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
    
//    NSString* name1 = @"";
//    NSString* name2 = @"";
//    NSString* name3 = @"";
    NSString* rocketAngle = @"";
    int w1ZOrder = 2;
    CGPoint w1Position = ccp(0, 0);
    CGPoint w1MuzzlePosition = ccp(0, 0);
    float a = (rot < 0)?(360 + rot):rot;
    a = a + 22.5f;
    
//    int disk = DT_NONE;
//    id wanim = nil;
    
    CGPoint machCorr = ccp(0,0);
    
    float b = 0;
    float r = 0;
 
    NSString* direction = @"N";
    
    //    a = 250;
    //////////////////////////////////////////
    // - Changed by MSyasko on 28.06.2012 - //
    //////////////////////////////////////////
    if (a < 360.0f) {
        if (a < 315.0f) {
            if (a < 270.0f) {
                if (a < 225.0f) {
                    if (a < 180.0f) {
                        if (a < 135.0f) {
                            if (a < 90.0f) {
                                if (a < 45.0f) {
//                                    name1 = @"JeepWheels45Flip_1.png"; 
//                                    name2 = @"jeep7.png"; 
                                    direction = @"NE";

//                                    wanim = wheel45Flip;
                                    //                                    danim = diski45Flip;
//                                    disk = DT_45FLIP;
                                    //                                    b = 31/*45*/; 
                                    
                                    // First Weapon
//                                    name3 = @"mGun315.png";
                                    //                                    w1Position = ccp(-10, 27);  //на капоте
                                    w1Position = ccp(-30, 15);
                                    w1MuzzlePosition = ccp(0, 0);
                                    w1ZOrder = 1;
                                    
                                    // Secon Weapon
                                    rocketAngle = @"r315.png";
                                    
                                    b = 59;
                                    r = 90;
                                    machCorr = ccp(-21, 25);
                                    //                                    mach.rotation = 45;
                                } else {
//                                    name1 = @"JeepWheelsSide_1.png"; 
//                                    name2 = @"jeep4.png";
                                    direction = @"E";

//                                    wanim = wheelSide;
                                    //                                    danim = diskiSide;
//                                    disk = DT_SIDE;
                                    //                                    b = 0; 
                                    
                                    // First Weapon
//                                    name3 = @"mGun0.png";
                                    //                                    w1Position = ccp(17, 28);
                                    w1Position = ccp(-16, 27);
                                    w1MuzzlePosition = ccp(0, 0);
                                    w1ZOrder = 1;
                                    
                                    // Secon Weapon
                                    rocketAngle = @"r0.png";
                                    
                                    b = 90;
                                    r = 135;
                                    machCorr = ccp(-2, 32);

                                    //                                    mach.rotation = 0;
                                }
                            } else {
//                                name1 = @"JeepWheels45_1.png"; 
//                                name2 = @"jeep6.png"; 
                                direction = @"SE";

//                                wanim = wheel45;
                                //                                danim = diski45;
//                                disk = DT_45;
                                //                                b = -31/*-45*/;   
                                
                                // First Weapon
//                                name3 = @"mGun45.png";
                                //                                w1Position = ccp(31, 13); 
                                w1Position = ccp(5, 28);
                                w1MuzzlePosition = ccp(0, 0);
                                w1ZOrder = 1;
                                
                                // Secon Weapon
                                rocketAngle = @"r45.png";
                                
                                b = 121;
                                r = 180;
                                machCorr = ccp(16, 27);

                                //                                mach.rotation = 315;
                            }
                        } else {
//                            name1 = @"JeepWheels_1.png"; 
//                            name2 = @"jeep1.png"; 
                            direction = @"S";

//                            wanim = wheel;
                            //                            b = 270;  
                            
                            // First Weapon
//                            name3 = @"mGun90.png";
                            //                            w1Position = ccp(28, -3);
                            w1Position = ccp(27, 18);
                            w1MuzzlePosition = ccp(0, 0);
                            w1ZOrder = 2;
                            
                            // Secon Weapon
                            rocketAngle = @"r90.png";
                            
                            b = 180;
                            r = 225;
                            machCorr = ccp(-27, 20);

                            //                            mach.rotation = 270;
                        }
                    } else {
//                        name1 = @"JeepWheels45Flip_1.png"; 
//                        name2 = @"jeep8.png"; 
                        direction = @"SW";

//                        wanim = wheel45Flip;
                        //                        danim = diski45Flip;
//                        disk = DT_45FLIP;
                        //                        b = 212/*225*/; 
                        
                        // First Weapon
//                        name3 = @"mGun135.png";
                        //                        w1Position = ccp(7, -8);
                        w1Position = ccp(27, 10);
                        w1MuzzlePosition = ccp(0, 0);
                        w1ZOrder = 2;
                        
                        // Secon Weapon
                        rocketAngle = @"r135.png";
                        
                        b = 239;
                        r = 270;
                        machCorr = ccp(17, 9);

                        //                        mach.rotation = 225;
                    }
                } else {
//                    name1 = @"JeepWheelsSide_1.png"; 
//                    name2 = @"jeep3.png";
                    direction = @"W";

//                    wanim = wheelSide;
                    //                    danim = diskiSide;
//                    disk = DT_SIDE;
                    //                    b = 180;
                    
                    // First Weapon
//                    name3 = @"mGun180.png";
                    //                    w1Position = ccp(-18, -10);
                    w1Position = ccp(16, -3);
                    w1MuzzlePosition = ccp(3, 0);
                    w1ZOrder = 2;
                    
                    // Secon Weapon
                    rocketAngle = @"r180.png";
                    
                    b = 270;
                    r = 315;
                    machCorr = ccp(3, 0);

                    //                    mach.rotation = 180;
                } 
            } else {
//                name1 = @"JeepWheels45_1.png"; 
//                name2 = @"jeep5.png"; 
                direction = @"NW";

//                wanim = wheel45;
                //                danim = diski45;
//                disk = DT_45;
                //                b = 151/*135*/; 
                
                // First Weapon
//                name3 = @"mGun225.png";
                //                w1Position = ccp(-32, 10);
                w1Position = ccp(-7, -2);
                w1MuzzlePosition = ccp(-50, 50);
                w1ZOrder = 2;
                
                // Secon Weapon
                rocketAngle = @"r225.png";
                
                b = 301;
                r = 0;
                machCorr = ccp(-16, 7);

                //                mach.rotation = 135;
            }  
        } else {
//            name1 = @"JeepWheels_1.png"; 
//            name2 = @"jeep2.png"; 
            
            direction = @"N";
            
//            wanim = wheel;
            //            b = 90; 
            
            // First Weapon
//            name3 = @"mGun270.png";
            //            w1Position = ccp(-28, 13);
            w1Position = ccp(-26, 1);
            w1MuzzlePosition = ccp(0, 0);
            w1ZOrder = 2;
            
            // Secon Weapon
            rocketAngle = @"r270.png";
            
            b = 0;
            r = 45;
            machCorr = ccp(-26, 22);

            //            mach.rotation = 90;
        }              
    } else {
//        name1 = @"JeepWheels45Flip_1.png"; 
//        name2 = @"jeep7.png"; 
        direction = @"NE";

//        wanim = wheel45Flip;
        //        danim = diski45Flip;
//        disk = DT_45FLIP;
        //        b = 31/*45*/; 
        
        // First Weapon
//        name3 = @"mGun315.png";
        //        w1Position = ccp(-10, 27);
        w1Position = ccp(-30, 15);
        w1MuzzlePosition = ccp(0, 0);
        w1ZOrder = 1;
        
        // Secon Weapon
        rocketAngle = @"r315.png";
        
        b = 59;
        r = 90;
        machCorr = ccp(-2, 32);

        //        mach.angle = 45;
    }      
    
    // Set the proper sprite for a rocket
//    if (rocket != nil)
//        if (rocket.sprite.tag == 0) {
//            CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:rocketAngle];
//            NSLog(@"Angle = %@", rocketAngle);
//            [rocket.sprite setTexture:texture];
//            
//            rocket.sprite.tag = 1;
//        }
    
    if(bb != b)
        if(([Common instance].direction.x != 0) || ([Common instance].direction.y != 0) || (typ != CT_ME) || firsttime) {
            

            
            for (int i = 0; i < [[Common instance] getDetailCnt:direction]; i++) {


                NSString* str = [[Common instance] getDetail:direction number:i];
//                NSLog(@"str = %@", str);
                NSString* pl = [[Common instance] getBeaParam:str player_index:1];
//                NSLog(@"pl = %@", pl);
                NSString* add = @"";
//                if ([pl isEqualToString:@"disk"] || [pl isEqualToString:@"wheels"])
                NSString* s = @"WH,FR,FL,BR,BL";
                if ([s rangeOfString:str].location != NSNotFound)
                    add = @"_1";
                NSString* name1 = [NSString stringWithFormat:@"%@_%@%@.png", pl, direction, add];
//                NSLog(@"detail %d : %@", i, name1);
//                CCTexture2D* tex1 = [[CCTextureCache sharedTextureCache] addImage:name1];
//                NSLog(@"size : %f, %f", tex1.contentSize.width, tex1.contentSize.height);
//                [sprites[i] setTexture: tex1];

//                CCSpriteFrame* frame1 = [CCSpriteFrame frameWithTexture:tex1 rect:CGRectMake(0, 0, tex1.pixelsWide, tex1.pixelsHigh)];
//                [sprites[i] setDisplayFrame:frame1];
                
                if (sprites[i] != nil)
                    [sprite removeChild:sprites[i] cleanup:YES];
                sprites[i] = [CCSprite spriteWithFile:name1];
                
                NSString* s1 = @"FR,FL,BR,BL";
//                if ([pl isEqualToString:@"disk"]) {
                if ([s1 rangeOfString:str].location != NSNotFound) {
                    
                    sprites[i].tag = DISKTAG;
                    self.diskname = [NSString stringWithFormat:@"%@_%@_", pl, direction];

                }
                else
//                    if ([pl isEqualToString:@"wheels"]) {
                    if ([str isEqualToString:@"WH"]) {
                      
                    sprites[i].tag = WHEELTAG;
                    self.wheelname = [NSString stringWithFormat:@"%@_%@_", pl, direction];
                    }
                
                [sprite addChild:sprites[i] z:(-i)];
                
                NSString* corr = [NSString stringWithFormat:@"%@_%@", direction, str];
//                NSLog(@"corr = %@", corr);
                NSString* corr1 = [[Common instance] getBodyParam:corr forBody:[[Common instance] getBeaParam:@"BO" player_index:1]];
//                NSLog(@"corr1 = %@", corr1);
                NSArray *listItems = [corr1 componentsSeparatedByString:@" "];
                int x = [((NSString*)[listItems objectAtIndex:0]) intValue];
                int y = [((NSString*)[listItems objectAtIndex:1]) intValue];
//                NSLog(@"size : %d, %d", x, y);
//                CGPoint p = ccp(x, y);
                CGPoint p = ccp(x / CC_CONTENT_SCALE_FACTOR(), y / CC_CONTENT_SCALE_FACTOR());
                sprites[i].position = p;
                
            }

            
            mach_angle = b;
            
            rocket_angle = r;
            
            rocket_sprite = rocketAngle;
            
//            if(typ == CT_ME) {
//                NSLog(@"direction = %@, rocket = %@", direction, rocketAngle);
//            }
        }
    bb = b;
    firsttime = NO;
    
    speedcnt++;
    
//    if((speed > 0) && (speedcnt > speed)) {
     if(speedcnt > speed) {
        
        framecnt++;
        NSString* name1 = [NSString stringWithFormat:@"%@%d.png", self.diskname, framecnt];
        CCTexture2D* tex1 = [[CCTextureCache sharedTextureCache] addImage:name1];
        NSString* name2 = [NSString stringWithFormat:@"%@%d.png", self.wheelname, framecnt];
        CCTexture2D* tex2 = [[CCTextureCache sharedTextureCache] addImage:name2];

        for (CCNode* n in sprite.children) {
            
            if(n.tag == DISKTAG) {
                
                CCSprite* spr = (CCSprite*)n;
                
//                if(typ == CT_ME)
//                NSLog(@"DISKTAG! %@", name1);
                
                [spr setTexture: tex1];
                

            }
                else
                    if(n.tag == WHEELTAG) {
                        
                        CCSprite* spr = (CCSprite*)n;
                        [spr setTexture: tex2];
                    }

            
        }
        
        if (framecnt > 3) 
            framecnt = 0;

        speedcnt = 0;
    }
    
    //    CCSprite *eData = (CCSprite *)(body->GetUserData());
    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    
//    if(typ == CT_ME)
//        NSLog(@"me x=%f, y=%f",ep.x, ep.y);
    
    CGPoint ep1 = [[Common instance] ort2iso:ep];
    
    groundPosition = ep1;
    
    if(self.jump) {
    
    ep1.y += hh;
    
        hh += (float)(hstep * hdir)/* * ((hdir > 0)?1:1.1f)*/;
        
    if((hh > hmax) && (hdir > 0))
        hdir = -hdir;
        
        if(hh < 0) {
            self.jump = NO;
            hdir = 1;
        }
    }
    
//    eData.position = ep1;
    sprite.position = ep1;
    emitter.position = ep1;
    //    eData.rotation = -1 * CC_RADIANS_TO_DEGREES(enemy.body->GetAngle());
    
    
    
    
    CGPoint p1 = sprite.position;
    CGPoint p2 = [[Common instance] getCheckpointPos:self.checkpoint];//[[Common instance] getCurCheckpoint];
    distToChp = ccpDistance(p1, p2);
    
    //        if(typ == CT_ME)
    //            [Common instance].distToChp = distToChp;
    
    
    
    if(distToChp < 200) {
        
        //            [Common instance].checkpoint++;
        //            if([Common instance].checkpoint >= [[Common instance] getCheckpointCnt]) {
        //                
        //                [Common instance].checkpoint = 0;
        //                [Common instance].laps++;
        //                
        //            }
        
        checkpoint++;
        if(checkpoint >= [[Common instance] getCheckpointCnt]) {
            
            checkpoint = 0;
            
            if(typ == CT_ME)
                [Common instance].laps++;
            
        }
        
    }
    //        NSLog(@"dist = %f", d);
    
    
//    if(typ != CT_ME)
//        NSLog(@"distChg = %d point = %d", prevDistToChp - distToChp, checkpoint);
    

    CGPoint t = [[Common instance] getCheckpointPos:self.checkpoint];
    CGPoint t1 = [[Common instance] iso2ort:t];

//    b2Vec2 eyeOffset = b2Vec2(0, 0/*1.5*/);
    self.eye = body->GetPosition();
    
    
    b2Vec2 tChp = b2Vec2(t1.x / PTM_RATIO, t1.y / PTM_RATIO) - self.eye;
    
    targetChp = self.eye + tChp;

    
    if((typ != CT_ME) && [Common instance].started) {
    
    if(prevDistToChp - distToChp < 3)
        stuck++;
    else stuck = 0;

        if(stuck > 20) {
            
            NSLog(@"STUCK!!!! %d", stuck);
            angle = 90 + CC_RADIANS_TO_DEGREES(atan2f( -tChp.x, tChp.y )) + ((stuck>100)?180:0);

            if(stuck > 110)
                stuck = 0;
        }
    
    
    }

    prevDistToChp = distToChp;
    
    if (typ == CT_ME) {
        
//        if(([Common instance].direction.x != 0) || ([Common instance].direction.y != 0))
            f = ccpMult([Common instance].direction, 1.0f);

        //        b2Vec2 ff1 = b2Vec2(f.x, -f.y);
        float32 ang = CC_DEGREES_TO_RADIANS(-45);
        
        if(self.oil) {
        
            ang = 4;
        }
        
        float32 x2 = f.x * cos(ang) - (-f.y) * sin(ang);
        float32 y2 = (-f.y) * cos(ang) + f.x * sin(ang);
        //        b2Vec2 f2 = b2Vec2(cos(CC_DEGREES_TO_RADIANS(angle2)), sin(CC_DEGREES_TO_RADIANS(angle2)));
        b2Vec2 fforce1 = b2Vec2(x2, y2);
        fforce1.Normalize();
        fforce1 *= (float32)0.08f;
        fforce1 *= self.speedKoeff;
        body->ApplyLinearImpulse(fforce1, body->GetPosition());
        
        //////////////////////////////////////////
        // - Changed by MSyasko on 28.06.2012 - //
        //////////////////////////////////////////
        /// Smoke fixer
        if (fforce1 == b2Vec2(0, 0)) {
            emitter.startSize = 0;
            emitter.startSizeVar = 0;
            emitter.endSize = 0;
            emitter.endSizeVar = 0;
        } else {
            emitter.startSize = 60.0f;
            emitter.startSizeVar = 10.0f;
            emitter.endSize = emitter.startSize/2;
            emitter.endSizeVar = 10.0f;
        }
        
        b2Vec2 toTarget = fforce1;
        float desiredAngle = atan2f( -toTarget.x, -toTarget.y );
        body->SetTransform( body->GetPosition(), desiredAngle );
        
        
        mach.position = ccpAdd(ep1, machCorr);
        
        //////////////////////////////////////////
        // - Changed by MSyasko on 28.06.2012 - //
        //////////////////////////////////////////
        mach.rotation = mach_angle;   ////
//        mach.angle = mach_angle;    ////
        
        if([Common instance].machinegun != prev_mach) {
            
            if ([Common instance].machinegun) {
                
                [mach resetSystem];
                
                b2Vec2 bodyP = self.body->GetPosition();
                if (rocket == nil) {
                    //                    [rocket release];
                    rocket = [[Rocket alloc] initWithX:bodyP.x Y:bodyP.y Angle:rocket_angle Type:(typ == CT_ME)?RT_MYROCKET:RT_STANDARD Sprite:rocket_sprite];
                    rocketFlame.position = ccp(rocket.position.x, rocket.position.y);
                }
            }
            else
                [mach stopSystem];
            
        }
        prev_mach = [Common instance].machinegun;
        
        return;
    }
    
    
//    angle = 0;
    b2Vec2 force1;
//    if(stuck < 0) {
//        
//        force1 = targetChp - self.eye;
//
//    }
//    else
        force1 = b2Vec2(cos(CC_DEGREES_TO_RADIANS(angle)), sin(CC_DEGREES_TO_RADIANS(angle)));
    
//    NSLog(@"angle = %f", angle);

//    b2Vec2 eyeOffset = b2Vec2(0, 0/*1.5*/);
//    self.eye = body->GetWorldPoint(eyeOffset);
    
    force1.Normalize();
    force1 *= (float32)0.08f;
//    force1 = self.eye + force1;
    force1 *= self.speedKoeff;
    body->ApplyLinearImpulse(force1, body->GetPosition());
    
    b2Vec2 toTarget = force1;
    
//    targetChp = force1;
    
    float desiredAngle = atan2f( -toTarget.x, -toTarget.y );
    body->SetTransform( body->GetPosition(), desiredAngle );

//       NSLog(@"desAngle = %f", CC_RADIANS_TO_DEGREES(desAngle));

    int bonus;
    float l0 = [self processRayCastForAngle:angle forTarget:target length:50 isBonus:bonus];
    float l1 = [self processRayCastForAngle:(angle + 45) forTarget:target1 length:28 isBonus:bonus];
    if (bonus) { angle += 45; return; }
    float l2 = [self processRayCastForAngle:(angle - 45) forTarget:target2 length:28 isBonus:bonus];
    if (bonus) { angle -= 45; return; }
    float l3 = [self processRayCastForAngle:(angle + 15.5f) forTarget:target3 length:10 isBonus:bonus];
    if (bonus) { angle += 15.5f; return; }
    float l4 = [self processRayCastForAngle:(angle - 15.5f) forTarget:target4 length:10 isBonus:bonus];
    if (bonus) { angle -= 15.5f; return; }


    float k = 3.01;

    if ((l3 - l4) < -k) {
        
        angle -= 22.5f;
//        NSLog(@"-20");
    }
    else
        if ((l3 - l4) > k) {
            
            angle += 22.5f;
//            NSLog(@"+20");
        }

    if (l0 < 999) {
        
//        NSLog(@"turn l0 = %f", l0);
            if ((l1 - l2) < -k) {
                
                angle -= 8.5f;
//                NSLog(@"-10");
            }
            else
                if ((l1 - l2) > k) {
                    
                    angle += 8.5f;
//                    NSLog(@"+10");
                }
    }

}

- (float) processRayCastForAngle: (float)ang forTarget:(b2Vec2&) tar length:(int)len isBonus:(int&)bonus {
    
    float l = 1000;
    bonus = 0;
    RaysCastCallback callback;
    b2Vec2 f2 = b2Vec2(cos(CC_DEGREES_TO_RADIANS(ang)), sin(CC_DEGREES_TO_RADIANS(ang)));
    tar = f2;
    tar.Normalize();
    tar *= len;
    tar = self.eye + tar;
    [Common instance].world->RayCast(&callback, self.eye, tar);    
    if (callback.m_fixture) {
        
        l = (eye - callback.m_point).Length();
        CCNode* actor = (CCNode*)callback.m_fixture->GetBody()->GetUserData();
        if (actor.tag == HEAL_TAG) {
//            NSLog(@"BONUS!!!");
            bonus = actor.tag;
        }
    }
    
    return l;
}

- (void) lifeMinus {
    
    self.life -= 0.05f;
    if(self.life < 0)
        self.life = 0;

}

- (void) lifePlusFromHeal {
    
    self.life += 0.05f;
    if(self.life > 1)
        self.life = 1;
}

@end
