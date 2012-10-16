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
        
        direction1 = @"NE";

        firsttime = YES;
        
        bodyDef.type = b2_dynamicBody;
        
        self.body = [Common instance].world->CreateBody(&bodyDef);
        self.body->SetLinearDamping(1.0f);
        self.body->SetUserData(self);
        
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(1.0f, 1.0f);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.02f;
        
        if (typ == CT_ME) {

            fixtureDef.filter.groupIndex = -1;
        }
        else {
            
        }
        
        self.body->CreateFixture(&fixtureDef);
        
        
        hdir = 1;

        machinegun = nil;
        
        emitter = [[CCParticleSmoke alloc] initWithTotalParticles:25];
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"smoke.png"];
        emitter.gravity = CGPointZero;
        emitter.posVar = CGPointZero;
        emitter.positionType = kCCPositionTypeRelative;
        emitter.emitterMode = kCCParticleModeRadius;
        [[Common instance].tileMap addChild:emitter z:-1];
        
        
    }
    return self;
}

-(void) dealloc {

    [emitter release];
    
    [super dealloc];
}

- (void) setPosX:(int)x Y:(int)y {

    CGPoint p = ccp(x, y);
    sprite.position = [[Common instance] ort2iso:p];
    body->SetTransform(b2Vec2(x / PTM_RATIO, y / PTM_RATIO), 0);

    [[Common instance] getCheckpointPos:1];
    
    angle = 180;
    
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"jeep7.png"];
    [sprite setTexture: tex];

    mach_angle = 301;
    
    emitter.position = [[Common instance] ort2iso:p];

}

- (CGPoint) getGroundPosition {
    
    return groundPosition;
}

