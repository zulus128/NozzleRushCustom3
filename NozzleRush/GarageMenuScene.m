//
//  GarageMenuScene.m
//  NozzleRush
//
//  Created by вадим on 10/9/12.
//
//

#import "GarageMenuScene.h"
#import "ProfileMenuScene.h"

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
        
        
        body = [[NSArray alloc] initWithObjects:@"jeep_SW.png", @"GonkaWhite_SW.png", nil];
        bodyindex = 0;
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
        
        
    }
    return self;
}

- (void) back:(id) sender {
    
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

@end
