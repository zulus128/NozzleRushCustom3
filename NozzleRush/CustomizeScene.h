//
//  CustomizeScene.h
//  NozzleRush
//
//  Created by Andrew Osipov on 29.07.12.
//  Copyright 2012 PearlUnion. All rights reserved.
//


#import "cocos2d.h"

@interface CustomizeScene : CCLayer {
    
    CCScene *scene;
    CCLabelTTF* label1;
    CCLabelTTF* label2;
    CCLabelTTF* label3;
    CCLabelTTF* label4;
    NSMutableDictionary* PlayerData;
    NSDictionary* RWList;
    NSDictionary* LWList;
    NSDictionary* TWList;
    int RWListCount;
    int LWListCount;
    int TWListCount;
}

+ (id) scene;

- (void) RWTap:(id) sender;
- (void) race:(id) sender;
- (void) ride:(id) sender;
- (void) mapChanger:(id) sender;

@end

