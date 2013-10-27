//
//  BoardController.m
//  Y-Tiles
//
//  Created by Chris Yunker on 1/7/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BoardController.h"
#import "StockPhotoController.h"
#import "OptionsController.h"
#import "AboutController.h"


@interface BoardController (Private)

- (void)dismissAllPopoversExcept:(UIPopoverController *)popoverController;
- (void)updateMovesDisplay:(int)moves;
- (void)updateTimeDisplay:(int)seconds;

@end


@implementation BoardController

@synthesize board;
@synthesize boardPhoto;
@synthesize display;
@synthesize toolbar;
@synthesize displayModeControl;
@synthesize optionsButton;
@synthesize libraryPhotoButton;
@synthesize stockPhotoButton;
@synthesize aboutButton;
@synthesize aboutBarButton;
@synthesize movesDisplay;
@synthesize timeDisplay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		board = [[Board alloc] init];
		boardPhoto = [[UIImageView alloc] initWithImage:board.photo];
		
		[board createNewBoard];
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	ALog("didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
	//[optionsPopover release], optionsPopover = nil;
	//[stockPhotoPopover release], stockPhotoPopover = nil;
	//[libraryPhotoPopover release], libraryPhotoPopover = nil;
	//[aboutNavController release], aboutNavController = nil;
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

- (void)viewDidLoad 
{
	[super viewDidLoad];
	DLog("viewDidLoad");
		
	[timeDisplay.label setTextAlignment:UITextAlignmentCenter];
	[movesDisplay.label setTextAlignment:UITextAlignmentRight];
	
	[board addObserver:self forKeyPath:@"moves"
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) 
			   context:nil];
	
	[board.clock addObserver:self forKeyPath:@"seconds"
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) 
			   context:nil];
	
	[display addSubview:board];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"moves"])
	{
		int moves = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
		[self updateMovesDisplay:moves];
	}
	else if ([keyPath isEqualToString:@"seconds"])
	{
		int seconds = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
		[self updateTimeDisplay:seconds];
	}
}

- (void)updateMovesDisplay:(int)moves
{
	[movesDisplay setMessage:[NSString stringWithFormat:@"%d", moves]];
}

- (void)updateTimeDisplay:(int)seconds
{
	int hours = (seconds / 3600);
	seconds %= 3600;
	int minutes = (seconds / 60);
	seconds %= 60;
			
	if (hours > 0)
	{
		// Only add hour section when time >= 1 hour
		[timeDisplay setMessage:[NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds]];		
	}
	else
	{
		[timeDisplay setMessage:[NSString stringWithFormat:@"%02d:%02d", minutes, seconds]];
	}
}

- (void)dismissAllPopoversExcept:(UIPopoverController *)popoverController
{
	if ([libraryPhotoPopover isPopoverVisible])
	{
		if (libraryPhotoPopover != popoverController)
		{
			[libraryPhotoPopover dismissPopoverAnimated:YES];
		}
	}
	if ([stockPhotoPopover isPopoverVisible])
	{
		if (stockPhotoPopover != popoverController)
		{
			[stockPhotoPopover dismissPopoverAnimated:YES];
		}
	}
	if ([optionsPopover isPopoverVisible])
	{
		if (optionsPopover != popoverController)
		{
			[optionsPopover dismissPopoverAnimated:YES];
		}
	}
}

- (IBAction)stockPhotoButtonAction
{	
	if (stockPhotoPopover == nil)
	{
		DLog("initialize stockPhotoButtonAction...");
		
		StockPhotoController *spc = [[StockPhotoController alloc] initWithNibName:@"StockPhotoController"
																		   bundle:nil
																  boardController:self];
		UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:spc];
		stockPhotoPopover = [[UIPopoverController alloc] initWithContentViewController:nc];
		[stockPhotoPopover setDelegate:self];
		
		[nc release];
		[spc release];
	}
	
	[self dismissAllPopoversExcept:stockPhotoPopover];
	
	if ([stockPhotoPopover isPopoverVisible])
	{
		[stockPhotoPopover dismissPopoverAnimated:YES];
	}
	else 
	{
		[stockPhotoPopover presentPopoverFromBarButtonItem:stockPhotoButton
									 permittedArrowDirections:UIPopoverArrowDirectionUp
													 animated:YES];
	}
}

- (IBAction)libraryPhotoButtonAction
{	
	// Check to make sure pictures are available
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		ALog("Error: UIImagePickerControllerSourceTypePhotoLibrary not available");
		return;
	}
	
	if (libraryPhotoPopover == nil)
	{
		DLog("initialize libraryPhotoPopover...");
		
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		[picker shouldAutorotateToInterfaceOrientation:NO];
		[picker setAllowsEditing:NO];
		[picker setDelegate:self];
		[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		
		libraryPhotoPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
		[libraryPhotoPopover setDelegate:self];
		
		[picker release];
	}
	
	[self dismissAllPopoversExcept:libraryPhotoPopover];

	if ([libraryPhotoPopover isPopoverVisible])
	{
		[libraryPhotoPopover dismissPopoverAnimated:YES];
	}
	else 
	{
		[libraryPhotoPopover presentPopoverFromBarButtonItem:libraryPhotoButton
									permittedArrowDirections:UIPopoverArrowDirectionUp
													animated:YES];
	}
}

