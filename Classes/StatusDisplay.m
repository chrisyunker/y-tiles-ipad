//
//  StatusDisplay.m
//  Y-Tiles
//
//  Copyright 2010 Chris Yunker. All rights reserved.
//

#import "StatusDisplay.h"
#import <QuartzCore/QuartzCore.h>


@implementation StatusDisplay

@synthesize label;

- (void)awakeFromNib
{	
	[self setBackgroundColor:[UIColor colorWithRed:kStatusBgColorRed
											 green:kStatusBgColorGreen
											  blue:kStatusBgColorBlue
											 alpha:kStatusBgColorAlpha]];
	[[self layer] setCornerRadius:kStatusCornerRadius];		
	
	CGRect labelFrame = [self bounds];
	labelFrame.size.width = labelFrame.size.width - (2 * kStatusMargin);
	labelFrame.origin.x = kStatusMargin;
	
	label = [[UILabel alloc] initWithFrame:labelFrame];
	[label setAdjustsFontSizeToFitWidth:YES];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont fontWithName:kStatusFontType size:kStatusFontSize]];
	[self addSubview:label]; 
}

- (void)dealloc
{
	[label release];
    [super dealloc];
}

- (void)setMessage:(NSString *)message
{
	[label setText:message];
}

@end
