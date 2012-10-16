//
//  GarageMenuScene.m
//  NozzleRush
//
//  Created by вадим on 10/9/12.
//
//

#import "GarageMenuScene.h"
#import "ProfileMenuScene.h"
#import "Common.h"

@implementation GarageMenuScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GarageMenuScene* layer = [GarageMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {
        
        CCSprite* backgroundSprite = [CCSprite spriteWithFile:@"BACK2.png"];
        backgroundSprite.anchorPoint = ccp(0, 0);
        [self addChild:backgroundSprite];
        
        NSDictionary* d = [[Common instance] getSelectedProfile];
        di = [[NSMutableDictionary alloc] initWithDictionary:d];
        
        body = [[NSArray alloc] initWithObjects:@"jeep_SW.png", @"GonkaWhite_SW.png", nil];
        bodyindex = [[di objectForKey:@"body_index"] intValue];
        rwindex = [[di objectForKey:@"RW_index"] intValue];
        lwindex = [[di objectForKey:@"LW_index"] intValue];
        bwindex = [[di objectForKey:@"BW_index"] intValue];

        sprite = [CCSprite spriteWithFile:[body objectAtIndex:bodyindex]];
        [self addChild:sprite];
        sprite.position = ccp(110, backgroundSprite.contentSize.height - 120);
        
        CCMenu* menu = [[CCMenu alloc] init];
        menu.position = ccp(0,0);
        [self addChild: menu];
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Back" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(back:)];
        item.position = ccp(30, backgroundSprite.contentSize.height - 50);
        [menu addChild:item];
        
        label_body = [CCLabelTTF labelWithString:[body objectAtIndex:bodyindex] fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item1 = [CCMenuItemLabel itemWithLabel:label_body target:self selector:@selector(korpus:)];
        item1.position = ccp(360, backgroundSprite.contentSize.height - 80);
        [menu addChild:item1];

        NSString *details_file = [[NSBundle mainBundle] pathForResource:@"details" ofType:@"plist"];
        NSDictionary* details = [[NSDictionary alloc] initWithContentsOfFile:details_file];
        rw = [details objectForKey:@"RW"];
        lw = [details objectForKey:@"LW"];
        bw = [details objectForKey:@"BW"];
        label_rw = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"RW: %@", [rw objectAtIndex:rwindex]] fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item2 = [CCMenuItemLabel itemWithLabel:label_rw target:self selector:@selector(rwchange:)];
        item2.position = ccp(360, backgroundSprite.contentSize.height - 130);
        [menu addChild:item2];
        label_lw = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"LW: %@", [lw objectAtIndex:lwindex]] fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item3 = [CCMenuItemLabel itemWithLabel:label_lw target:self selector:@selector(lwchange:)];
        item3.position = ccp(360, backgroundSprite.contentSize.height - 160);
        [menu addChild:item3];
        label_bw = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"BW: %@", [bw objectAtIndex:bwindex]] fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item4 = [CCMenuItemLabel itemWithLabel:label_bw target:self selector:@selector(bwchange:)];
        item4.position = ccp(360, backgroundSprite.contentSize.height - 190);
        [menu addChild:item4];
        
    }
    return self;
}

- (void) back:(id) sender {
    
    [di setObject:[NSNumber numberWithInt:rwindex] forKey:@"RW_index"];
    [di setObject:[NSNumber numberWithInt:lwindex] forKey:@"LW_index"];
    [di setObject:[NSNumber numberWithInt:bwindex] forKey:@"BW_index"];
    [di setObject:[NSNumber numberWithInt:bodyindex] forKey:@"body_index"];
    [[Common instance] setSelectedProfile:di];
    
    CCScene *scen = [ProfileMenuScene scene];
	[[CCDirector sharedDirector] replaceScene: scen];
}

- (void) korpus:(id) sender {
    
    bodyindex++;
    if(bodyindex >= body.count)
        bodyindex = 0;
    
    [label_body setString:[body objectAtIndex:bodyindex]];

    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:[body objectAtIndex:bodyindex]];
    [sprite setTexture: tex];

}

- (void) rwchange:(id) sender {

    rwindex++;
    if(rwindex >= rw.count)
        rwindex = 0;
    
    [label_rw setString:[NSString stringWithFormat:@"RW: %@", [rw objectAtIndex:rwindex]]];

}

- (void) lwchange:(id) sender {

    lwindex++;
    if(lwindex >= lw.count)
        lwindex = 0;
    
    [label_lw setString:[NSString stringWithFormat:@"LW: %@", [lw objectAtIndex:lwindex]]];
}

- (void) bwchange:(id) sender {

    bwindex++;
    if(bwindex >= bw.count)
        bwindex = 0;
    
    [label_bw setString:[NSString stringWithFormat:@"BW: %@", [bw objectAtIndex:bwindex]]];
}

@end
