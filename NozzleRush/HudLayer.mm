//
//  HudLayer.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "Common.h"

//#define JOYCENTERX 70
//#define JOYCENTERY 70
//#define JOYTRIGGERRADIUS 102
//#define JOYFIELDRADIUS 250

//#define JOYWEAPONX 200
//#define JOYWEAPONY 70

@implementation HudLayer

- (void) cam:(id) sender {
    
    if(++[Common instance].camera > [Common instance].enemiesCnt)
        [Common instance].camera = 0;
}

-(id) init {
    
	if ((self = [super init])) {

		CGSize winSize = [[CCDirector sharedDirector] winSize];

        self.isTouchEnabled = YES;
        
        
        CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"CAMERA" fontName:@"GoodDogCool" fontSize:18];
        CCMenuItemLabel* item1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(cam:)];
                
        CCMenu* menu = [CCMenu menuWithItems:item1, nil];
        
        menu.position = ccp(0,0);
        item1.position = ccp(400, 300);
        [self addChild: menu];

        
        
        ///////////////
        //-SUPERMASK-//
        ///////////////
        CCSprite* superMask = [CCSprite spriteWithFile:@"superMask.png"];
        [self addChild:superMask];
        superMask.position = ccp(winSize.width/2, winSize.height/2);
        
        //////////////
        //-JOYSTICK-//
        //////////////
        CCSprite* joyfield = [CCSprite spriteWithFile:@"steeringFieldNew.png"];
        [self addChild:joyfield];
        jPadCenterX = joyfield.contentSize.width*1.1/2;
        jPadCenterY = joyfield.contentSize.height*1.1/2;
        joyfield.position = ccp(jPadCenterX, jPadCenterY);

        joyfire = [CCSprite spriteWithFile:@"steeringTriggerNew.png"];
        [self addChild:joyfire];
        jFieldRadius = (joyfield.contentSize.width - joyfire.contentSize.width)/2;
        jTriggerRadius = jFieldRadius;
        joyfire.position = ccp(jPadCenterX, jPadCenterY);
        
        move_ease_in = [[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.3f position:ccp(jPadCenterX, jPadCenterX)] rate:3.0f] retain];
        
        CCSprite* nitroButton = [CCSprite spriteWithFile:@"nitroFieldNew.png"];
        [self addChild:nitroButton];
        nitroBX = joyfield.contentSize.width + nitroButton.contentSize.width*3/7;
        nitroBY = joyfield.contentSize.height*1.1/2 - nitroButton.contentSize.height/2;
        nitroButton.position = ccp(nitroBX, nitroBY);
        
        /////////////
        //-WEAPONS-//
        /////////////
        CCSprite* joyweapon = [CCSprite spriteWithFile:@"fireButtonsBackNew.png"];
        [self addChild:joyweapon];
        jWeaponX = winSize.width - joyweapon.contentSize.width/2;
        jWeaponY = joyweapon.contentSize.height/2;
        joyweapon.position = ccp(jWeaponX, jWeaponY);
        
        //////////
        //-MENU-//
        //////////
        CCSprite* menuBack = [CCSprite spriteWithFile:@"pauseButtonNew.png"];
        [self addChild:menuBack];
        menuBack.position = ccp(menuBack.contentSize.width*1.2/2, winSize.height - menuBack.contentSize.height*1.2/2);

        ///////////////
        //-HEALTHBAR-//
        ///////////////
        healthBar = [CCSprite spriteWithFile:@"healthBar.png"];
        [self addChild:healthBar];
        hl = healthBar.contentSize.height;
        healthBX = healthBar.contentSize.width*3;
        healthBY = winSize.height/2 + healthBar.contentSize.height/3;
        healthBar.position = ccp(healthBX, healthBY);
        
        //// Fixing Life
        float lifePercentage = 1.0f;
        [healthBar setTextureRect:CGRectMake(0, 0, healthBar.contentSize.width, healthBar.contentSize.height*lifePercentage)];

        float hy = healthBY - (healthBar.contentSize.height/lifePercentage)*(1 - lifePercentage)/2;
        healthBar.position = ccp(healthBX, hy);
        
        CCSprite* healthBarBack = [CCSprite spriteWithFile:@"healthBarBack.png"];
        [self addChild:healthBarBack];
        healthBarBack.position = ccp(healthBX, healthBY);

        
        /////////
        //-MAP-//
        /////////
        CCSprite* mapBack = [CCSprite spriteWithFile:@"mapRoad.png"];
        [self addChild:mapBack];
        mapBX = winSize.width - mapBack.contentSize.width*1.3/2;
        mapBY = winSize.height - mapBack.contentSize.height*1.3/2;
        mapBack.position = ccp(mapBX, mapBY);
        
        /////////////////
        //-DIALOGBOXES-//
        /////////////////
        score = [CCLabelTTF labelWithString:@"CHECKPOINT:  LAP: " fontName:@"GoodDogCool" fontSize:15];
        score.position = ccp(winSize.width/2, winSize.height - 30);
        [self addChild:score z:60];

        label2 = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"GoodDogCool" fontSize:38];
        label2.position = ccp(winSize.width / 2 - 40, winSize.height / 2);
        label2.visible = NO;
        [self addChild:label2 z:100];
        
        cd_label = [CCLabelTTF labelWithString:@" " fontName:@"Helvetica" fontSize:58];
        cd_label.visible = NO;
        cd_label.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:cd_label z:500];

	}
	return self;
}

