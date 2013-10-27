//
//  OptionsController.m
//  Y-Tiles
//
//  Created by Chris Yunker on 1/3/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import "OptionsController.h"

@interface OptionsController (Private)

- (void)updatePhotoNumberSwitch;

@end

@implementation OptionsController

@synthesize pickerView;
@synthesize boardTypeControl;
@synthesize photoNumberSwitch;
@synthesize soundSwitch;
@synthesize saveButton;
@synthesize resetButton;
@synthesize cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	  boardController:(BoardController *)aBoardController
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{		
		boardController = [aBoardController retain];
		[self setTitle:NSLocalizedString(@"OptionsTitle", @"")];
		[self setContentSizeForViewInPopover:CGSizeMake(kOptionsPopoverWidth,
														kOptionsPopoverHeight)];
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	ALog("didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{		 
	if (interfaceOrientation == UIInterfaceOrientationPortrait)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (void)updateControlsWithAnimation:(BOOL)animated
{
	[pickerView selectRow:(boardController.board.config.columns - kColumnsMin)
			  inComponent:kPickerColumnIndex animated:animated];
	[pickerView selectRow:(boardController.board.config.rows - kRowsMin)
			  inComponent:kPickerRowIndex animated:animated];
	
	if (boardController.board.config.photoEnabled)
	{
		[boardTypeControl setSelectedSegmentIndex:kBoardTypePhoto];
	}
	else
	{
		[boardTypeControl setSelectedSegmentIndex:kBoardTypeNumber];
	}
	[self updatePhotoNumberSwitch];

	[photoNumberSwitch setOn:boardController.board.config.numbersEnabled
					animated:animated];
	[soundSwitch setOn:boardController.board.config.soundEnabled
			  animated:animated];
}

- (void)enableButtons:(BOOL)value
{
	[saveButton setEnabled:value];
	[cancelButton setEnabled:value];
}

- (void)setEnabled:(BOOL)value
{
	[boardTypeControl setEnabled:value];
	[photoNumberSwitch setEnabled:value];
	[soundSwitch setEnabled:value];
	
	if (value)
	{		
		[self updateControlsWithAnimation:YES];
		[self enableButtons:NO];
	}
	else
	{
		[self enableButtons:NO];
	}
}

- (void)viewWillAppear:(BOOL)animated
{	
	[super viewWillAppear:animated];
	[self updateControlsWithAnimation:NO];
	[self enableButtons:NO];
}

- (void)viewDidLoad 
{	
	[super viewDidLoad];
	DLog("viewDidLoad");
	
	UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *buttonBackgroundSelected = [UIImage imageNamed:@"blueButton.png"];
	
	[saveButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[saveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[cancelButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[resetButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[resetButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];

	UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0
															  topCapHeight:0.0];
	[saveButton setBackgroundImage:newImage forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:newImage forState:UIControlStateNormal];
	[resetButton setBackgroundImage:newImage forState:UIControlStateNormal];

	UIImage *newSelectedImage = [buttonBackgroundSelected stretchableImageWithLeftCapWidth:12.0
																			  topCapHeight:0.0];
	[saveButton setBackgroundImage:newSelectedImage forState:UIControlStateHighlighted];
	[cancelButton setBackgroundImage:newSelectedImage forState:UIControlStateHighlighted];
	[resetButton setBackgroundImage:newSelectedImage forState:UIControlStateHighlighted];
	
	[saveButton setBackgroundColor:[UIColor clearColor]];
	[cancelButton setBackgroundColor:[UIColor clearColor]];
	[resetButton setBackgroundColor:[UIColor clearColor]];

	[self enableButtons:NO];
}

- (void)updatePhotoNumberSwitch
{
	if ([boardTypeControl selectedSegmentIndex] == kBoardTypePhoto)
	{
		[photoNumberSwitch setEnabled:YES];
	}
	else
	{
		[photoNumberSwitch setEnabled:NO];
	}
}

- (IBAction)saveButtonAction
{
	DLog("saveButtonAction");
	
	// Save configuration values
	[boardController.board.config
	 setColumns:([pickerView selectedRowInComponent:kPickerColumnIndex] + kColumnsMin)];
	[boardController.board.config
	 setRows:([pickerView selectedRowInComponent:kPickerRowIndex] + kRowsMin)];
	[boardController saveConfiguration];
}

- (IBAction)cancelButtonAction
{		
	DLog("cancelButtonAction");
	
	[self updateControlsWithAnimation:YES];
	[self enableButtons:NO];
}

- (IBAction)boardTypeControlAction
{
	[self updatePhotoNumberSwitch];
	if ([boardTypeControl selectedSegmentIndex] == kBoardTypePhoto)
	{
		[boardController.board.config setPhotoEnabled:YES];
	}
	else
	{
		[boardController.board.config setPhotoEnabled:NO];
	}
	[boardController.board.config save:NO];
}

- (IBAction)photoNumberSwitchAction
{	
	[boardController.board.config setNumbersEnabled:[photoNumberSwitch isOn]];
	[boardController.board.config save:NO];
}

- (IBAction)soundSwitchAction
{	
	[boardController.board.config setSoundEnabled:[soundSwitch isOn]];
	[boardController.board.config save:NO];
}

- (IBAction)resetButtonAction
{
	[boardController resetGame];
}

- (void)viewDidUnload
{
	DLog("viewDidUnload");
	[self setPickerView:nil];
	[self setBoardTypeControl:nil];
	[self setPhotoNumberSwitch:nil];
	[self setSoundSwitch:nil];
	[self setResetButton:nil];
	[self setSaveButton:nil];
	[self setCancelButton:nil];
	[super viewDidUnload];
}

- (void)dealloc
{
	DLog("dealloc");
	[pickerView release];
	[boardTypeControl release];
	[photoNumberSwitch release];
	[soundSwitch release];
	[resetButton release];
	[saveButton release];
	[cancelButton release];
	[boardController release];
    [super dealloc];
}


#pragma mark UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pView numberOfRowsInComponent:(NSInteger)component
{
	switch(component)
	{
		case(kPickerColumnIndex):
			return (kColumnsMax - kColumnsMin + 1);
			break;
		case(kPickerRowIndex):
			return (kRowsMax - kRowsMin + 1);
			break;
		default:
			return 0;
			break;
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch(component)
	{
		case(kPickerColumnIndex):
			return [NSString stringWithFormat:@"%d %@", (row + kRowsMin), NSLocalizedString(@"ColumnsLabel", @"")];
			break;
		case(kPickerRowIndex):
			return [NSString stringWithFormat:@"%d %@", (row + kRowsMin), NSLocalizedString(@"RowsLabel", @"")];
			break;
		default:
			return [NSString stringWithFormat:@"Error"];
			break;
	}
}

- (void)pickerView:(UIPickerView *)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[self enableButtons:YES];
}

@end
