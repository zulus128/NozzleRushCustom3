//
//  CustomizeScene.m
//  NozzleRush
//
//  Created by Andrew Osipov on 29.07.12.
//  Copyright 2012 PearlUnion. All rights reserved.
//

#import "CustomizeScene.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "Common.h"

@implementation CustomizeScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CustomizeScene* layer = [CustomizeScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {				
        
        CCSprite* backgroundSprite = [CCSprite spriteWithFile:@"BACK2.png"];
        backgroundSprite.anchorPoint = ccp(0, 0);
        [self addChild:backgroundSprite];
        
        NSString *plFile = [[NSBundle mainBundle] pathForResource:@"pl_beavis" ofType:@"plist"];
		PlayerData = [[NSMutableDictionary alloc] initWithContentsOfFile:plFile];
        
        RWListCount = 1;
        LWListCount = 1;
        TWListCount = 1;
        
        NSString *RWFile = [[NSBundle mainBundle] pathForResource:@"RW" ofType:@"plist"];
		RWList = [[NSDictionary alloc] initWithContentsOfFile:RWFile];
        
        NSString *LWFile = [[NSBundle mainBundle] pathForResource:@"LW" ofType:@"plist"];
		LWList = [[NSDictionary alloc] initWithContentsOfFile:LWFile];
        
        NSString *TWFile = [[NSBundle mainBundle] pathForResource:@"TW" ofType:@"plist"];
		TWList = [[NSDictionary alloc] initWithContentsOfFile:TWFile];
        
        NSString* RWString = [NSString stringWithFormat:@"RW: %@",[PlayerData objectForKey:@"RW"]];
        label1 = [CCLabelTTF labelWithString:RWString fontName:@"GoodDogCool" fontSize:38];
        CCMenuItemLabel* item1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(RWTap:)];
        
        NSString* LWString = [NSString stringWithFormat:@"LW: %@",[PlayerData objectForKey:@"LW"]];
        label2 = [CCLabelTTF labelWithString:LWString fontName:@"GoodDogCool" fontSize:38];
        CCMenuItemLabel* item2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(LWTap:)];
        
        NSString* TWString = [NSString stringWithFormat:@"TW: %@",[PlayerData objectForKey:@"TW"]];
        label3 = [CCLabelTTF labelWithString:TWString fontName:@"GoodDogCool" fontSize:38];
        CCMenuItemLabel* item3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(TWTap:)];
        
        label4 = [CCLabelTTF labelWithString:@"Done" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(done:)];
        
        
        CCMenu* menu = [CCMenu menuWithItems:item1, item2, item3, item4, nil];
        
        menu.position = ccp(0,0);
        item1.position = ccp(backgroundSprite.contentSize.width/5, backgroundSprite.contentSize.height*6/10);
        item2.position = ccp(backgroundSprite.contentSize.width/5, backgroundSprite.contentSize.height*4/10);        
        item3.position = ccp(backgroundSprite.contentSize.width/5, backgroundSprite.contentSize.height*2/10);
        item4.position = ccp(backgroundSprite.contentSize.width*4/5, backgroundSprite.contentSize.height*4/10);	

        
        [self addChild: menu];
        

    }
    return self;
}

- (void) RWTap:(id) sender {
    
    RWListCount++;
    if (RWListCount > [RWList count])
        RWListCount = 1;
    
    NSString* KeyString = [NSString stringWithFormat:@"D_%d", RWListCount];
    NSString* RWString = [NSString stringWithFormat:@"RW: %@",[RWList objectForKey:KeyString]];
    [label1 setString:RWString];
    
}

- (void) LWTap:(id) sender {
    
    LWListCount++;
    if (LWListCount > [LWList count])
        LWListCount = 1;
    
    NSString* KeyString = [NSString stringWithFormat:@"D_%d", LWListCount];
    NSString* LWString = [NSString stringWithFormat:@"LW: %@",[LWList objectForKey:KeyString]];
    [label2 setString:LWString];
    
}

- (void) TWTap:(id) sender {
    
    TWListCount++;
    if (TWListCount > [TWList count])
        TWListCount = 1;
    
    NSString* KeyString = [NSString stringWithFormat:@"D_%d", TWListCount];
    NSString* TWString = [NSString stringWithFormat:@"TW: %@",[TWList objectForKey:KeyString]];
    [label3 setString:TWString];
    
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
    
//    [label5 setString:[NSString stringWithFormat:@"MAP: %@", [Common instance].mapType]];
    
}

- (void) done:(id) sender {
    NSString* KeyString = [NSString stringWithFormat:@"D_%d", RWListCount];
    [PlayerData setValue:[RWList objectForKey:KeyString] forKey:@"RW"];
    
    KeyString = [NSString stringWithFormat:@"D_%d", LWListCount];
    [PlayerData setValue:[LWList objectForKey:KeyString] forKey:@"LW"];
    
    KeyString = [NSString stringWithFormat:@"D_%d", TWListCount];
    [PlayerData setValue:[TWList objectForKey:KeyString] forKey:@"TW"];
    
    NSString *plFile = [[NSBundle mainBundle] pathForResource:@"pl_beavis" ofType:@"plist"];
    [PlayerData writeToFile: plFile atomically:YES];

    
    if(scene == nil)
        scene = [[MenuScene scene] retain];
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
