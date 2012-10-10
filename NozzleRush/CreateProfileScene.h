//
//  CreateProfileScene.h
//  NozzleRush
//
//  Created by Zul on 10/3/12.
//
//

#import "cocos2d.h"

@interface CreateProfileScene : CCLayer <UITextFieldDelegate> {
    
    CCScene *scene;
    UITextField* _nameField;
    CCLabelTTF* label2;
    int diff;
    NSDictionary* dict;
}

+ (id) scene;


@end