//
//  Global.h
//  KoboldTest
//
//  Created by Rebecca Langer on 13-01-27.
//
//

#import <Foundation/Foundation.h>
#import "Inventory.h"
#import "SceneManager.h"
#import "SynthesizeSingleton.h"

@interface Global : NSObject <NSCoding> {
@public
    Inventory *inventory;
    //SceneManager *sceneManager;
    NSArray *allergens, *possibleAllergens;
    
    bool combatOn;
    
}

@property Inventory *inventory;
//@property SceneManager *sceneManager;
@property NSArray *allergens, *possibleAllergens;

//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(Global);

+ (Global*)sharedState;

- (void) addToInventory:(FoodItem *) item;

@end
