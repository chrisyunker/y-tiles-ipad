//
//  Y_TilesAppDelegate.m
//  Y-Tiles
//
//  Created by Chris Yunker on 7/11/10.
//  Copyright chrisyunker.com 2010. All rights reserved.
//

#import "Y_TilesAppDelegate.h"
#import "BoardController.h"


@implementation Y_TilesAppDelegate


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		
	boardController = [[BoardController alloc] initWithNibName:@"BoardController" bundle:nil];
	
	[window addSubview:boardController.view];
    [window makeKeyAndVisible];
		
    return YES;	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	DLog("applicationWillTerminate");
	[boardController saveGame];
}


#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	DLog("applicationDidReceiveMemoryWarning");
}

- (void)dealloc
{
	DLog("dealloc");
	[window release];
	[boardController release];
	[super dealloc];
}

@end

