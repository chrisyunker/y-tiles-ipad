//
//  PhotoDefaultController.m
//  Y-Tiles
//
//  Created by Chris Yunker on 2/26/09.
//  Copyright 2009 chrisyunker.com. All rights reserved.
//

#import "StockPhotoController.h"


@implementation StockPhotoController

@synthesize scrollView;
@synthesize photo1Button;
@synthesize photo2Button;
@synthesize photo3Button;
@synthesize photo4Button;
@synthesize photo5Button;
@synthesize photo6Button;
@synthesize photo7Button;
@synthesize photo8Button;
@synthesize photo9Button;
@synthesize photo10Button;
@synthesize photo11Button;
@synthesize photo12Button;
@synthesize photo13Button;
@synthesize photo14Button;
@synthesize photo15Button;
@synthesize photo16Button;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	  boardController:(BoardController *)aBoardController
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		boardController = [aBoardController retain];
		[self setTitle:NSLocalizedString(@"StockPhotoTitle", @"")];
								
		[self setContentSizeForViewInPopover:CGSizeMake(kStockPhotoPopoverWidth,
														kStockPhotoPopoverHeight)];
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

- (void)viewDidLoad
{
	[super viewDidLoad];
	DLog("viewDidLoad");

	[scrollView setContentSize:CGSizeMake(kStockPhotoScrollWidth,
										  kStockPhotoScrollHeight)];
}

- (void)selectPhotoAction:(id)sender
{	
    int type = [sender tag];
	NSString *path = [NSString stringWithFormat:kPhotoDefaultName, type];
	
	DLog("photo [%@]", path);

	UIImage *photo = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]
															  pathForResource:path
															  ofType:kPhotoType]] autorelease];	
	
	// Remove saved library photo (if exists)
	NSString *boardPhoto = [kDocumentsDir stringByAppendingPathComponent:kBoardPhoto];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:boardPhoto error:NULL];

	[boardController selectPhoto:photo type:type];
}

- (void)viewDidUnload
{
	DLog("viewDidUnload");
	[self setPhoto1Button:nil];
	[self setPhoto2Button:nil];
	[self setPhoto3Button:nil];
	[self setPhoto4Button:nil];
	[self setPhoto5Button:nil];
	[self setPhoto6Button:nil];
	[self setPhoto7Button:nil];
	[self setPhoto8Button:nil];
	[self setPhoto9Button:nil];
	[self setPhoto10Button:nil];
	[self setPhoto11Button:nil];
	[self setPhoto12Button:nil];
	[self setPhoto13Button:nil];
	[self setPhoto14Button:nil];
	[self setPhoto15Button:nil];
	[self setPhoto16Button:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
}

- (void)dealloc
{
	DLog("dealloc");
	[photo1Button release];
	[photo2Button release];
	[photo3Button release];
	[photo4Button release];
	[photo5Button release];
	[photo6Button release];
	[photo7Button release];
	[photo8Button release];
	[photo9Button release];
	[photo10Button release];
	[photo11Button release];
	[photo12Button release];
	[photo13Button release];
	[photo14Button release];
	[photo15Button release];
	[photo16Button release];
	[scrollView release];
	[boardController release];
    [super dealloc];
}

@end
