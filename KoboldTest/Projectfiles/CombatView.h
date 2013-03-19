//
//  CombatView.h
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//
//#import "InventoryLayer.h"

#import "cocos2d.h"
#import "PlayerCharacter.h"

@class CombatLayer;

@interface CombatView : CCLayer
<CCTargetedTouchDelegate>
{
@private
    CCLayer *midLayer;
    CCSprite *ground;
    CombatLayer *layer;
    
}
+ (CombatView *)newView: (CombatLayer *)aLayer;
-(void) addChildToMid:(CCNode *)aNode;
-(int) getGroundWidth;
//-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
//-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
//-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
