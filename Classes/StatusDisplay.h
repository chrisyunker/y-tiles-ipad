//
//  StatusDisplay.h
//  Y-Tiles
//
//  Copyright 2010 Chris Yunker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kStatusFontType			@"Helvetica-Bold"
#define kStatusFontSize			20

#define kStatusCornerRadius		10.0f
#define kStatusMargin           5.0f

#define kStatusBgColorRed       0.196f //50.0f/255.0f
#define kStatusBgColorGreen     0.196f //50.0f/255.0f
#define kStatusBgColorBlue      0.196f //50.0f/255.0f
#define kStatusBgColorAlpha     1.0f

@interface StatusDisplay : UIView
{
	UILabel *label;
}

@property (nonatomic, retain) UILabel *label;

- (void)setMessage:(NSString *)message;

@end
