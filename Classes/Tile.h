//
//  Tile.h
//  Y-Tiles
//
//  Created by Chris Yunker on 1/11/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Board.h"
#import "DataTypes.h"
#import "Util.h"

// Number Mode
#define kNumberBgColorRed        0.216f //55.0f/255.0f
#define kNumberBgColorGreen      0.714f //182.0f/255.0f
#define kNumberBgColorBlue       0.0f   //0.0f/255.0f
#define kNumberBgColorAlpha      1.0f
#define kNumberFontType          "Helvetica Neue"
#define kNumberFontSize          20

// Photo Mode
#define kPhotoBgBorder           5.0f
#define kPhotoBgOffset           10.0f
#define kPhotoBgCornerRadius     5.0f
#define kPhotoFontType           "Helvetica Neue"
#define kPhotoFontSize           20

#define kTileSpacingWidth        1.0f
#define kTileCornerRadius        10.0f


@class Board;

@interface Tile : UIImageView
{
	int tileId;
	CGPoint startOrigin;
	CGPoint startPoint;
	Coord coord;
	Coord homeCoord;
	CGImageRef photoImage;
	CGImageRef numberedPhotoImage;
	CGImageRef numberImage;
	Direction moveType;
	Tile *pushTile;
	BOOL solved;
	BOOL haveLock;
	Board *board;
}

@property (nonatomic, readonly) int tileId;
@property (nonatomic, readonly) BOOL solved;
@property (nonatomic, readwrite) Direction moveType;
@property (nonatomic, assign) Tile *pushTile;

- (id)initWithId:(int)aId board:(Board *)aBoard coord:(Coord)aCoord photo:(CGImageRef)aPhoto;
- (void)drawTile;
- (void)moveToCoord:(Coord)coord;
- (void)moveToCoordX:(int)x coordY:(int)y;
- (void)moveInDirection:(Direction)type;
- (void)slideInDirection:(Direction)direction distance:(CGFloat)distance;

@end
