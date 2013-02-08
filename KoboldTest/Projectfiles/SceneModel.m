//
//  SceneModel.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-09-03.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "SceneModel.h"

// Import supporting classes
#import "PlayerCharacter.h"
#import "NPC.h"
#import "SceneView.h"
#import "cocos2d.h"

NSMutableArray *party;
CGSize size;

@implementation SceneModel


// scene has PlayerParty, NPCs, etc
// update ViewNode

+ (SceneModel*)modelWithView:(SceneView *)aView
{
	return [[self alloc] initWithView:aView];
}

// on "init" you need to initialize your instance
-(id) initWithView:(SceneView *)aView
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        view = aView;
                
        size = [[CCDirector sharedDirector] winSize];
        
        mode = 0;
        combat_submode = 0;
        flocking_behaviour = 0;
        startTime = [[NSDate date] timeIntervalSince1970];
        timeElapsed = 0;
        timedLevel = true;
        timeSinceLastMonster = 0;
        monsterSpawnRate = 10;

        //NPCs        
        /*NSMutableArray *npcMArray = [NSMutableArray arrayWithCapacity:3];
        
        CCTexture2D *npcTexture = [[CCTextureCache sharedTextureCache] addImage:@"tree.png"];        
        NPC *npc = [NPC npcWithTexture:npcTexture andModel:self andType:OBJECT];
        npc.position = CGPointMake(700, 250);
        [npcMArray addObject:npc];
        
        npc = [NPC npcWithTexture:npcTexture andModel:self andType:OBJECT];
        npc.position = CGPointMake(500, 250);
        [npcMArray addObject:npc];
        
        npc = [NPC npcWithTexture:npcTexture andModel:self andType:OBJECT];
        npc.position = CGPointMake(200, 250);
        [npcMArray addObject:npc];
        
        npcs = [npcMArray copy];

        for (NPC *npcA in npcs)
            [view addChildToMid:npcA];*/
        
        //MONSTERS
        monsters = [[NSMutableArray alloc] initWithCapacity:1];
        
        CCTexture2D *monsterTexture = [[CCTextureCache sharedTextureCache] addImage:@"tinymonster.png"];        
        NPC *monster = [NPC npcWithTexture:monsterTexture andModel:self andType:MELEE_MONSTER];
        monster.position = [self rndmMonsterStartPoint];
        [monsters addObject:monster];
        
        /*
        monster = [NPC npcWithTexture:monsterTexture andModel:self andType:MELEE_MONSTER];
        monster.position = CGPointMake(550, -1000);
        [monsters addObject:monster];
        
        monster = [NPC npcWithTexture:monsterTexture andModel:self andType:MELEE_MONSTER];
        monster.position = CGPointMake(-3000, 200);
        [monsters addObject:monster];
         */
                
        for (NPC *monsterA in monsters)
            [view addChildToMid:monsterA];
        
        
        //PLAYER PARTY        
        CCTexture2D *princessTexture = [[CCTextureCache sharedTextureCache] addImage:@"soldier.png"];
        CCTexture2D *yellowladyTexture = [[CCTextureCache sharedTextureCache] addImage:@"wizard.png"];
        
        
        NSMutableArray *pcMArray = [NSMutableArray arrayWithCapacity:2];
        
        PlayerCharacter *pc = [PlayerCharacter pcWithTexture:princessTexture andModel:self andType:MELEE_PC];
        pc.position = CGPointMake((size.width/2)-100, size.height/2-150);
        [pcMArray addObject:pc];
        
        pc = [PlayerCharacter pcWithTexture:princessTexture andModel:self andType:MELEE_PC];
        pc.position = CGPointMake((size.width/2), size.height/2-150);
        [pcMArray addObject:pc];
        
        pc = [PlayerCharacter pcWithTexture:yellowladyTexture andModel:self andType:RANGED_PC];
        pc.position = CGPointMake((size.width/2)+100, size.height/2-150);
        [pcMArray addObject:pc];
        
        pcs = [pcMArray copy];
        
        for (PlayerCharacter *pcA in pcs)
            [view addChildToMid:pcA];

        
        
        dPad = view->dPad;
        [self schedule:@selector(step:)];

        //NSLog(@"SceneModel self: %@", self);

        
	}
	return self;
}

-(void) addToView:(CCNode *)aNode
{
    [view addChild:aNode];
}

