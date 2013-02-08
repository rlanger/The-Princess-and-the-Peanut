//
//  MovementLayer.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-08-15.
//  Copyright University of Waterloo 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SceneModel.h"
#import "Constants.h"

// MovementLayer
@interface MovementLayer : CCLayer {
@private
    SceneModel *model;
}

// returns a CCScene that contains the MovementLayer as the only child
+(CCScene *) scene;
+(id)nodeWithGameLevel:(int)level;
- (void) notifyModel: (NSSet *)touches;

@end
