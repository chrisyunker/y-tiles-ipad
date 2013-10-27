//
//  Configuration.h
//  Y-Tiles
//
//  Created by Chris Yunker on 2/16/09.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Board.h"

// User Default Keys
#define kKeySavedDefaults        @"savedDefaults"
#define kKeyColumns              @"columns"
#define kKeyRows                 @"rows"
#define kKeylastPhotoType        @"lastPhotoType"
#define kKeyPhotoEnabled         @"photoEnabled"
#define kKeyNumbersEnabled       @"numbersEnabled"
#define kKeySoundEnabled         @"soundEnabled"
#define kKeyBoardSaved           @"boardSaved"
#define kKeyBoardState           @"boardState"
#define kKeyNumberMoves          @"numberMoves"
#define kKeyTimeSeconds          @"timeSeconds"

// Default Values
#define kColumnsDefault          5
#define kRowsDefault             5
#define klastPhotoTypeDefault    1
#define kPhotoEnabledDefault     YES
#define kNumbersEnabledDefault   YES
#define kSoundEnabledDefault     YES


@class Board;

@interface Configuration : NSObject
{
	int columns;
	int rows;
	int photoType;
	BOOL photoEnabled;
	BOOL numbersEnabled;
	BOOL soundEnabled;
	Board *board;
}

@property (nonatomic, assign) int columns;
@property (nonatomic, assign) int rows;
@property (nonatomic, assign) int photoType;
@property (nonatomic, assign) BOOL photoEnabled;
@property (nonatomic, assign) BOOL numbersEnabled;
@property (nonatomic, assign) BOOL soundEnabled;

- (id)initWithBoard:(Board *)aBoard;
- (void)load;
- (void)save;
- (void)save:(BOOL)restart;

@end
