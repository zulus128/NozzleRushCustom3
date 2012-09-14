//
//  Weapon.m
//  NozzleRush
//
//  Created by vadim on 9/11/12.
//
//

#import "Weapon.h"

#import "Common.h"
#import "Car.h"

@implementation Weapon

@synthesize body, sprite;
@synthesize died;

- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type Sprite:(NSString*)spr File:(NSDictionary*)file Car:(Car*)car {
    
    if((self = [super init])) {
        
        typ = type;
        self.tag = WEAPON_TAG;
        parent = car;
        sprite = nil;
        
        if(spr != nil) {
            
            NSLog(@"Weapon sprite: %@", spr);
            
            sprite = [CCSprite spriteWithFile:spr];
            sprite.tag = 0;
            [[Common instance].tileMap addChild:sprite z:0];
            
            bodyDef.type = b2_dynamicBody;
            
            self.body = [Common instance].world->CreateBody(&bodyDef);
            self.body->SetLinearDamping(1.0f);
            self.body->SetUserData(self);
            
            // Define another box shape for our dynamic body.
            b2PolygonShape dynamicBox;
            dynamicBox.SetAsBox(0.5f, 0.5f);
            
            // Define the dynamic body fixture.
            b2FixtureDef fixtureDef;
            fixtureDef.shape = &dynamicBox;
            fixtureDef.density = 0.02f;
            
            if (typ == WT_MYWEAPON) {
                
                fixtureDef.filter.groupIndex = -1;
            }
            
            self.body->CreateFixture(&fixtureDef);
            
            self.body->SetTransform( b2Vec2(x, y), 0 );
            
            CGPoint f = ccpMult(/*[Common instance].direction*/ccp(-1,0), 1.0f);
            
            float aa = CC_DEGREES_TO_RADIANS(a);
            
            float32 x2 = f.x * cos(aa) - (-f.y) * sin(aa);
            float32 y2 = (-f.y) * cos(aa) + f.x * sin(aa);
            
            b2Vec2 fforce1 = b2Vec2(x2, y2);
            fforce1.Normalize();
            body->ApplyLinearImpulse(fforce1, body->GetPosition());
            
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(self.body->GetAngle());
        }
        
        NSString* shot = [file objectForKey:@"shot_particle_effect"];
        if(![shot isEqualToString:NONE_STRING]) {
            
            shot_effect = [[CCParticleExplosion alloc]initWithFile:shot];
            shot_effect.position = ccp(0,0);
            [[Common instance].tileMap addChild:shot_effect z:1];
            [shot_effect stopSystem];
        }
        else
            shot_effect = nil;

        NSString* hit = [file objectForKey:@"hit_particle_effect"];
        if(![hit isEqualToString:NONE_STRING]) {
            
            hit_effect = [[CCParticleExplosion alloc]initWithFile:hit];
            hit_effect.position = ccp(0,0);
            [[Common instance].tileMap addChild:hit_effect z:1];
            [hit_effect stopSystem];
        }
        else
            hit_effect = nil;
        
        double shotssec = [[file valueForKey:@"shots_in_sec"] doubleValue];
        delay = 1 / shotssec;
        finite = [[file objectForKey:@"type"] isEqualToString:@"finite"];
        waytime = [[file objectForKey:@"bullet_speed"] isEqualToString:@"inf"]?0.0f:5.0f;
        [self start];

    }
    
    return self;
}

- (void) start {
    
//    NSLog(@"Weapon start");
    
    if(shot_effect != nil) {
        
        shot_effect.position = [parent getGroundPosition];
        [shot_effect resetSystem];
    }
    
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:waytime target:self selector:@selector(stop) userInfo:nil repeats:NO];
    
}

- (void) stop {
    
//    NSLog(@"Weapon stop");
    
    if(hit_effect != nil) {
        
        hit_effect.position = [parent getGroundPosition];
        [hit_effect resetSystem];
    }
    
    if(sprite != nil) {
        
        self.died = YES;
        
//        [[Common instance].tileMap removeChild:sprite cleanup:YES];
//        [Common instance].world->DestroyBody( self.body );
//        self.body = nil;
    }
    
    [self.timer invalidate];
    self.timer = nil;
    if(!finite)
//        [self start];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(start) userInfo:nil repeats:NO];
    
}

-(void) dealloc {
    
    NSLog(@"Weapon dealloc");

    if (self.timer != nil) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if(shot_effect != nil) {
        
        [shot_effect stopSystem];
        [shot_effect release];
        shot_effect = nil;
    
    }
    
    if(hit_effect != nil) {
        
        [hit_effect stopSystem];
        [hit_effect release];
        hit_effect = nil;
        
    }
    
    if(sprite != nil) {
    
        [[Common instance].tileMap removeChild:sprite cleanup:YES];
        [Common instance].world->DestroyBody( self.body );
        self.body = nil;
    }
    
    [super dealloc];
}

- (void) update {
    
    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    
    CGPoint ep1 = [[Common instance] ort2iso:ep];
    
    sprite.position = ep1;
    
}

@end
