//
//  Model.h
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import "NPC.h"
#import "PlayerCharacter.h"
#import "CCNode.h"

@interface Model : CCNode
{
@public
    int combat_submode;
}

- (PlayerCharacter *) findClosestPC:(NPC *)monster;
- (void) npcDead: (NPC *)monster;
-(CGPoint) avoidOtherNPCs:(NPC *)monster;
- (bool) targetedBySelected: (NPC *)monster;



@end
