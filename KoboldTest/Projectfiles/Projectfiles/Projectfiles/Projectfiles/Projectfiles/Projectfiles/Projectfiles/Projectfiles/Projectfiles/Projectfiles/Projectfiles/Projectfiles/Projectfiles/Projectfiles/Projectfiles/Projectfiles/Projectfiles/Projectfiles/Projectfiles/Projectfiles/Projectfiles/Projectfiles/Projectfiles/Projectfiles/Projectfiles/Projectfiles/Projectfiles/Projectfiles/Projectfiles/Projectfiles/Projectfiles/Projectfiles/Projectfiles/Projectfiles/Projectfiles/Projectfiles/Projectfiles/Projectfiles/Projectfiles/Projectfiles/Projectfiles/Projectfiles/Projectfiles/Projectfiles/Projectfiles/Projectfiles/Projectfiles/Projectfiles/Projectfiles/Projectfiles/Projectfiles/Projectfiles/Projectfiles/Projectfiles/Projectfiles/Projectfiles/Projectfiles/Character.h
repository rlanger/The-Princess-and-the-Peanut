//
//  Character.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-10-30.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"
#import "cocos2d.h"
#import "Constants.h"

@class Model;

@interface Character : CCSprite <CCTargetedTouchDelegate> {
@private
    CGPoint drawAnchor;
    int screenHeight;


    float attackSpeed;
    float timeSinceLastAttack;
    int baseDamage;
    int variableDamage;
        
@public
    Model *model;
    int cType;
    float hp;
    float hpMax;
    CGPoint velocity;
    int speedMultiplier;
    Character *target;
    CGPoint destination;
}

@property(nonatomic, readonly) CGRect rect;
@property(nonatomic, readonly) CGRect rectInPixels;

+ (id) characterWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType;
- (id)initWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType;
- (bool) containsTouchLocation:(UITouch*)touch;
- (void) combatAI;
- (void) calculateVelocity;
- (void) damageTarget;
- (void) drawSelectionBox;
- (void) drawHealthBar;
- (void) calculateVelocityTo: (CGPoint) pcDest;



@end
