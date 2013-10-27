//
//  OptionsController.h
//  Y-Tiles
//
//  Created by Chris Yunker on 1/3/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardController.h"
#import "Configuration.h"
#import "Constants.h"

#define kOptionsPopoverWidth     300
#define kOptionsPopoverHeight    520

#define kPickerColumnIndex       0
#define kPickerRowIndex          1
#define kBoardTypePhoto          0
#define kBoardTypeNumber         1


@interface OptionsController : UIViewController <UIPickerViewDelegate>
{
	IBOutlet UIPickerView *pickerView;
	IBOutlet UISegmentedControl *boardTypeControl;
	IBOutlet UISwitch *photoNumberSwitch;
	IBOutlet UISwitch *soundSwitch;
	IBOutlet UIButton *resetButton;
	IBOutlet UIButton *saveButton;
	IBOutlet UIButton *cancelButton;
	BoardController *boardController;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *boardTypeControl;
@property (nonatomic, retain) IBOutlet UISwitch *photoNumberSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *soundSwitch;
@property (nonatomic, retain) IBOutlet UIButton *resetButton;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	  boardController:(BoardController *)aBoardController;

- (void)saveButtonAction;
- (void)cancelButtonAction;
- (IBAction)boardTypeControlAction;
- (IBAction)photoNumberSwitchAction;
- (IBAction)soundSwitchAction;
- (IBAction)resetButtonAction;
- (IBAction)saveButtonAction;
- (IBAction)cancelButtonAction;

@end
