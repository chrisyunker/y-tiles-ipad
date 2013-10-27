//
//  DialogImageView.m
//  Y-Tiles
//
//  Created by Chris Yunker on 7/14/10.
//  Copyright 2010 chrisyunker.com. All rights reserved.
//

#import "DialogImageView.h"
#import <QuartzCore/QuartzCore.h>


@interface DialogImageView (Private)

- (void)startButtonAction;
- (void)resumeButtonAction;
- (void)cancelButtonAction;
- (void)removeDialog;

@end


@implementation DialogImageView

- (id)initWithFrame:(CGRect)frame
			  board:(Board *)aBoard
{	
	if (self = [super initWithFrame:frame])
	{
		board = [aBoard retain];
		[self setUserInteractionEnabled:YES];
		
		// background view
		dialogBackground = [[UIImageView alloc]
							initWithFrame:[self frame]];
		[dialogBackground setBackgroundColor:[UIColor colorWithRed:kPausedImageColorRed
															 green:kPausedImageColorGreen
															  blue:kPausedImageColorBlue
															 alpha:kPausedImageColorAlpha]];
		[dialogBackground setUserInteractionEnabled:NO];
		[self addSubview:dialogBackground];
		
		
		// dialog view
		dialog = [[UIImageView alloc]
				  initWithFrame:CGRectMake(((frame.size.width - kDialogWidth) / 2),
										   ((frame.size.height - kDialogHeight) / 2),
										   kDialogWidth,
										   kDialogHeight)];
		
		[dialog setBackgroundColor:[UIColor blackColor]];
		[[dialog layer] setBorderColor:[[UIColor whiteColor] CGColor]];
		[[dialog layer] setBorderWidth:kDialogBorderWidth];
		[[dialog layer] setCornerRadius:kDialogCornerRadius];		
		[dialog setUserInteractionEnabled:YES];
		[self addSubview:dialog];
				
		// labels
		message = [[UILabel alloc] initWithFrame:CGRectMake(kDialogMargin,
															kDialogLabelY,
															(kDialogWidth - (2 * kDialogMargin)),
															kDialogLabelHeight)];
		[message setFont:[UIFont fontWithName:kDialogFontType size:kDialogFontSize]];
		[message setBackgroundColor:[UIColor clearColor]];
		[message setTextColor:[UIColor whiteColor]];
		[message setTextAlignment:UITextAlignmentCenter];
		[dialog addSubview:message];
		
		// buttons							  
		UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
		UIImage *buttonBackgroundSelected = [UIImage imageNamed:@"blueButton.png"];
		
		startButton = [[Util createButtonForFrame:CGRectMake(kDialogButtonStartX,
															 kDialogButtonY,
															 kDialogButtonWidth,
															 kDialogButtonHeight)
													   image:buttonBackground
											   imageSelected:buttonBackgroundSelected] retain];
				
		[startButton setTitle:NSLocalizedString(@"StartButton", @"") 
					 forState:UIControlStateNormal];
		[startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[startButton setAccessibilityLabel:NSLocalizedString(@"StartButton", @"")];
		[startButton addTarget:self
						action:@selector(startButtonAction) 
			  forControlEvents:UIControlEventTouchUpInside];
		
		resumeButton = [[Util createButtonForFrame:CGRectMake(kDialogButtonResumeX,
															  kDialogButtonY,
															  kDialogButtonWidth,
															  kDialogButtonHeight)
														image:buttonBackground
												imageSelected:buttonBackgroundSelected] retain];
		
		[resumeButton setTitle:NSLocalizedString(@"ResumeButton", @"")
					  forState:UIControlStateNormal];
		[resumeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[resumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[resumeButton setAccessibilityLabel:NSLocalizedString(@"ResumeButton", @"")];
		[resumeButton addTarget:self 
						 action:@selector(resumeButtonAction) 
			   forControlEvents:UIControlEventTouchUpInside];
		
		cancelButton = [[Util createButtonForFrame:CGRectMake(kDialogButtonCancelX,
															  kDialogButtonY,
															  kDialogButtonWidth,
															  kDialogButtonHeight)
														 image:buttonBackground
												 imageSelected:buttonBackgroundSelected] retain];
		
		[cancelButton setTitle:NSLocalizedString(@"CancelButton", @"") 
					   forState:UIControlStateNormal];
		[cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[cancelButton setAccessibilityLabel:NSLocalizedString(@"CancelButton", @"")];
		[cancelButton addTarget:self 
						  action:@selector(cancelButtonAction) 
				forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
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

- (void)removeDialog
{
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.5f];
	[trans setTimingFunction:[CAMediaTimingFunction 
							  functionWithName:kCAMediaTimingFunctionEaseOut]];
	[[board layer] addAnimation:trans forKey:nil];
	[self removeFromSuperview];
}

- (void)startButtonAction
{
	[board startGame];
	[self removeDialog];
}

- (void)cancelButtonAction
{
	[board resetGame];
	[self removeDialog];
}

- (void)resumeButtonAction
{
	[board resumeGame];
	[self removeDialog];
}

- (void)displayStartDialog
{	
	[resumeButton removeFromSuperview];
	[cancelButton removeFromSuperview];
	[dialog addSubview:startButton];
	[message setText:NSLocalizedString(@"YTiles", "")];
	[board addSubview:self];
}

- (void)displayPauseDialog
{	
	[startButton removeFromSuperview];
	[dialog addSubview:resumeButton];
	[dialog addSubview:cancelButton];
	[message setText:NSLocalizedString(@"ResumeDialog", "")];
	[board addSubview:self];
}

- (void)displaySolvedDialog
{	
	[resumeButton removeFromSuperview];
	[cancelButton removeFromSuperview];
	[startButton removeFromSuperview];
	[dialog addSubview:startButton];
	[message setText:NSLocalizedString(@"CompleteDialog", "")];
	[board addSubview:self];
}

- (void)dealloc
{
	[board release];
	[dialogBackground release];
	[dialog release];
	[startButton release];
	[resumeButton release];
	[cancelButton release];
	[message release];
    [super dealloc];
}

@end