-(SceneView *) getView
{
    return view;
}

- (void)addDialogue
{
    CCTexture2D *npcTexture = [[CCTextureCache sharedTextureCache] addImage:@"tree.png"];        
    NPC *npc = [NPC npcWithTexture:npcTexture andModel:self andType:OBJECT];
    npc.position = CGPointMake(800, 250);
    
    [view addChildToDialogue:npc];
}

- (int)testVal
{
    return 5;
}


- (void) pcMoved:(PlayerCharacter *)pc byTouch: (UITouch *)touch
{
    // Move PC
    CCNode *node = [view getChildByTag:kTagNode2];
    CGPoint destinationInNode = [node convertTouchToNodeSpace:touch];
    

    // follower destination
    CGPoint followerDestination = [pc convertToWorldSpace:pc.position];
    followerDestination = [node convertToNodeSpace:followerDestination];
    followerDestination = ccp(destinationInNode.x - followerDestination.x, destinationInNode.y - followerDestination.y);
    followerDestination = ccpNormalize(followerDestination);
    followerDestination = ccpMult(followerDestination, 100);
    followerDestination = ccpSub(destinationInNode, followerDestination);
    
    // move PC
    [pc runAction:[CCMoveTo actionWithDuration:ccpDistance(pc.position, destinationInNode)/500 position:destinationInNode]];
    
    if (SCREEN_TRACKS_PC) {
        // Moves the Parallax node to centre the PC
        CGSize screen = [[CCDirector sharedDirector]winSize];
        CGPoint centrePoint = ccp(screen.width/2, screen.height/4);
        CGPoint pcPosition = ccpAdd(centrePoint, destinationInNode);
        pcPosition = ccp(-destinationInNode.x+centrePoint.x, -destinationInNode.y+centrePoint.y);
        
        // Checks to see if PC is up against a border
        if (pcPosition.x > 0) {
            pcPosition.x = 0;
        }
        
        if (pcPosition.y > 0) {
            pcPosition.y = 0;
        }
        
        if(pcPosition.x < screen.width-[view getGroundWidth]){
            pcPosition.x = screen.width-[view getGroundWidth];
        }
        
        [node runAction:[CCMoveTo actionWithDuration:ccpDistance(pc.position, destinationInNode)/500 position:pcPosition]];
    }
    
    
    // Causes PCs that weren't selected to flock behind PC that was moved
    [self flockBehind: pc withDestination: destinationInNode];
        
    //[self flockBehind:pc withMove:[CCMoveTo actionWithDuration:ccpDistance(pc.position, followerDestination)/500 position:followerDestination]];
    
    [self flockBehind:pc toPosition:followerDestination];

}

- (void) flockBehind: (PlayerCharacter *)leader withDestination: (CGPoint) leaderDest
{
    // Causes PCs that weren't selected to flock behind PC that was moved
    if(mode==1 && flocking_behaviour==STAY_LEFT){
                
        for (PlayerCharacter *aPC in pcs){
            if (aPC != leader) {
                //aPC->destination = pc->destination;
                CGPoint followDest = ccp(leaderDest.x-100, leaderDest.y+2);
                [aPC runAction:[CCMoveTo actionWithDuration:ccpDistance(aPC.position, followDest)/500 position:followDest]];
            }
        }
    }
    
  }

- (void) flockBehind: (PlayerCharacter *) leader withMove: (CCMoveTo *) leaderMove
{
    if(mode==1 && flocking_behaviour==FOLLOW_EXACTLY){
        
        for (PlayerCharacter *aPC in pcs){
            if (aPC != leader) {
                [aPC runAction:[CCSequence actions:
                                [CCDelayTime actionWithDuration:0.5],
                                leaderMove,
                                nil
                                ]
                 ];
            }
        }
        
    }
}

- (void) flockBehind: (PlayerCharacter *) leader toPosition: (CGPoint) dest {
    if(mode==1 && flocking_behaviour==FOLLOW_EXACTLY){
        
        for (PlayerCharacter *aPC in pcs){
            if (aPC != leader) {
                [aPC runAction:[CCSequence actions:
                                [CCDelayTime actionWithDuration:0.5],
                                [CCMoveTo actionWithDuration:ccpDistance(aPC.position, dest)/500 position:dest],
                                nil
                                ]
                 ];
            }
        }
        
    }
}

