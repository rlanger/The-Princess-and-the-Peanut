//
//  SceneModel.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-09-03.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "CombatModel.h"
#import "Global.h"

// Import supporting classes


NSMutableArray *party;
CGSize size;

@implementation CombatModel


// scene has PlayerParty, NPCs, etc
// update ViewNode

+ (CombatModel *)modelWithView:(CombatView *)aView
{
	return [[self alloc] initWithView:aView];
}

// on "init" you need to initialize your instance
-(id) initWithView:(CombatView *)aView
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
        npcs = [[NSMutableArray alloc] initWithCapacity:1];

        
        CCTexture2D *monsterTexture = [[CCTextureCache sharedTextureCache] addImage:@"tinymonster.png"];
        NPC *monster = [NPC npcWithTexture:monsterTexture andModel:self andType:MELEE_MONSTER];
        monster.position = [self randomLocation];
        [npcs addObject:monster];
        
        
        
        //PLAYER PARTY
        CCTexture2D *princessTexture = [[CCTextureCache sharedTextureCache] addImage:@"princess-cutout.png"];
        
        NSMutableArray *pcMArray = [NSMutableArray arrayWithCapacity:1];
        
        PlayerCharacter *pc = [PlayerCharacter pcWithTexture:princessTexture andModel:self andType:MELEE_PC];
        pc.position = CGPointMake((size.width/2)-100, size.height/2-150);
        [pcMArray addObject:pc];
        
        pcs = [pcMArray copy];
        
        for (PlayerCharacter *pcA in pcs)
            [view addChildToMid:pcA];
        
        
        //FOODS
        foods = [[NSMutableArray alloc] initWithCapacity:1];
        
        [self addRandomBread];
        

        
        
        [self schedule:@selector(step:)];
        
        //NSLog(@"SceneModel self: %@", self);
        
        
	}
	return self;
}

-(void) addToView:(CCNode *)aNode
{
    [view addChild:aNode];
}

-(CombatView *) getView
{
    return view;
}

- (void) pcMoved:(PlayerCharacter *)pc byTouch: (UITouch *)touch
{
    // Move PC
    CCNode *node = [view getChildByTag:kTagNode];
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
    //[self flockBehind: pc withDestination: destinationInNode];
    
    //[self flockBehind:pc withMove:[CCMoveTo actionWithDuration:ccpDistance(pc.position, followerDestination)/500 position:followerDestination]];
    
    //[self flockBehind:pc toPosition:followerDestination];
    
}

- (void) pcDrag: (UITouch *)touch
{
    if(SCREEN_TRACKS_PC){
        // Scrolls the screen
        CGPoint touchLocation = [touch locationInView: [touch view]];
        CGPoint prevLocation = [touch previousLocationInView: [touch view]];
        
        touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
        prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
        
        
        CCNode *node = [view getChildByTag:kTagNode];
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
    
    CCNode *node = [view getChildByTag:kTagNode];
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
    CCNode *node = [view getChildByTag:kTagNode];
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
        if (aPC->selected == TRUE) {}
    }
    
    // Add a bread
    timeSinceLastMonster = timeSinceLastMonster + delta;
    if (timeSinceLastMonster > monsterSpawnRate){
        [self addRandomBread];
        timeSinceLastMonster = 0;
    }
    
    
    // Update timeElapsed
    double now = [[NSDate date] timeIntervalSince1970];
    timeElapsed=now - startTime;
    
}

-(void) addMonster
{
    CCTexture2D *monsterTexture = [[CCTextureCache sharedTextureCache] addImage:@"tinymonster.png"];
    NPC *monster = [NPC npcWithTexture:monsterTexture andModel:self andType:MELEE_MONSTER];
    monster.position = ccp(200,200);
    [monsters addObject:monster];
    
    [view addChildToMid:monster];
}

-(void) addRandomBread
{
    CCTexture2D *breadTexture = [[CCTextureCache sharedTextureCache] addImage:@"muffin.png"];
    FoodSprite *bread = [FoodSprite npcWithTexture:breadTexture andModel:self andType:OBJECT];
    
    bread.position = [self randomLocation];
    [foods addObject:bread];
    
    [view addChildToMid:bread];
    
}


-(void) setCombatSubmode:(int)newMode {
    combat_submode = newMode;
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



- (CGPoint) randomLocation
{
    // ask director for the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    int randomX = (arc4random() % (int) (size.width-100))+50;
    int randomY = (arc4random() % (int) (size.height-100))+50;
    return ccp(randomX, randomY);
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
    
    //bool touchChanged = false;
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
    
    for (unsigned int i=0; i<[foods count]; i++){
        for (UITouch *touch in touches) {
            if ([foods[i] containsTouchLocation:touch] == TRUE) {
                
                UIAlertView* dialog = [[UIAlertView alloc] init];
                [dialog setDelegate:self];
                [dialog setTitle:@"You found a muffin!"];
                [dialog setMessage:@"Ingredients Here"];
                [dialog addButtonWithTitle:@"Take"];
                [dialog addButtonWithTitle:@"Destroy"];
                [dialog show];
                dialog.tag = i;
                
                return;
                
            }
        }
    }
    
    for (unsigned int i=0; i<[doors count]; i++){
        for (UITouch *touch in touches) {
            if ([doors[i] containsTouchLocation:touch] == TRUE) {
                
                [doors[i] tapped];
                
                return;
                
            }
        }
    }
    
    
    if (selectedPC != NULL && targetMonster != NULL) {
        selectedPC->destination = [selectedPC convertTouchToNodeSpace:keepTouch];
        CGPoint p = [self convertTouchToNodeSpaceAR:keepTouch];
        NSLog(@"NEW DESTINATION: %f, %f", p.x, p.y);
        selectedPC->target = targetMonster;
    }
    
    if (selectedPC != NULL) {
        selectedPC->destination = [selectedPC convertTouchToNodeSpace:keepTouch];
        CGPoint p = [self convertTouchToNodeSpaceAR:keepTouch];
        NSLog(@"NEW DESTINATION: %f, %f", p.x, p.y);
        
        id action = [CCMoveBy actionWithDuration: 0.5 position: selectedPC->destination];
        [selectedPC runAction: action];
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    
    if (buttonIndex==0){
        //add muffin to inventory
        
        Global *sharedState = [Global sharedState];
        
        FoodSprite *tappedFood = foods[alertView.tag];
        
        FoodItem *tappedFoodItem = [tappedFood getFoodItem];
        
        [sharedState addToInventory:tappedFoodItem];
        
        
        [foods[alertView.tag] makeDead];
    }
    
    if (buttonIndex==1){
        [foods[alertView.tag] makeDead];
    }
    
}

@end
