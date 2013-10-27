//
//  WaitImageView.h
//  Y-Tiles
//
//  Created by Chris Yunker on 3/1/09.
//  Copyright 2009 chrisyunker.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"

#define kWaitViewDialogWidth     300.0f
#define kWaitViewDialogHeight    150.0f

#define kWaitViewFontType        @"Helvetica-Bold"
#define kWaitViewFontSize        24

#define kWaitViewCornerRadius    10.0f
#define kWaitViewBorderWidth     3.0f
#define kUISpace                 8.0f

#define kWaitLabelWidth		     177.0f
#define kWaitLabelHeight         32.0f
#define kProgressViewWidth       200.0f
#define kProgressViewHeight      9.0f

@interface WaitImageView : UIImageView
{
	UIProgressView *progressView;
}

- (void)updateProgress:(float)value;

@end
