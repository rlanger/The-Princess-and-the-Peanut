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
    
}

@property Inventory *inventory;
//@property SceneManager *sceneManager;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(Global);

+(id)sharedState;

@end
