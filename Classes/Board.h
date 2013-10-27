//
//  Board.h
//  Y-Tiles
//
//  Created by Chris Yunker on 12/15/08.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "Tile.h"
#import "Configuration.h"
#import "Constants.h"
#import "DataTypes.h"
#import "BoardController.h"
#import "WaitImageView.h"
#import "DialogImageView.h"
#import "Util.h"
#import "Clock.h"

#define kBoardWidth              768
#define kBoardHeight             960

#define kTileSoundName           @"Tock"
#define kTileSoundType           @"aiff"


@class Tile;
@class BoardController;
@class Configuration;
@class DialogImageView;

@interface Board : UIView
{
	Configuration *config;
	GameState gameState;
	int moves;
	NSMutableArray *tiles;
	Tile ***grid;
	UIImage *photo;
	Coord empty;
	NSLock *tileLock;
	SystemSoundID tockSSID;
	BoardController *boardController;
	WaitImageView *waitView;
	DialogImageView *dialogView;
	NSMutableDictionary *boardState;
	Clock *clock;
}

@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, readonly) Configuration *config;
@property (readonly) NSLock *tileLock;
@property (nonatomic, assign) GameState gameState;
@property (nonatomic, retain) BoardController *boardController;
@property (nonatomic, assign) int moves;
@property (nonatomic, readonly) Clock *clock;

- (void)createNewBoard;

- (void)startGame;
- (void)pauseGame;
- (void)resumeGame;
- (void)resetGame;

- (void)setPhoto:(UIImage *)aPhoto type:(int)aType;
- (void)configChanged:(BOOL)restart;
- (void)saveBoard;

// Called from Tile
- (void)moveTileFromCoordinate:(Coord)coord1 toCoordinate:(Coord)coord2;
- (void)updateAfterMove;

@end
