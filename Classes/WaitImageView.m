//
//  WaitImageView.m
//  Y-Tiles
//
//  Created by Chris Yunker on 3/1/09.
//  Copyright 2009 chrisyunker.com. All rights reserved.
//

#import "WaitImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation WaitImageView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setBackgroundColor:[UIColor blackColor]];
								  
		// dialog view
		UIImageView *dialog = [[UIImageView alloc]
							   initWithFrame:CGRectMake(((frame.size.width - kWaitViewDialogWidth) / 2),
														((frame.size.height - kWaitViewDialogHeight) / 2),
														kWaitViewDialogWidth,
														kWaitViewDialogHeight)];
		
		[dialog setBackgroundColor:[UIColor blackColor]];
		[dialog.layer setBorderColor:[[UIColor whiteColor] CGColor]];
		[dialog.layer setBorderWidth:kWaitViewBorderWidth];
		[dialog.layer setCornerRadius:kWaitViewCornerRadius];
		
				
		float innerHeight = (kWaitLabelHeight + kUISpace + kProgressViewHeight);
		float innerY = ((kWaitViewDialogHeight - innerHeight) / 2);
		
		UILabel *label = [[UILabel alloc]
				 initWithFrame:CGRectMake(((kWaitViewDialogWidth - kWaitLabelWidth) / 2),
										  innerY,
										  kWaitLabelWidth,
										  kWaitLabelHeight)];
		[label setBackgroundColor:[UIColor blackColor]];
		[label setFont:[UIFont fontWithName:kWaitViewFontType size:kWaitViewFontSize]];
		[label setTextColor:[UIColor whiteColor]];
		[label setText:NSLocalizedString(@"WaitImageLabel", @"")];
		[dialog addSubview:label];
		[label release];
				
		progressView = [[UIProgressView alloc]
						initWithFrame:CGRectMake(((kWaitViewDialogWidth - kProgressViewWidth) / 2),
												 (innerY + kUISpace + kWaitLabelHeight),
												 kProgressViewWidth,
												 kProgressViewHeight)];
		[progressView setProgressViewStyle:UIProgressViewStyleDefault];
		[dialog addSubview:progressView];
		
		[self addSubview:dialog];
		[dialog release];
	}
	return self;
}

- (void)dealloc
{
	DLog("dealloc");
	[progressView release];
    [super dealloc];
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

- (void)updateProgress:(float)value
{
	[progressView setProgress:value];
}

@end
