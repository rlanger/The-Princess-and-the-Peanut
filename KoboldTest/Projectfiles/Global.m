#import "Global.h"
#import "Constants.h"

@implementation Global

static Global *sharedState = nil;

@synthesize inventory;
//@synthesize sceneManager;

+ (Global *)sharedState {
    if (sharedState == nil) {
        sharedState = [[super allocWithZone:NULL] init];
    }
    
    return sharedState;
}

-(id)init {
    if(!(self = [super init]))
        return nil;
    self.inventory = [Inventory createInventory];
    
    return self;
}

+(id)alloc {
    @synchronized([Global class]) {
        NSAssert(sharedState == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedState = [super alloc];
        return sharedState;
    }
    return nil;
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedState];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


-(void)encodeWithCoder:(NSCoder *)coder {

}

-(id)initWithCoder:(NSCoder *)coder {
    CCLOG(@"initWithCoder called");
    self = [super init];
    if(self != nil) {
        CCLOG(@"initWithCoder self exists");

    }
    return self;
}
@end