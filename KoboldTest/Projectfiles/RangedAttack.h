//
//  RangedAttack.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCSprite.h"
#import "NPC.h"

@class SceneModel;

@interface RangedAttack : CCSprite {
    @public
    Character *target;
    CGPoint velocity;
    float speedMultiplier;
    SceneModel *model;
    CGPoint targetPosition;
    
    
}
+ (id)rangedAttackBy:(Character *)attacker on: (Character *)target withTexture: (CCTexture2D *)aTexture andModel: (SceneModel *)aModel;


@end