- (void) pcDrag: (UITouch *)touch
{
    if(SCREEN_TRACKS_PC){
    // Scrolls the screen
    CGPoint touchLocation = [touch locationInView: [touch view]];
    CGPoint prevLocation = [touch previousLocationInView: [touch view]];
    
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
    
    CCNode *node = [view getChildByTag:kTagNode2];
    CGPoint destinationInNode = [node convertTouchToNodeSpace:touch];
    
    CGPoint negDiff = ccpSub(prevLocation, touchLocation);        
    CGPoint currentPos = [node position];
    
    CGPoint newPos = ccpAdd(currentPos, negDiff);
    
    newPos = [[CCDirector sharedDirector] convertToGL:newPos];
    
    if (newPos.x > 0 && destinationInNode.y > 0) {

        [node setPosition: ccpAdd(currentPos, negDiff)];
    }
    }
    

}

- (void) moveSelectedTo: (UITouch *)touch
{
    // hack :(
    CGPoint startingPosition = ccp(0,0);
    
    CCNode *node = [view getChildByTag:kTagNode2];
    CGPoint destinationInNode = [node convertTouchToNodeSpace:touch];
    for (PlayerCharacter *aPC in pcs){
        if (aPC->selected == TRUE) {
            [aPC runAction:[CCMoveTo actionWithDuration:ccpDistance(aPC.position, destinationInNode)/500 position:destinationInNode]];
            startingPosition = aPC.position;
        }
    
    }
    
    if(SCREEN_TRACKS_PC){
        // Moves the Parallax node to centre the PC
        CGSize screen = [[CCDirector sharedDirector]winSize];
        CGPoint centrePoint = ccp(screen.width/2, screen.height/4);
        CGPoint pcPosition = ccpAdd(centrePoint, destinationInNode);
        pcPosition = ccp(-destinationInNode.x+centrePoint.x, -destinationInNode.y+centrePoint.y);
    
        [node runAction:[CCMoveTo actionWithDuration:ccpDistance(startingPosition, destinationInNode)/500 position:pcPosition]];

    }
}

- (void) deselectPCs
{
    for (PlayerCharacter *aPC in pcs){
        aPC->selected = FALSE;
    }
}


// Use for Drag Path method
- (void) pcFollowPath: (PlayerCharacter *)pc
{
    CCNode *node = [view getChildByTag:kTagNode2];
    NSLog(@"FOLLOW");

    //create mutable array
    NSMutableArray *actionList = [[NSMutableArray alloc] initWithCapacity:1];
    CGPoint previousPosition = pc.position;
    
    while(pc->nextLoc != pc->lastLoc && pc->nextLoc != NULL){
    
        CGPoint destinationRelPC = CGPointMake(pc->nextLoc->x, pc->nextLoc->y);
        CGPoint destinationInWorld = [pc convertToWorldSpace:destinationRelPC];
        CGPoint destinationInNode = [node convertToNodeSpace:destinationInWorld];
        
        NSLog(@"Next destination = %f, %f", destinationRelPC.x, destinationRelPC.y);
        
        //add move to mutable array
        [actionList addObject:[CCMoveTo actionWithDuration:ccpDistance(previousPosition,destinationInNode)/500 position:destinationInNode]];
        
        previousPosition = destinationInNode;
        pc->nextLoc = pc->nextLoc->next;
        
    }
    
    //create sequence from array of moves
    CCSequence *moveSequence = [CCSequence actionMutableArray:actionList];
    
    //run sequence
    [pc runAction:moveSequence];
    
}


-(void) step:(ccTime)delta {
    
    // Move PC in direction determined by dPad
    for (PlayerCharacter *aPC in pcs){
        if (aPC->selected == TRUE) {
            if(aPC->velocity.x != dPad.pressedVector.x*2 || aPC->velocity.y != dPad.pressedVector.y*2){
                aPC->velocity = ccp(dPad.pressedVector.x*15, dPad.pressedVector.y*15);
            }
        }
    }
    
    // Add a monster
    timeSinceLastMonster = timeSinceLastMonster + delta;
    if (timeSinceLastMonster > monsterSpawnRate){
        [self addMonster];
        timeSinceLastMonster = 0;
    }
    
    
    // Update timeElapsed
    double now = [[NSDate date] timeIntervalSince1970];
    timeElapsed=now - startTime;
    
    // End round?
    if (timeElapsed >= 30){
        [self roundComplete];
    }

}

