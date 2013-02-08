//
//  Door.h
//  KoboldTest
//
//  Created by Rebecca Langer on 13-02-06.
//
//

#import "NPC.h"

@interface Door : NPC {
    @public
    NSString *connectedLevel;
    
}

+ (id)npcWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType andConnection: (NSString *)aCon;
- (void)tapped;


@end
