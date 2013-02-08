//
//  NPC.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-09-12.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "NPC.h"
#import "SceneView.h"
#import "SceneModel.h"
#import "cocos2d.h"

@implementation NPC

- (CGRect)rectInPixels
{
	CGSize s = [texture_ contentSizeInPixels];
	return CGRectMake(-s.width / 2, 0, s.width, s.height);
}

- (CGRect)rect
{
	CGSize s = [texture_ contentSize];
	return CGRectMake(-s.width / 2, 0, s.width, s.height);
}

+ (id)npcWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType
{
	return [[self alloc] initWithTexture:aTexture andModel:aModel andType:aType];
}

- (id)initWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType
{
	if ((self = [super initWithTexture:aTexture andModel:aModel andType:aType]) ) {
        
        blocking = true;
        dialogueString = @"Hello. I am a tree.";
        dialogueEnabled = false;
              
	}
    
	return self;
}

/*
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ( ![self containsTouchLocation:touch] ) return NO;
    
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( [self containsTouchLocation:touch] && dialogueEnabled)
    {
		textBox = [[TextBoxLayer alloc] initWithColor:[UIColor blueColor] width:200 height:80 padding:10 text:dialogueString];
        textBox.position =  ccp(self.position.x, self.position.y+200);
		
        [model setDelegateForTextBox:textBox];
        [model->dialogue addChild:textBox];
    }
}*/

- (bool)isBlocking
{
    return blocking;
}


- (void) engageTarget
{
    
    //find closest PC
    target = [model findClosestPC:self];        
    
    //move to position 90 px away from closest PC (if multiple PCs are close, just choose one)
    [self calculateVelocity];
    [self avoidOtherNPCs];
    self.position = ccp(self.position.x + velocity.x, self.position.y + velocity.y);
    
}

- (void) attackTarget
{
    if (cType == MELEE_MONSTER) {
        //if next to PC, attack
        float distToPC = distanceBetweenPoints(target.position, self.position);
        if (distToPC < 100){
            [self damageTarget];
        }
    }
}


-(void)draw{
    
    [self drawHealthBar];
    
    ccDrawColor4B(255, 0, 0, 255);
    
    if ([model targetedBySelected:self]) {
        [self drawSelectionBox];
    }
        
    [super draw];
    
}

- (void) drawHealthBar
{
    if(cType != OBJECT){
        CGRect r = [self rectInPixels];
        glLineWidth(5.0);
        
        ccDrawColor4B(0, 0, 0, 255);
        ccDrawLine(ccp(r.size.width/2-25, r.size.height), ccp(r.size.width/2+25, r.size.height));
        
        ccDrawColor4B(255, 0, 0, 255);
        float healthBar = 50*(hp/hpMax);
        ccDrawLine(ccp(r.size.width/2-25, r.size.height), ccp((r.size.width/2-25)+healthBar, r.size.height));
    }
}


-(void)avoidOtherNPCs{
    velocity = ccpAdd(velocity, [model avoidOtherNPCs:self]);
    
    if (velocity.x !=0 || velocity.y !=0) {
        velocity = ccpNormalize(velocity);
        velocity = ccpMult(velocity, speedMultiplier);

    }
}

- (void) makeDead
{
    [model npcDead:self];
}

@end