-(void) addMonster
{
    CCTexture2D *monsterTexture = [[CCTextureCache sharedTextureCache] addImage:@"tinymonster.png"];        
    NPC *monster = [NPC npcWithTexture:monsterTexture andModel:self andType:MELEE_MONSTER];
    monster.position = [self rndmMonsterStartPoint];
    [monsters addObject:monster];
    
    [view addChildToMid:monster];
}


-(void) setCombatSubmode:(int)newMode {
    combat_submode = newMode;
    
    if(combat_submode == MOVE_PAD){
        //add movepad
        [view addChild:dPad];
    } else {
        //remove movepad
        [view removeChild:dPad cleanup:NO];
    }
}

-(void) setFlockingBehaviour:(int)newMode {
    flocking_behaviour = newMode;
}

-(PlayerCharacter *) findClosestPC:(NPC *)monster {
    float bestDistance = -1;
    float tempDistance = -1;
    PlayerCharacter *returnPC;
    
    for (PlayerCharacter *aPC in pcs){
        tempDistance = distanceBetweenPoints(monster.position, aPC.position);
        if (bestDistance==-1 || tempDistance<bestDistance) {
            bestDistance = tempDistance;
            returnPC = aPC;
        }
    }
    
    return returnPC;
    
}

-(bool) targetedBySelected: (NPC *)monster {
    for (PlayerCharacter *aPC in pcs){
        if (aPC->selected == TRUE) {
            if(aPC->target == monster){
                return true;
            }
        }
    }
    
    return false;
}

- (NPC *) monsterTouched: (UITouch *) touch
{
    for (NPC *monster in monsters){
        if ([monster containsTouchLocation:touch]) {
            return monster;
        }
    }    
    return NULL;
}

- (PlayerCharacter *) pcTouched: (UITouch *) touch
{
    for (PlayerCharacter *aPC in pcs){
        if ([aPC containsTouchLocation:touch]) {
            return aPC;
        }
    }    
    return NULL;
}

- (void) npcDead: (NPC *)monster
{
    //NSLog( NSStringFromClass( [npcs class] ));
    
    for (PlayerCharacter *aPC in pcs){
        if (aPC->target == monster){
            aPC->target = NULL;
        }
    }
    
    for (RangedAttack *attk in attackSprites){
        if (attk->target == monster){
            attk->target = NULL;
            //[attackSprites removeObject:attk];
            //[attk removeFromParentAndCleanup:YES];
        }
    }
    
    [monsters removeObject:monster];
    //monster = nil;
    [monster removeFromParentAndCleanup:YES];
    
    NSLog(@"Number of monsters = %d", [monsters count]);
    if ([monsters count] == 0 && timedLevel==false) {
        [self roundComplete];
    }
}

- (void) attkDone: (RangedAttack *)attk
{
    [attackSprites removeObject:attk];
    [attk removeFromParentAndCleanup:YES];
}

-(CGPoint) avoidOtherNPCs:(NPC *)monster
{
    
    float distance;
    CGPoint tempVector;
    CGPoint finalVector = ccp(0,0);
    
    for (NPC *otherMonster in monsters){
        if (otherMonster != monster && otherMonster != NULL) {
            distance = distanceBetweenPoints(monster.position, otherMonster.position);
            if (distance < 70) {
                tempVector = ccpSub(monster.position, otherMonster.position);
                finalVector = ccpAdd(finalVector, tempVector);
            }
        }
    }
    
    /*
    if (finalVector.x != 0 || finalVector.y != 0) {
        finalVector = ccpNormalize(finalVector);
    }*/
    
    return finalVector;
    
}

- (void) roundComplete
{
    // Wait a short time... maybe victory dance?
    
    // pause / grey out game
    // is level complete? if no...
    
    CCScene *scene = [CCScene node];
    [scene addChild:[MainMenu node]];
    [[CCDirector sharedDirector] replaceScene:scene];
    
    // Dialogue:
    // Round Complete
    // Next: Round #/MAX
    // Technique name / illustration
    // [START]
    
    // When START pressed run [self newRound:# technique:#]
    // 0 = training
}

