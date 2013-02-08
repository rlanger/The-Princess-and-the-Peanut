//
//  RangedAttack.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RangedAttack.h"

@implementation RangedAttack


+ (id)rangedAttackBy:(Character *)attacker on: (Character *)target withTexture: (CCTexture2D *)aTexture andModel: (SceneModel *)aModel
{
    return [[self alloc] initWithAttacker:attacker andTarget:target andTexture:aTexture andModel:aModel];
}

- (id)initWithAttacker:(Character *)attacker andTarget: (Character *)attkTarget andTexture: (CCTexture2D *)aTexture andModel: (SceneModel *)aModel
{
	if ((self = [super initWithTexture:aTexture]) ) {
    
        //NSLog(@"AttkTarget position: %f, %f", attkTarget.position.x, attkTarget.position.y);

        model = aModel;
        target = attkTarget;
        
        //NSLog(@"Target position: %f, %f", target.position.x, target.position.y);
        //NSLog(@"Self position: %f, %f", self.position.x, self.position.y);

        
        CGPoint worldPos = [[self parent] convertToWorldSpace:self.position];
        //NSLog(@"WorldPos position: %f, %f", worldPos.x, worldPos.y);

        CGPoint nodePos = [[target parent] convertToNodeSpace:target.position];
        //NSLog(@"NodePos position: %f, %f", nodePos.x, nodePos.y);
        
        CGPoint modelPos;
        //NSLog(@"NodePos position: %f, %f", modelPos.x, modelPos.y);

        
        velocity.x = 0;
        velocity.y = 0;
        speedMultiplier = 10;
        
                
        [self schedule:@selector(update:)];
                
	}
    
	return self;
}


- (void)update:(ccTime)dt {
    // Adjust z-value
    // int newZ = screenHeight - (self.position.y);
    // [[self parent] reorderChild:self z:newZ];
    
    //NSLog(@"target address %@", target);
    
    // On top of target?
    //if (target != NULL) {
    //NSLog(@"target address %@", target);
    
    //NSLog(@"Target position: %f, %f", targetPosition.x, targetPosition.y);
    //NSLog(@"Self position: %f, %f", self.position.x, self.position.y);
    
    CGPoint worldPos = [[self parent] convertToWorldSpace:self.position];

    
    if (distanceBetweenPoints(target.position, worldPos)<100) {
        NSLog(@"REMOVE ATTK PLEASE");
        //[self removeFromParentAndCleanup:YES];
        //[model attkDone:self];
        
    }
    //}
    
    //targetPosition = target.position;
    
    
    // Move toward target
    [self calculateVelocity];
    self.position = ccp(self.position.x + velocity.x, self.position.y + velocity.y);
    
    
}

- (void) calculateVelocity
{
    
    if (distanceBetweenPoints(target.position, self.position)>1)
    {
        CGPoint toTarget = ccpSub(target.position, self.position);
        
        velocity.x = toTarget.x;
        velocity.y = toTarget.y;
        
        velocity = ccpNormalize(velocity);
        velocity = ccpMult(velocity, speedMultiplier);
        
        //NSLog(@"velocity = %f, %f", velocity.x, velocity.y);
        
    } else {
        velocity.x = 0;
        velocity.y = 0;
    }
    
    //Add boids-like logic to keep monsters from overlapping each other too much
    
}


@end