- (void) showCD {
    
    int c = [[Common instance] getCDCount];
    cd_label.visible = YES;

    [Common instance].cntCD++;    
//    NSLog(@"cntCD = %d", [Common instance].cntCD);
    
    if([Common instance].cntCD > c) {
    
        cd_label.visible = NO;
        [Common instance].started = YES;
    }
    else {
        [cd_label setString:[[Common instance] getCDParam:([Common instance].cntCD)]];
        [cd_label runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0f], [CCCallFuncN actionWithTarget:self selector:@selector(showCD)], nil]];
    }
}

- (void) showGO {
    
    joyfire.position = ccp(jPadCenterX, jPadCenterX);
    trigbeginx = 0;
    trigbeginy = 0;
    flagbegin = NO;
    
    label2.visible = YES;
}

- (void) hideGO {
    
    label2.visible = NO;
}

- (void) updateScore {
    
    NSString* str = [NSString stringWithFormat:@"CHECKPOINT: %d, LAP: %d, DISTANCE TO CHECKPOINT: %d, MYLIFE: %.2f", [Common instance].me.checkpoint, [Common instance].laps, [Common instance].me.distToChp, [Common instance].me.life];
    [score setString:str];
    

    float lifePercentage = [Common instance].me.life;
    [healthBar setTextureRect:CGRectMake(0, 0, healthBar.contentSize.width, hl*lifePercentage)];
    float hy = healthBY - (healthBar.contentSize.height/lifePercentage)*(1 - lifePercentage)/2;
    healthBar.position = ccp(healthBX, hy);

}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
        if(flagbegin)
            return;
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        
        
        location = [[CCDirector sharedDirector] convertToGL: location];
        
        
        if((fabs(location.x - jPadCenterX) < jTriggerRadius) && (fabs(location.y - jPadCenterY) < jTriggerRadius)) {
            
            trigbeginx = location.x;
            trigbeginy = location.y;
            flagbegin = YES;
//            NSLog(@"touch began x = %f, y = %f", location.x, location.y);
        }
    
    if((fabs(location.x - jWeaponX) < 50) && (fabs(location.y - jWeaponY) < 50)) {
        [Common instance].machinegun = YES;
//        NSLog(@"touch began x = %f, y = %f", location.x, location.y);
    }
    
    if((fabs(location.x - pauseBX) < 50) && (fabs(location.y - pauseBY) < 50)) {
        //[self unscheduleAllSelectors];
//        [[CCDirector sharedDirector] pause];
        [self pause];
    }
    
}

- (void) pause {
    
    if (isPause)
        [[CCDirector sharedDirector] resume];
    else
        [[CCDirector sharedDirector] pause];
    
    isPause = !isPause;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
        if(!flagbegin)
            return;
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
            
        location = [[CCDirector sharedDirector] convertToGL: location];
        
//        NSLog(@"touch move x = %f, y = %f", location.x, location.y);
        
    float deltax = trigbeginx - jPadCenterX;
    float deltay = trigbeginy - jPadCenterY;
    CGPoint p = ccp(location.x - deltax, location.y - deltay);
    if(ccpDistance(p, ccp(jPadCenterX, jPadCenterY)) < jFieldRadius)
        joyfire.position = p;
    else {
        float coefDist = jFieldRadius/ccpDistance(p, ccp(jPadCenterX, jPadCenterY));
        joyfire.position = ccp((p.x - jPadCenterX)*fabsf(coefDist) + jPadCenterX, (p.y - jPadCenterY)*fabsf(coefDist) + jPadCenterY);
    }
    
    [Common instance].direction = ccp(p.x - trigbeginx, p.y - trigbeginy);
    
//    NSLog(@"----------m");
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
//        NSLog(@"touch ended");
       
    if([Common instance].machinegun) {
    
        [Common instance].machinegun = NO;
        return;
    }
    
        [joyfire stopAllActions];
        [joyfire runAction:move_ease_in];
        
        flagbegin = NO;
    
    [Common instance].direction = ccp(0,0);
    
//    NSLog(@"----------e");
    
    
    if(!isPause && [[CCDirector sharedDirector] isPaused]) {
        
        [self hideGO];
        [[CCDirector sharedDirector] resume];
//        [[CCDirector sharedDirector] replaceScene:[Common instance].menuscene];
        [[CCDirector sharedDirector] popScene];
    }
}


-(void) dealloc {

    [move_ease_in release];
    
	[super dealloc];
}	

@end
