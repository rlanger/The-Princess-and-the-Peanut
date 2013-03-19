//
//  FoodSprite.m
//  KoboldTest
//
//  Created by Rebecca Langer on 13-01-24.
//
//

#import "FoodSprite.h"

@implementation FoodSprite

@synthesize foodFood;

+ (id)npcWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType
{
	return [[self alloc] initWithTexture:aTexture andModel:aModel andType:aType];
}

- (id)initWithTexture:(CCTexture2D *)aTexture andModel: (Model *)aModel andType: (ChType)aType
{
	if ((self = [super initWithTexture:aTexture andModel:aModel andType:aType]) ) {
        
        foodFood = [FoodItem foodItemWithName:@"Muffin"];
        
	}
    
	return self;
}

- (FoodItem *) getFoodItem
{
    foodFood = [FoodItem foodItemWithName:@"Muffin"];

    return foodFood;
}


-(void)tapped
{
    
}

@end
