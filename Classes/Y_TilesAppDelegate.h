//
//  Y_TilesAppDelegate.h
//  Y-Tiles
//
//  Created by Chris Yunker on 7/11/10.
//  Copyright chrisyunker.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardController.h"

@interface Y_TilesAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
	BoardController *boardController;
}

@end
