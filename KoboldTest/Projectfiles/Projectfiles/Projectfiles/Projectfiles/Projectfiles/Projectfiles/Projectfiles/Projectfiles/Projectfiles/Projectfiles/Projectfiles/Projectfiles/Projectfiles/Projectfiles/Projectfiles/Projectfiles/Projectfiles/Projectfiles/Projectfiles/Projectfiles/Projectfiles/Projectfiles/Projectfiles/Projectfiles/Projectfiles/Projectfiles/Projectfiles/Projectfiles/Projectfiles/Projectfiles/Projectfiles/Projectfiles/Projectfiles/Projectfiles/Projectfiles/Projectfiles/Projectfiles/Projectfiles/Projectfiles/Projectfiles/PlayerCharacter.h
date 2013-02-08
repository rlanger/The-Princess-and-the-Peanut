//
//  PlayerCharacter.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-08-29.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "Character.h"
#import "LinkedLocation.h"

@class Model;

typedef enum tagTouchState {
	kTouchStateGrabbed,
	kTouchStateUngrabbed
} TouchState;

@interface PlayerCharacter : Character {
@private
	TouchState state;
    CFMutableDictionaryRef map;

@public
    bool selected;
    NSMutableArray *pathArray;
    LinkedLocation *nextLoc;
    LinkedLocation *lastLoc;

}

+ (id)pcWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel;
+ (id)pcWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType) aType;
- (void)goTo:(CGPoint)target;

@end
