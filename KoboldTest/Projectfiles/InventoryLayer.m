
//
//  InventoryLayer.m
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

// Import the interfaces
#import "InventoryLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - InventoryLayer


@implementation InventoryLayer




// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InventoryLayer *layer = [InventoryLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Inventory" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2+200 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Inventory List
		//
        
        inventory = [Inventory createInventory];
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
        //Declare CCMenuItem array (size determined by [Inventory getSize])
        //Use for loop to create all menu items from inventory items
        
        
        menu = [CCMenu menuWithItems:nil];
        
        // Add the menu to the layer
        [self addChild:menu];
        
        for (FoodItem *food in inventory->foods) {
            CCMenuItemFont *item = [CCMenuItemFont itemWithString: [food getName] block:^(id sender){
               // Use, Inspect, Discard
                UIAlertView* dialog = [[UIAlertView alloc] init];
                [dialog setDelegate:self];
                [dialog setTitle:[food getName]];
                [dialog addButtonWithTitle:@"Eat"];
                [dialog addButtonWithTitle:@"Inspect"];
                [dialog addButtonWithTitle:@"Discard"];
                [dialog addButtonWithTitle:@"Cancel"];

                [dialog show];
                dialog.tag=[food getID];
            }];
            [menu addChild:item];
        }
        
		[menu alignItemsVerticallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
        
        CCMenu *modeMenu = [CCMenu menuWithItems:nil];
        
        // Add the menu to the layer
        [self addChild:modeMenu];
        
        CCMenuItemFont *scanItem = [CCMenuItemFont itemWithString: @"Scan" block:^(id sender){
            // Launch scanner
            
            // Need to release these at some point. :(
            UIViewController* myController = [[UIViewController alloc] init];
            [[[CCDirector sharedDirector] openGLView] addSubview:myController.view];
            
            // ADD: present a barcode reader that scans from the camera feed
            ZBarReaderViewController *reader = [ZBarReaderViewController new];
            reader.readerDelegate = self;
            reader.supportedOrientationsMask = ZBarOrientationMaskAll;
            
            ZBarImageScanner *scanner = reader.scanner;
            // TODO: (optional) additional reader configuration here
            
            // EXAMPLE: disable rarely used I2/5 to improve performance
            [scanner setSymbology: ZBAR_I25
                           config: ZBAR_CFG_ENABLE
                               to: 0];
            
            // present and release the controller
            [myController presentModalViewController: reader animated: YES];
        }];
        [modeMenu addChild:scanItem];
        
        CCMenuItemFont *cancel = [CCMenuItemFont itemWithString: @"Cancel" block:^(id sender){
            //Return to Nav mode
            NSLog(@"CANCEL");
            
            [SceneManager goNavLayer];
            
            /*CCScene *scene = [CCScene node];
            [scene addChild:[NavLayer nodeWithGameLevel:1]];
            [[CCDirector sharedDirector] replaceScene:scene];*/
            
        }];
        [modeMenu addChild:cancel];
        
		[modeMenu alignItemsHorizontallyWithPadding:20];
		[modeMenu setPosition:ccp( size.width/2, 100)];
        
	}
	return self;
}


- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    NSLog(@"ImagePickerController");
    
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    NSString *resultString = symbol.data;
    NSString *foodString = @"Unknown";
    if ([resultString isEqualToString:@"0061362434308"]) {
        foodString = @"Tuna";
    }
    
    UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Results"];
	[dialog setMessage:foodString];
	[dialog addButtonWithTitle:@"Take"];
	[dialog addButtonWithTitle:@"Discard"];
	[dialog show];
    dialog.tag = -1;

    
    
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);

    if (buttonIndex==0 && alertView.tag==-1){
        FoodItem *newFood = [FoodItem foodItemWithName:@"Tuna"];
        //[inventory addItem:newFood];
        CCMenuItemFont *item = [CCMenuItemFont itemWithString: [newFood getName] block:^(id sender){
            // Use, Inspect, Discard
        }];
        [menu addChild:item];
        
        [menu alignItemsVerticallyWithPadding:20];
		//[menu setPosition:ccp( size.width/2, size.height/2 - 50)]
    }
    
}

@end


