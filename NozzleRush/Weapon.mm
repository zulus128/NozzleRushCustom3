//
//  Weapon.m
//  NozzleRush
//
//  Created by vadim on 9/11/12.
//
//

#import "Weapon.h"

#import "Common.h"

@implementation Weapon

@synthesize body, sprite;
@synthesize died;

- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type Sprite:(NSString*)spr {
    
    if((self = [super init])) {
        
        typ = type;
        self.tag = WEAPON_TAG;
        
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
    return self;
}

-(void) dealloc {
    
    [[Common instance].tileMap removeChild:sprite cleanup:YES];
    [Common instance].world->DestroyBody( self.body );
    self.body = nil;
    
    NSLog(@"Weapon dealloc");
    
    [super dealloc];
}

- (void) update {
    
    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    
    CGPoint ep1 = [[Common instance] ort2iso:ep];
    
    sprite.position = ep1;
    
}

@end
