//
//  Rocket.mm
//  NozzleRush
//
//  Created by вадим on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Rocket.h"
#import "Common.h"

@implementation Rocket

@synthesize body, sprite;

- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type {
   
    if((self = [super init])) {				
        
        typ = type;
//        angle = a;
        self.tag = ROCKET_TAG;
        
        
        
        
        sprite = [CCSprite spriteWithFile:@"r225.png"];     //Added by MSyasko on 1.07.2012
        sprite.tag = 0;
        [[Common instance].tileMap addChild:sprite z:0];    //corrected by Andrew Osipov 28.05.12        
        
        bodyDef.type = b2_dynamicBody;
        
        self.body = [Common instance].world->CreateBody(&bodyDef);
        self.body->SetLinearDamping(1.0f);
        //        self.body->SetUserData(sprite);
        self.body->SetUserData(self);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        //        dynamicBox.SetAsBox(2.1f, 2.1f);
        dynamicBox.SetAsBox(0.5f, 0.5f);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.02f;
        //        fixtureDef.friction = 4.3f;

        if (typ == RT_MYROCKET) {
            
            fixtureDef.filter.groupIndex = -1;
        }

        self.body->CreateFixture(&fixtureDef);
        
//        NSLog(@"Rocket angle = %f",a);
        
//        self.body->SetTransform( b2Vec2(x, y), a );
        self.body->SetTransform( b2Vec2(x, y), 0 );
        
        CGPoint f = ccpMult(/*[Common instance].direction*/ccp(-1,0), 1.0f);
        
        float aa = CC_DEGREES_TO_RADIANS(a);
        
        float32 x2 = f.x * cos(aa) - (-f.y) * sin(aa);
        float32 y2 = (-f.y) * cos(aa) + f.x * sin(aa);

        b2Vec2 fforce1 = b2Vec2(x2, y2);
//        b2Vec2 fforce1 = b2Vec2(-1, -1);
        fforce1.Normalize();
//        fforce1 *= (float32)0.08f;
        body->ApplyLinearImpulse(fforce1, body->GetPosition());

        sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(self.body->GetAngle());
    }
    return self;
}

-(void) dealloc {

    //    [sprite stopAllActions];
    [[Common instance].tileMap removeChild:sprite cleanup:YES];
    [Common instance].world->DestroyBody( self.body );
    self.body = nil;
    
//    [expl resetSystem];
    
//    [expl release];
    

    NSLog(@"Rocket dealloc");
    
    [super dealloc];
}

- (void) update {

    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    
    CGPoint ep1 = [[Common instance] ort2iso:ep];
    
    sprite.position = ep1;

}

@end
