//
//  NPC.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-09-12.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "TextBox.h"
#import "Character.h"
#import "cocos2d.h"

@class Model;

@interface NPC : Character {
@private
    NSString *dialogueString;
    bool dialogueEnabled;
    bool blocking;
}

+ (id)npcWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType;
- (bool)isBlocking;
- (void) makeDead;

@end
