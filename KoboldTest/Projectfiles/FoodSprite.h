//
//  FoodSprite.h
//  KoboldTest
//
//  Created by Rebecca Langer on 13-01-24.
//
//

#import "NPC.h"
#import "FoodItem.h"

@interface FoodSprite : NPC {
    @public
    FoodItem *foodFood;
}

@property FoodItem *foodFood;

- (FoodItem *) getFoodItem;

@end
