//
//  Door.m
//  KoboldTest
//
//  Created by Rebecca Langer on 13-02-06.
//
//

#import "Door.h"
#import "SceneManager.h"

@implementation Door


+ (id)npcWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType andConnection: (NSString *)aCon
{
	return [[self alloc] initWithTexture:aTexture andModel:aModel andType:aType andConnection:aCon];
}

- (id)initWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType andConnection: (NSString *)aCon
{
	if ((self = [super initWithTexture:aTexture andModel:aModel andType:aType]) ) {
        connectedLevel = aCon;
	}
    
	return self;
}

-(void)tapped
{
    [SceneManager goString:connectedLevel];
}

@end