- (void) newRound: (int) roundNumber technique: (CombatMovement) technique
{
    
    
    // black screen?
    // reset hp, PC positions
    // set movement mode
    // reveal screen?
    
    // spawn monsters on schedule determined by roundNumber
    
}



- (CompassDirection) randomDirection
{
    CompassDirection randomDir = (CompassDirection) (arc4random() % (int) CompassMax);
    return randomDir;
}

- (CGPoint) rndmMonsterStartPoint
{
    CompassDirection dir = [self randomDirection];
    size = [[CCDirector sharedDirector] winSize];
    int awayFromEdge = 100;

    switch (dir) {
        case N:
        case NNE:
            return CGPointMake(size.width/2, size.height+awayFromEdge);
            break;
            
        case NE:
        case ENE:
            return CGPointMake(size.width+awayFromEdge, size.height+awayFromEdge);
            break;
            
        case E:
        case ESE:
            return CGPointMake(size.width+awayFromEdge, size.height/2);
            break;
            
        case SE:
        case SSE:
            return CGPointMake(size.width+awayFromEdge, 0-awayFromEdge);
            break;
            
        case S:
        case SSW:
            return CGPointMake(size.width/2, 0-awayFromEdge);
            break;
            
            
        case SW:
        case WSW:
            return CGPointMake(0-awayFromEdge, 0-awayFromEdge);
            break;
            
        case W:
        case WNW:
            return CGPointMake(0-awayFromEdge, size.height/2);
            break;
            
        case NW:
        case NNW:
            return CGPointMake(0-awayFromEdge, size.height+awayFromEdge);
            break;
            
        default:
            return CGPointMake(size.width/2, size.height/2);
            break;
    }
    
}

- (void) rangedAttackBy:(Character *) attacker On:(Character *) target
{    
    CCTexture2D *attkTexture = [[CCTextureCache sharedTextureCache] addImage:@"fireball.png"];
    RangedAttack *attkSprite = [RangedAttack rangedAttackBy:attacker on:target withTexture:attkTexture andModel:self];
    attkSprite.position = attacker.position;
    [attackSprites addObject:attkSprite];
    [view addChildToMid:attkSprite];
}

- (CGPoint) getPositionOf: (RangedAttack *) aNode
{
    return aNode.position;
}


- (PlayerCharacter *) getTouchedPC: (UITouch *) touch
{
    for (PlayerCharacter *aPC in pcs){
        if ([aPC containsTouchLocation:touch] == TRUE) {
            return aPC;
        }
    }
    return NULL;
}

- (PlayerCharacter *) selectedPC
{
    for (PlayerCharacter *aPC in pcs){
        if (aPC->selected == TRUE) {
            return aPC;
        }
    }
    return NULL;
}

- (void) processTouches: (NSSet *)touches {
    
    NSLog(@"TOUCHES");
    
    bool touchChanged = false;
    UITouch *keepTouch;
    
    PlayerCharacter *selectedPC = [self selectedPC];

    
    for (PlayerCharacter *aPC in pcs){
        for (UITouch *touch in touches) {
            keepTouch = touch;
            if ([aPC containsTouchLocation:touch] == TRUE) {
                if (selectedPC != NULL){
                    selectedPC->selected = false;
                }
                aPC->selected = true;
            } else {
                //aPC->selected = false;
            }
        }
    }
    
    NPC *targetMonster;
    targetMonster = NULL;
    
    for (NPC *monster in monsters){
        for (UITouch *touch in touches) {
            if ([monster containsTouchLocation:touch] == TRUE) {
                targetMonster = monster;
            }
        }
        
        
    }
    
    
    if (selectedPC != NULL && targetMonster != NULL) {
            selectedPC->destination = [selectedPC convertTouchToNodeSpace:keepTouch];
            NSLog(@"NEW DESTINATION");
            selectedPC->target = targetMonster;
    }
    
    if (selectedPC != NULL) {
        selectedPC->destination = [selectedPC convertTouchToNodeSpace:keepTouch];
        NSLog(@"NEW DESTINATION");
    }

    
    
    /*                if (aPC->selected == false){
     touchChanged = true;
     }*/
    /*
    PlayerCharacter *pc;
    pc = NULL;
    
    for (UITouch *touch in touches) {
        pc = [self getTouchedPC:touch];
        if (pc != NULL) {
            pc->selected = TRUE;
            pc = NULL;
        }
    }*/
}


@end
