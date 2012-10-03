//
//  SelectProfileScene.m
//  NozzleRush
//
//  Created by Zul on 10/3/12.
//
//

#import "SelectProfileScene.h"
#import "Common.h"

@implementation SelectProfileScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SelectProfileScene* layer = [SelectProfileScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {
        
        CCSprite* backgroundSprite = [CCSprite spriteWithFile:@"BACK2.png"];
        backgroundSprite.anchorPoint = ccp(0, 0);
        [self addChild:backgroundSprite];
        
        CCMenu* menu = [[CCMenu alloc] init];
        menu.position = ccp(0,0);
        [self addChild: menu];

        int c = [[Common instance] profilesCnt];
        for(int i = 0; i < c; i++) {
            
            NSDictionary* prof = [[Common instance] getProfile:i];
            NSString* name = [prof objectForKey:@"Name"];
            CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Profile #%d. Name: %@", i, name] fontName:@"GoodDogCool" fontSize:25];
            CCMenuItemLabel* item = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(click:)];
            item.tag = i;
            item.position = ccp(backgroundSprite.contentSize.width/2 - 20, backgroundSprite.contentSize.height - 100 - 50*i);
            [menu addChild:item];
        }
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Create profile" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(add:)];
        item.tag = c;
        item.position = ccp(backgroundSprite.contentSize.width/2 - 20, backgroundSprite.contentSize.height - 100 - 50*c);
        [menu addChild:item];
        
        
    }
    return self;
}

- (void) click:(id) sender {
    
    NSLog(@"Clicked %d", ((CCMenuItemLabel*) sender).tag);
}

- (void) add:(id) sender {
    
    NSLog(@"Add %d", ((CCMenuItemLabel*) sender).tag);
}

@end
