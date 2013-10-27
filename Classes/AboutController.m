//
//  AboutController.m
//  Y-Tiles
//
//  Created by Chris Yunker on 2/18/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import "AboutController.h"

@implementation AboutController

@synthesize versionLabel;
@synthesize icon;


- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	  boardController:(BoardController *)aBoardController
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		boardController = [aBoardController retain];
		[self setTitle:NSLocalizedString(@"AboutTitle", @"")];
		[self setContentSizeForViewInPopover:CGSizeMake(kAboutPopoverWidth,
														kAboutPopoverHeight)];
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
	UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																	  style:UIBarButtonItemStyleDone
																	 target:self 
																	 action:@selector(dismiss)];
	[self.navigationItem setRightBarButtonItem:dismissButton];
	[dismissButton release];
			
	NSString *version = [NSString stringWithFormat:@"%@ %d.%d",
						 NSLocalizedString(@"VersionLabel", @""),
						 kVersionMajor,
						 kVersionMinor];
	[versionLabel setText:version];
	
	UIImage *iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]
																  pathForResource:kAboutImageName
																  ofType:kAboutImageType]];
	[icon setImage:iconImage];
	[iconImage release];
}

- (void)dismiss
{
	[boardController dismissAboutController];
}

- (void)viewDidUnLoad
{
	DLog("viewDidUnload");
	[self setVersionLabel:nil];
	[self setIcon:nil];
	[super viewDidUnload];
}

- (void)dealloc
{
	DLog("dealloc");
	[versionLabel release];
	[icon release];
	[boardController release];
    [super dealloc];
}

@end
