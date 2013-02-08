//
//  Model.m
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import "Model.h"

@implementation Model

- (PlayerCharacter *) findClosestPC:(NPC *)monster{return [PlayerCharacter init];}

- (void) npcDead: (NPC *)monster
{return;}

-(CGPoint) avoidOtherNPCs:(NPC *)monster
{return ccp(0,0);}

- (bool) targetedBySelected: (NPC *)monster
{return true;}

@end
