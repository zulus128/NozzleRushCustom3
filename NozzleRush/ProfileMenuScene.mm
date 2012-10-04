//
//  ProfileMenuScene.m
//  NozzleRush
//
//  Created by Zul on 10/3/12.
//
//

#import "ProfileMenuScene.h"
#import "SelectProfileScene.h"
#import "Common.h"

@implementation ProfileMenuScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ProfileMenuScene* layer = [ProfileMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {
        
        CCSprite* backgroundSprite = [CCSprite spriteWithFile:@"BACK2.png"];
        backgroundSprite.anchorPoint = ccp(0, 0);
        [self addChild:backgroundSprite];
        
        NSDictionary* dict = [[Common instance] getSelectedProfile];
        NSString* name = [dict objectForKey:@"Name"];
        int diff = [[dict objectForKey:@"Difficulty"] intValue];
        
        CCLabelTTF* title = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Name: %@, Dif: %d", name, diff] fontName:@"GoodDogCool" fontSize:25];
        title.position = ccp(backgroundSprite.contentSize.width / 2, backgroundSprite.contentSize.height - 30);
        [self addChild:title];
        
        CCMenu* menu = [[CCMenu alloc] init];
        menu.position = ccp(0,0);
        [self addChild: menu];
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Back" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(back:)];
        item.position = ccp(30, backgroundSprite.contentSize.height - 50);
        [menu addChild:item];

        CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Career" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(career:)];
        item1.position = ccp(90, backgroundSprite.contentSize.height - 150);
        [menu addChild:item1];
        
        CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Skill" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(skill:)];
        item2.position = ccp(330, backgroundSprite.contentSize.height - 150);
        [menu addChild:item2];

        CCLabelTTF* label3 = [CCLabelTTF labelWithString:@"Garage" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(garage:)];
        item3.position = ccp(90, backgroundSprite.contentSize.height - 250);
        [menu addChild:item3];
        
        CCLabelTTF* label4 = [CCLabelTTF labelWithString:@"Shop" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(shop:)];
        item4.position = ccp(330, backgroundSprite.contentSize.height - 250);
        [menu addChild:item4];
        
    }
    return self;
}

- (void) back:(id) sender {
    
    CCScene *scen = [SelectProfileScene scene];
	[[CCDirector sharedDirector] replaceScene: scen];
}


@end
