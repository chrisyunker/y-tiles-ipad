//
//  DialogImageView.h
//  Y-Tiles
//
//  Created by Chris Yunker on 7/14/10.
//  Copyright 2010 chrisyunker.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "Util.h"

#define kDialogWidth             500.0f
#define kDialogHeight            150.0f

#define kDialogFontType          @"Helvetica-Bold"
#define kDialogFontSize          24

#define kDialogCornerRadius      10.0f
#define kDialogBorderWidth       3.0f
#define kDialogMargin            20.0f

#define kDialogLabelWidth        460.0f
#define kDialogLabelHeight       32.0f
#define kDialogLabelY            26.0f

#define kDialogButtonWidth       226.0f
#define kDialogButtonHeight      46.0f
#define kDialogButtonY           84.0f
#define kDialogButtonStartX      137.0f
#define kDialogButtonCancelX     254.0f
#define kDialogButtonResumeX     20.0f

#define kPausedImageColorRed     0.51f //130.0f/255.0f
#define kPausedImageColorGreen   0.51f //130.0f/255.0f
#define kPausedImageColorBlue    0.51f //130.0f/255.0f
#define kPausedImageColorAlpha   0.5f


@interface DialogImageView : UIImageView
{
	Board *board;
	UIImageView *dialogBackground;
	UIImageView *dialog;
	UIButton *startButton;
	UIButton *resumeButton;
	UIButton *cancelButton;
	UILabel *message;
}

- (id)initWithFrame:(CGRect)frame board:(Board *)aBoard;
- (void)displayStartDialog;
- (void)displayPauseDialog;
- (void)displaySolvedDialog;

@end
