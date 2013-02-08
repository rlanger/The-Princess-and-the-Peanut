//
//  Character.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-10-30.
//
//  Base for NPC and PlayerCharacter


#import "Character.h"
#import "SceneModel.h"

@implementation Character

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

+ (id)characterWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType
{
	return [[self alloc] initWithTexture:aTexture andModel:aModel andType:aType];
}

- (id)initWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType
{
	if ((self = [super initWithTexture:aTexture]) ) {
        
        model = aModel;
        
        cType = aType;

        switch (cType) {
            case MELEE_PC:
                hpMax = 100;
                attackSpeed = 2;
                speedMultiplier = 15;
                break;
                
            case RANGED_PC:
                hpMax = 70;
                attackSpeed = 2;
                speedMultiplier = 15;
                break;
                
            case MELEE_MONSTER:
                hpMax = 50;
                attackSpeed = 3;
                speedMultiplier = 6;
                break;
                
            case RANGED_MONSTER:
                hpMax = 25;
                attackSpeed = 3;
                speedMultiplier = 6;
                break;
                
            default:
                hpMax = 50;
                attackSpeed = 3;
                speedMultiplier = 6;
                break;
        } 
        
        hp = hpMax;
        timeSinceLastAttack = attackSpeed;
        
        baseDamage = 3;
        variableDamage = 3;
        
        self.anchorPoint = ccp(0.5f, 0.0f);
        
        CGSize s = [texture_ contentSizeInPixels];
        drawAnchor = ccp(s.width/2,0);
                
        velocity.x = 0;
        velocity.y = 0;
        
        target = NULL;
        
        // screenHeight needed to adjust z-values
        screenHeight = [[CCDirector sharedDirector] winSize].height;

        // Adjusts z-values as often as possible
        [self schedule:@selector(update:)];        
	}
    
	return self;
}

- (void)onEnter
{
	CCDirector *director =  [CCDirector sharedDirector];
    
	//[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
    
}

- (void)onExit
{
	CCDirector *director = [CCDirector sharedDirector];
    
	//[[director touchDispatcher] removeDelegate:self];
	[super onExit];
}

- (bool)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	return CGRectContainsPoint(r, p);
}

/*
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ( ![self containsTouchLocation:touch] ) return NO;
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
// Abstract
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
// Abstract
}
 */

- (void)update:(ccTime)dt {
    // Adjust z-value
    int newZ = screenHeight - (self.position.y);
    [[self parent] reorderChild:self z:newZ];
    
    // Move and/or attack
    if (cType != OBJECT) {
        timeSinceLastAttack = timeSinceLastAttack+dt;
        [self combatAI];
    }

}

- (void)combatAI
{
    if(hp==0){
        [self makeDead];
    }
    
    [self engageTarget];
    
    if (target == NULL) {
        return;
    }
    
    if (timeSinceLastAttack > attackSpeed){
        [self attackTarget];
        timeSinceLastAttack = 0;
    }
}

- (void) calculateVelocity
{
    
    if (distanceBetweenPoints(target.position, self.position)>70)
    {
        CGPoint toTarget = ccpSub(target.position, self.position);
        
        velocity.x = toTarget.x;
        velocity.y = toTarget.y;
        
        velocity = ccpNormalize(velocity);
        velocity = ccpMult(velocity, speedMultiplier);
        
        //NSLog(@"velocity = %f, %f", velocity.x, velocity.y);
        
        //Unless within 100 px, in which case COMPLICATED
    } else {
        velocity.x = 0;
        velocity.y = 0;
    }
    
    //Add boids-like logic to keep monsters from overlapping each other too much
    
}

- (void) calculateVelocityTo: (CGPoint) pcDest
{
    
    //NSLog(@"self.position: %f, %f", self.position.x, self.position.y);
    //NSLog(@"pcDest: %f, %f", pcDest.x, pcDest.y);
    
    NSLog(@"Distance: %f", distanceBetweenPoints(pcDest, self.position));
    
    if (distanceBetweenPoints(pcDest, self.position)>200)
    {
        CGPoint toTarget = ccpSub(pcDest, self.position);
        
        velocity.x = toTarget.x;
        velocity.y = toTarget.y;
        
        velocity = ccpNormalize(velocity);
        velocity = ccpMult(velocity, speedMultiplier);
        
        //NSLog(@"velocity = %f, %f", velocity.x, velocity.y);
        
        //Unless within 100 px, in which case COMPLICATED
    } else {
        velocity.x = 0;
        velocity.y = 0;
    }
    
    //Add boids-like logic to keep monsters from overlapping each other too much
    
}


- (void)damageTarget
{
    int damage = baseDamage + (arc4random() % (variableDamage+1));
    damage = -1 * damage;
    [target adjustHP:damage];
}

- (void)adjustHP:(int)adjustment
{
    int hpNew = hp + adjustment;
    if (hpNew>hpMax) {
        hpNew = hpMax;
    }
    if (hpNew<0) {
        hpNew = 0;
    }
    hp = hpNew;
}


- (void) drawSelectionBox
{
    glLineWidth(5.0);
    CGRect r = [self rect];
    
    CGPoint vertices[4]={
        ccp(r.origin.x+r.size.width/2,r.origin.y),
        ccp(r.origin.x+r.size.width*3/2,r.origin.y),
        ccp(r.origin.x+r.size.width*3/2,r.origin.y+20),
        ccp(r.origin.x+r.size.width/2,r.origin.y+20),
    };
    
    ccDrawPoly(vertices, 4, YES);
}

- (void) drawHealthBar
{
    if(cType != OBJECT){
        CGRect r = [self rect];
        glLineWidth(5.0);
        
        ccDrawColor4B(0, 0, 0, 255);
        //ccDrawLine(ccp(0,r.size.height), ccp(r.size.width,r.size.height));
        ccDrawLine(ccp(r.size.width/2-25, r.size.height), ccp(r.size.width/2+25, r.size.height));
                   
        ccDrawColor4B(0, 255, 0, 255);
        //float healthBar = r.size.width*(hp/hpMax);
        //ccDrawLine(ccp(0,r.size.height), ccp(healthBar,r.size.height));
        float healthBar = 50*(hp/hpMax);
        ccDrawLine(ccp(r.size.width/2-25, r.size.height), ccp((r.size.width/2-25)+healthBar, r.size.height));
    }
}

- (void) makeDead
{
    // Abstract
}

- (void) engageTarget
{
    // Abstract
}

- (void) attackTarget
{
    // Abstract
}

@end
