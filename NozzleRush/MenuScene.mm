//
//  MenuScene.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "Common.h"

@implementation MenuScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuScene* layer = [MenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {				
        
        CCSprite* backgroundSprite = [CCSprite spriteWithFile:@"BACK2.png"];
        backgroundSprite.anchorPoint = ccp(0, 0);
        [self addChild:backgroundSprite];
        
        CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"RACE" fontName:@"GoodDogCool" fontSize:38];
        CCMenuItemLabel* item1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(race:)];

        CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"FREE RIDE" fontName:@"GoodDogCool" fontSize:38];
        CCMenuItemLabel* item2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(ride:)];

        label3 = [CCLabelTTF labelWithString:@"LAPS: 1" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(laps:)];

        label4 = [CCLabelTTF labelWithString:@"ENEMIES: 1" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(enem:)];
        
        label5 = [CCLabelTTF labelWithString:@"MAP: MOON" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item5 = [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(mapChanger:)];
        
        CCLabelTTF* settingsTitle = [CCLabelTTF labelWithString:@"-SETTINGS-" fontName:@"GoodDogCool" fontSize:40];
        CCMenuItemLabel* settingsTitleItem = [CCMenuItemLabel itemWithLabel:settingsTitle target:self selector:nil];
        
        CCMenu* menu = [CCMenu menuWithItems:item1, item2, item3, item4, item5, settingsTitleItem, nil];

        menu.position = ccp(0,0);
        item1.position = ccp(backgroundSprite.contentSize.width/5, backgroundSprite.contentSize.height*6/10);
        item2.position = ccp(backgroundSprite.contentSize.width/5, backgroundSprite.contentSize.height*4/10);        
        settingsTitle.position = ccp(backgroundSprite.contentSize.width*4/5, backgroundSprite.contentSize.height*7.5/10);
        item3.position = ccp(backgroundSprite.contentSize.width*4/5, backgroundSprite.contentSize.height*6/10);	
        item4.position = ccp(backgroundSprite.contentSize.width*4/5, backgroundSprite.contentSize.height*5/10);
        item5.position = ccp(backgroundSprite.contentSize.width*4/5, backgroundSprite.contentSize.height*4/10);
        
        [self addChild: menu];
        
        [Common instance].laps_cnt = LAPS_CNT;
        [label3 setString:[NSString stringWithFormat:@"LAPS: %d", [Common instance].laps_cnt]];
        
        [Common instance].enemiesCnt = 1;
        [label4 setString:[NSString stringWithFormat:@"ENEMIES: %d", [Common instance].enemiesCnt]];
    }
    return self;
}

- (void) laps:(id) sender {

    [Common instance].laps_cnt++;
    if ([Common instance].laps_cnt > 7)
        [Common instance].laps_cnt = LAPS_CNT;
    
    [label3 setString:[NSString stringWithFormat:@"LAPS: %d", [Common instance].laps_cnt]];

}

- (void) enem:(id) sender {
    
    [Common instance].enemiesCnt++;
    if ([Common instance].enemiesCnt > 6)
        [Common instance].enemiesCnt = 1;
    
    [label4 setString:[NSString stringWithFormat:@"ENEMIES: %d", [Common instance].enemiesCnt]];
    
}

- (void) mapChanger:(id) sender {
    
    if ([Common instance].mapType == @"MOON") 
        [Common instance].mapType = @"MARS";
    else 
        if ([Common instance].mapType == @"MARS")
            [Common instance].mapType = @"VENUS";
        else 
            if ([Common instance].mapType == @"VENUS")
            [Common instance].mapType = @"MOON";
    
    NSLog(@"MAP TYPE: %@", [Common instance].mapType);
    
    [label5 setString:[NSString stringWithFormat:@"MAP: %@", [Common instance].mapType]];
    
}

- (void) race:(id) sender {

    [Common instance].gametype = GT_RACE;
    if(scene == nil)
        scene = [[GameScene scene] retain];
    [[Common instance].gamescene start];
	[[CCDirector sharedDirector] pushScene: scene]; 
    
}

- (void) ride:(id) sender {

    [Common instance].gametype = GT_FREERIDE;
    if(scene == nil)
        scene = [[GameScene scene] retain];
    [[Common instance].gamescene start];
	[[CCDirector sharedDirector] pushScene: scene]; 

}

@end
