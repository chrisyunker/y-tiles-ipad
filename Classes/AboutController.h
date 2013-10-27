//
//  AboutController.h
//  Y-Tiles
//
//  Created by Chris Yunker on 2/18/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardController.h"
#import "Constants.h"

#define kAboutPopoverWidth       492
#define kAboutPopoverHeight      220

#define kAboutImageName          @"AboutIcon"
#define kAboutImageType          @"png"


@class BoardController;

@interface AboutController : UIViewController
{
	IBOutlet UILabel *versionLabel;
	IBOutlet UIImageView *icon;
	BoardController *boardController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	  boardController:(BoardController *)aBoardController;

@property (nonatomic, retain) IBOutlet UILabel *versionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *icon;

@end