- (IBAction)optionsButtonAction
{
	if (optionsPopover == nil)
	{
		DLog("initialize optionsPopover...");
		
		OptionsController *oc = [[OptionsController alloc] initWithNibName:@"OptionsController"
																	  bundle:nil
																	   boardController:self];
		
		UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:oc];
		optionsPopover = [[UIPopoverController alloc] initWithContentViewController:nc];
		[optionsPopover setDelegate:self];
		
		[nc release];
		[oc release];
	}
	
	[self dismissAllPopoversExcept:optionsPopover];

	if ([optionsPopover isPopoverVisible])
	{
		[optionsPopover dismissPopoverAnimated:YES];
	}
	else 
	{
		[optionsPopover presentPopoverFromBarButtonItem:optionsButton
									 permittedArrowDirections:UIPopoverArrowDirectionUp
													 animated:YES];
	}
}

- (IBAction)displayModeControlAction
{
	if (self.displayModeControl.selectedSegmentIndex == kDisplayModeBoardIndex)
	{
		[board resumeGame];
		
		[boardPhoto removeFromSuperview];
		[display addSubview:board];
	}
	else
	{		
		[board pauseGame];
		
		[board removeFromSuperview];
		[display addSubview:boardPhoto];
	}
}

- (IBAction)aboutButtonAction
{
	[self dismissAllPopoversExcept:nil];
	
	if (aboutNavController == nil)
	{
		AboutController *ac = [[AboutController alloc] initWithNibName:@"AboutController" 
															bundle:nil 
												   boardController:self];
		aboutNavController = [[UINavigationController alloc] initWithRootViewController:ac];
		[ac release];
		
		[aboutNavController setModalPresentationStyle:UIModalPresentationFormSheet];
		[aboutNavController.navigationBar setBarStyle:UIBarStyleBlack];
	}
	
	[self presentModalViewController:aboutNavController animated:YES];
}


- (void)selectPhoto:(UIImage *)photo type:(int)type
{
	[self dismissAllPopoversExcept:nil];	
	[displayModeControl setSelectedSegmentIndex:kDisplayModeBoardIndex];
	[self displayModeControlAction];
	
	[boardPhoto setImage:photo];
	[board setPhoto:photo type:type];
}

- (void)saveConfiguration
{
	[optionsPopover dismissPopoverAnimated:YES];
	[displayModeControl setSelectedSegmentIndex:kDisplayModeBoardIndex];
	[self displayModeControlAction];
	
	[board.config save:NO];
}

- (void)resetGame
{
	[self dismissAllPopoversExcept:nil];
	[displayModeControl setSelectedSegmentIndex:kDisplayModeBoardIndex];
	[self displayModeControlAction];
	
	[board resetGame];
}

- (void)saveGame
{
	[board saveBoard];
}

- (void)dismissAboutController
{
	[aboutNavController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
	DLog("viewDidUnload");	
	[self setDisplay:nil];
	[self setToolbar:nil];
	[self setDisplayModeControl:nil];
	[self setOptionsButton:nil];
	[self setLibraryPhotoButton:nil];
	[self setStockPhotoButton:nil];
	[self setAboutBarButton:nil];
	[self setAboutButton:nil];
	[self setMovesDisplay:nil];
	[self setTimeDisplay:nil];
	[super viewDidUnload];
}

- (void)dealloc
{
	DLog("dealloc");
	[board release];
	[boardPhoto release];
	[display release];
	[toolbar release];
	[displayModeControl release];
	[optionsButton release];
	[libraryPhotoButton release];
	[stockPhotoButton release];
	[aboutBarButton release];
	[aboutButton release];
	[movesDisplay release];
	[timeDisplay release];
	[libraryPhotoPopover release];
	[stockPhotoPopover release];
	[optionsPopover release];
	[aboutNavController release];
    [super dealloc];
}


#pragma mark UIPopoverControllerDelegate methods

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	return YES;
}


#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	
	UIImage *origImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
	if (origImage == nil)
	{
		ALog("Invalid selected photo");
		[self selectPhoto:nil type:kBoardPhotoInvalid];
		[self dismissModalViewControllerAnimated:YES];
		return;
	}
	
	CGSize origSize = origImage.size;
	CGSize destSize = board.frame.size;
	float origRatio = (origSize.height / origSize.width);
	float destRatio = (destSize.height / destSize.width);
	
	CGRect cropRect;
	if (origRatio > destRatio)
	{
		// crop height
		float newHeight = ((origSize.width * destSize.height) / destSize.width);
		float newY = ((origSize.height - newHeight) / 2);
		//DLog("newY %f", newY);

		cropRect = CGRectMake(0.0f, newY, origSize.width, newHeight);
		
	}
	else
	{
		// crop width
		float newWidth = ((origSize.height * destSize.width) / destSize.height);
		float newX = ((origSize.width - newWidth) / 2);
		//DLog("newX %f", newX);
		
		cropRect = CGRectMake(newX, 0.0f, newWidth, origSize.height);
	}
	
	CGImageRef origImageRef = [origImage CGImage];	
	CGImageRef cropImageRef = CGImageCreateWithImageInRect(origImageRef, cropRect);
	UIImage *cropImage = [UIImage imageWithCGImage:cropImageRef];
	CGImageRelease(cropImageRef);

	UIGraphicsBeginImageContext(destSize);
	[cropImage drawInRect:CGRectMake(0.0f, 0.0f, destSize.width, destSize.height)];
	UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSString *path = [kDocumentsDir stringByAppendingPathComponent:kBoardPhoto];
	if (![UIImageJPEGRepresentation(destImage, 1) writeToFile:path atomically:YES])
	{
		ALog("PhotoController: Failed to write file [%@]", path);
	}
	
	[self selectPhoto:destImage type:kBoardPhotoType];
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	DLog("imagePickerControllerDidCancel");
	
	[picker dismissModalViewControllerAnimated:YES];
}

@end
