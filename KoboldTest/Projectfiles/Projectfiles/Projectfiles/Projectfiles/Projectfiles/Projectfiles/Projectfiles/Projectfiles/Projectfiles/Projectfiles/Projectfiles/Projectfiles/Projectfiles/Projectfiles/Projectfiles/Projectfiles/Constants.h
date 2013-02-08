//
//  Constants.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-10-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


typedef enum tagCombatMovement {
    DRAG_DESTINATION_WAIT,
    DRAG_PATH_WAIT,
    DRAG_DIRECTION,
    DRAG_PATH_NOWAIT,
    TAP_DESTINATION,
    TAP_DIRECTION,
    MOVE_PAD
} CombatMovement;

typedef enum tagFlockingBehaviour {
    STAY_LEFT,
    FOLLOW_EXACTLY,
    BOIDS
} FlockingBehaviour;

typedef enum tagCharacterType {
    MELEE_PC,
    RANGED_PC,
    MELEE_MONSTER,
    RANGED_MONSTER,
    OBJECT
} ChType;

#define SCREEN_TRACKS_PC FALSE
