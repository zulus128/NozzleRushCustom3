//
//  CreateProfileScene.m
//  NozzleRush
//
//  Created by Zul on 10/3/12.
//
//

#import "CreateProfileScene.h"
#import "Common.h"
#import "SelectProfileScene.h"

@implementation CreateProfileScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreateProfileScene* layer = [CreateProfileScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {
        
        CCSprite* backgroundSprite = [CCSprite spriteWithFile:@"BACK2.png"];
        backgroundSprite.anchorPoint = ccp(0, 0);
        [self addChild:backgroundSprite];
        
        NSDictionary* dict = [[Common instance] getTempProfile];
        NSString* name = [dict objectForKey:@"Name"];
        diff = [[dict objectForKey:@"Difficulty"] intValue];
        
//        CGAffineTransform transform = CGAffineTransformMakeRotation(3.14159/2);
        UIView* _view = [[CCDirector sharedDirector]openGLView];
        
        // Input the user name
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(130.0, 70.0, 200.0, 30.0)];
//        _nameField.transform = transform;
        _nameField.adjustsFontSizeToFitWidth = YES;
        _nameField.textColor = [UIColor whiteColor];
        [_nameField setFont:[UIFont fontWithName:@"GoodDogCool" size:14]];
        _nameField.placeholder = name;//@"<Enter Your Name>";
        _nameField.backgroundColor = [UIColor clearColor];
        _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nameField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        _nameField.textAlignment = UITextAlignmentCenter;
        _nameField.keyboardType = UIKeyboardTypeDefault;
        _nameField.returnKeyType = UIReturnKeyDone;
        _nameField.tag = 0;
        _nameField.delegate = self;
        _nameField.clearButtonMode = UITextFieldViewModeNever;
        _nameField.borderStyle = UITextBorderStyleRoundedRect;
        
        [_view addSubview:_nameField];
        
        CCMenu* menu = [[CCMenu alloc] init];
        menu.position = ccp(0,0);
        [self addChild: menu];
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Back" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(back:)];
        item.position = ccp(30, backgroundSprite.contentSize.height - 50);
        [menu addChild:item];

        CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Create profile" fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(create:)];
        item1.position = ccp(backgroundSprite.contentSize.width / 2, backgroundSprite.contentSize.height - 160);
        [menu addChild:item1];

        label2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Difficulty: %d", diff] fontName:@"GoodDogCool" fontSize:25];
        CCMenuItemLabel* item2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(dif:)];
        item2.position = ccp(backgroundSprite.contentSize.width / 2, backgroundSprite.contentSize.height - 120);
        [menu addChild:item2];

        
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

- (void) back:(id) sender {
 
//    [_nameField resignFirstResponder];
//    [_nameField removeFromSuperview];
//    [_nameField release];
//    [[CCDirector sharedDirector] popScene];
    
    CCScene *scen = [SelectProfileScene scene];
	[[CCDirector sharedDirector] replaceScene: scen];
}

- (void) create:(id) sender {
    
    NSMutableDictionary* dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:[NSNumber numberWithInt:diff] forKey:@"Difficulty"];
    [dic1 setObject:_nameField.text forKey:@"Name"];
    [[Common instance] createProfile:dic1];
    [dic1 release];
    
    [self back:nil];
}

- (void) dif:(id) sender {
    
    diff++;
    if(diff > 4)
        diff = 0;
    
    [label2 setString:[NSString stringWithFormat:@"Difficulty: %d", diff]];

}

-(void) dealloc {
    
    [_nameField resignFirstResponder];
    [_nameField removeFromSuperview];
    [_nameField release];
    
    [super dealloc];
}

@end
