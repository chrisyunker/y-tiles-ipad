//
//  BoardController.h
//  Y-Tiles
//
//  Created by Chris Yunker on 1/7/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "StatusDisplay.h"


@class Board;

@interface BoardController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
	Board *board;
	UIImageView *boardPhoto;
	IBOutlet UIImageView *display;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UISegmentedControl *displayModeControl;
	IBOutlet UIBarButtonItem *optionsButton;
	IBOutlet UIBarButtonItem *libraryPhotoButton;
	IBOutlet UIBarButtonItem *stockPhotoButton;
	IBOutlet UIBarButtonItem *aboutBarButton;
	IBOutlet UIButton *aboutButton;
	IBOutlet StatusDisplay *movesDisplay;
	IBOutlet StatusDisplay *timeDisplay;
	UIPopoverController *libraryPhotoPopover;
	UIPopoverController *stockPhotoPopover;
	UIPopoverController *optionsPopover;
	UINavigationController *aboutNavController;
}

@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) UIImageView *boardPhoto;
@property (nonatomic, retain) IBOutlet UIImageView *display;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *displayModeControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *optionsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *libraryPhotoButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *stockPhotoButton;
@property (nonatomic, retain) IBOutlet UIButton *aboutButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *aboutBarButton;
@property (nonatomic, retain) IBOutlet StatusDisplay *movesDisplay;
@property (nonatomic, retain) IBOutlet StatusDisplay *timeDisplay;

- (IBAction)libraryPhotoButtonAction;
- (IBAction)stockPhotoButtonAction;
- (IBAction)optionsButtonAction;
- (IBAction)displayModeControlAction;
- (IBAction)aboutButtonAction;
- (void)selectPhoto:(UIImage *)photo type:(int)type;
- (void)saveConfiguration;
- (void)resetGame;
- (void)saveGame;
- (void)dismissAboutController;

@end
