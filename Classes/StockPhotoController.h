//
//  StockPhotoController.h
//  Y-Tiles
//
//  Created by Chris Yunker on 2/26/09.
//  Copyright 2009 chrisyunker.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardController.h"
#import "Constants.h"

#define kStockPhotoPopoverWidth  396
#define kStockPhotoPopoverHeight 750

#define kStockPhotoMargin        8
#define kStockPhotoSmallWidth    174
#define kStockPhotoSmallHeight   216
#define kStockPhotoScrollWidth   396
#define kStockPhotoScrollHeight  1824


@class BoardController;

@interface StockPhotoController : UIViewController
{
	BoardController *boardController;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton *photo1Button;
	IBOutlet UIButton *photo2Button;
	IBOutlet UIButton *photo3Button;
	IBOutlet UIButton *photo4Button;
	IBOutlet UIButton *photo5Button;
	IBOutlet UIButton *photo6Button;
	IBOutlet UIButton *photo7Button;
	IBOutlet UIButton *photo8Button;
	IBOutlet UIButton *photo9Button;
	IBOutlet UIButton *photo10Button;
	IBOutlet UIButton *photo11Button;
	IBOutlet UIButton *photo12Button;
	IBOutlet UIButton *photo13Button;
	IBOutlet UIButton *photo14Button;
	IBOutlet UIButton *photo15Button;
	IBOutlet UIButton *photo16Button;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *photo1Button;
@property (nonatomic, retain) IBOutlet UIButton *photo2Button;
@property (nonatomic, retain) IBOutlet UIButton *photo3Button;
@property (nonatomic, retain) IBOutlet UIButton *photo4Button;
@property (nonatomic, retain) IBOutlet UIButton *photo5Button;
@property (nonatomic, retain) IBOutlet UIButton *photo6Button;
@property (nonatomic, retain) IBOutlet UIButton *photo7Button;
@property (nonatomic, retain) IBOutlet UIButton *photo8Button;
@property (nonatomic, retain) IBOutlet UIButton *photo9Button;
@property (nonatomic, retain) IBOutlet UIButton *photo10Button;
@property (nonatomic, retain) IBOutlet UIButton *photo11Button;
@property (nonatomic, retain) IBOutlet UIButton *photo12Button;
@property (nonatomic, retain) IBOutlet UIButton *photo13Button;
@property (nonatomic, retain) IBOutlet UIButton *photo14Button;
@property (nonatomic, retain) IBOutlet UIButton *photo15Button;
@property (nonatomic, retain) IBOutlet UIButton *photo16Button;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	  boardController:(BoardController *)aBoardController;

- (void)selectPhotoAction:(id)sender;

@end