- (void) update {
   
    if (rocket != nil) {
        
        [rocket update];
        
//        if ((rocket.body->GetLinearVelocity().Normalize() < 0.4) || rocket.died) {
        if (rocket.died) {
            
            //            [rocket release];
            [[Common instance] markObjectForDelete:rocket];
            
            rocket = nil;
        }
        
    }

    float ss =  self.body->GetLinearVelocity().Normalize();
    if(ss > 5)
        speed = 0;
    else
        if(ss > 1)
            speed = 1;
    else
        speed = 1000;
    
    float rot = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
    
    int w1ZOrder = 2;
    CGPoint w1Position = ccp(0, 0);
    CGPoint w1MuzzlePosition = ccp(0, 0);
    float a = (rot < 0)?(360 + rot):rot;
    a = a + 22.5f;
    
    CGPoint machCorr = ccp(0,0);
    
    float b = 0;
    float r = 0;
 
    NSString* direction = @"N";
    
    if (a < 360.0f) {
        if (a < 315.0f) {
            if (a < 270.0f) {
                if (a < 225.0f) {
                    if (a < 180.0f) {
                        if (a < 135.0f) {
                            if (a < 90.0f) {
                                if (a < 45.0f) {
                                    direction = @"NE";

                                    w1Position = ccp(-30, 15);
                                    w1MuzzlePosition = ccp(0, 0);
                                    w1ZOrder = 1;
                                    
                                    b = 59;
                                    r = 90;
                                    machCorr = ccp(-21, 25);
                                    //                                    mach.rotation = 45;
                                } else {

                                    direction = @"E";

                                    w1Position = ccp(-16, 27);
                                    w1MuzzlePosition = ccp(0, 0);
                                    w1ZOrder = 1;
                                    
                                    b = 90;
                                    r = 135;
                                    machCorr = ccp(-2, 32);

                                    //                                    mach.rotation = 0;
                                }
                            } else {

                                direction = @"SE";

                                w1Position = ccp(5, 28);
                                w1MuzzlePosition = ccp(0, 0);
                                w1ZOrder = 1;
                                
                                b = 121;
                                r = 180;
                                machCorr = ccp(16, 27);

                                //                                mach.rotation = 315;
                            }
                        } else {

                            direction = @"S";

                            w1Position = ccp(27, 18);
                            w1MuzzlePosition = ccp(0, 0);
                            w1ZOrder = 2;
                            
                            b = 180;
                            r = 225;
                            machCorr = ccp(-27, 20);

                            //                            mach.rotation = 270;
                        }
                    } else {

                        direction = @"SW";

                        w1Position = ccp(27, 10);
                        w1MuzzlePosition = ccp(0, 0);
                        w1ZOrder = 2;
                        
                        b = 239;
                        r = 270;
                        machCorr = ccp(17, 9);

                        //                        mach.rotation = 225;
                    }
                } else {

                    direction = @"W";

                    w1Position = ccp(16, -3);
                    w1MuzzlePosition = ccp(3, 0);
                    w1ZOrder = 2;
                    
                    b = 270;
                    r = 315;
                    machCorr = ccp(3, 0);

                    //                    mach.rotation = 180;
                } 
            } else {

                direction = @"NW";

                w1Position = ccp(-7, -2);
                w1MuzzlePosition = ccp(-50, 50);
                w1ZOrder = 2;
                
                b = 301;
                r = 0;
                machCorr = ccp(-16, 7);

                //                mach.rotation = 135;
            }  
        } else {

            direction = @"N";
            
            w1Position = ccp(-26, 1);
            w1MuzzlePosition = ccp(0, 0);
            w1ZOrder = 2;
            
            b = 0;
            r = 45;
            machCorr = ccp(-26, 22);

            //            mach.rotation = 90;
        }              
    } else {

        direction = @"NE";

        w1Position = ccp(-30, 15);
        w1MuzzlePosition = ccp(0, 0);
        w1ZOrder = 1;
        
        b = 59;
        r = 90;
        machCorr = ccp(-2, 32);

        //        mach.angle = 45;
    }      
    
    
    if(bb != b)
        if(([Common instance].direction.x != 0) || ([Common instance].direction.y != 0) || (typ != CT_ME) || firsttime) {
            

                direction1 = direction;

                if(typ == CT_ME)
                NSLog(@"Direction1: %@", direction1);
            
            for (int i = 0; i < [[Common instance] getDetailCnt:direction]; i++) {


                NSString* str = [[Common instance] getDetail:direction number:i];
                NSString* pl = [[Common instance] getCarParamForSelectedProfile:str];

                NSString* add = @"";
//                if ([pl isEqualToString:@"disk"] || [pl isEqualToString:@"wheels"])
                NSString* s = @"WH,FR,FL,BR,BL";
                if ([s rangeOfString:str].location != NSNotFound)
                    add = @"_1";
                NSString* name1 = [NSString stringWithFormat:@"%@_%@%@.png", pl, direction, add];

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
//                NSString* corr1 = [[Common instance] getBodyParam:corr forBody:[[Common instance] getBeaParam:@"BO" player_index:1]];
                NSString* corr1 = [[Common instance] getBodyParam:corr forBody:[[Common instance] getCarParamForSelectedProfile:@"BO"]];
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

        }

    bb = b;
    firsttime = NO;
    
    speedcnt++;
    
//    if((speed > 0) && (speedcnt > speed)) {
     if(speedcnt > speed) {
        
        framecnt++;

        for (CCNode* n in sprite.children) {
            
            if(n.tag == DISKTAG) {
                
                NSString* name1 = [NSString stringWithFormat:@"%@%d.png", self.diskname, framecnt];
                CCTexture2D* tex1 = [[CCTextureCache sharedTextureCache] addImage:name1];
                CCSprite* spr = (CCSprite*)n;
                [spr setTexture: tex1];
                

            }
                else
                    if(n.tag == WHEELTAG) {
                        
                        NSString* name2 = [NSString stringWithFormat:@"%@%d.png", self.wheelname, framecnt];
                        CCTexture2D* tex2 = [[CCTextureCache sharedTextureCache] addImage:name2];
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
    
    if(distToChp < 200) {
        
        checkpoint++;
        if(checkpoint >= [[Common instance] getCheckpointCnt]) {
            
            checkpoint = 0;
            
            if(typ == CT_ME)
                [Common instance].laps++;
            
        }
        
    }

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
            
//            NSLog(@"STUCK!!!! %d", stuck);
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
        
        
//        mach.position = ccpAdd(ep1, machCorr);
        
        //////////////////////////////////////////
        // - Changed by MSyasko on 28.06.2012 - //
        //////////////////////////////////////////
//        mach.rotation = mach_angle;   ////
////        mach.angle = mach_angle;    ////
        
        if([Common instance].machinegun != prev_mach) {
            
            if ([Common instance].machinegun) {
                
//                [mach resetSystem];
                
                b2Vec2 bodyP = self.body->GetPosition();
                
                machinegun = [[Machinegun alloc] initWithX:bodyP.x Y:bodyP.y Angle:(rocket_angle + 180) Type:(typ == CT_ME)?WT_MYWEAPON:WT_STANDARD Direction:direction1 Car:self];
                
                rocket= [[Rocket alloc] initWithX:bodyP.x Y:bodyP.y Angle:(rocket_angle) Type:(typ == CT_ME)?WT_MYWEAPON:WT_STANDARD Direction:direction1 Car:self];
                
            }
            else {

                [machinegun clear];
                [[Common instance] markObjectForDelete:machinegun];
            }
            
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
//    NSLog(@"Car ang = %f, cos = %f", ang, f2.x);
    tar = f2;
    tar.Normalize();
    tar *= len;
    tar = self.eye + tar;
    [Common instance].world->RayCast(&callback, self.eye, tar);    
    if (callback.m_fixture) {
        
        l = (eye - callback.m_point).Length();
        CCNode* actor = (CCNode*)callback.m_fixture->GetBody()->GetUserData();
//        if(actor.tag != WALL_TAG)
//            NSLog(@"acotr.tag = %d", actor.tag);
        if (actor != nil)
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

- (void) lifePlusFromRemBonus {

    self.life += (float)[[Common instance] getBonusParam:@"RemontKoeff"]/100;
    if(self.life > 1)
        self.life = 1;
    
}

@end
