/*
 *  DataTypes.h
 *  Y-Tiles
 *
 *  Created by Chris Yunker on 2/17/09.
 *  Copyright 2009 Chris Yunker. All rights reserved.
 *
 */


struct Coord
{
	int x;
	int y;
};
typedef struct Coord Coord;


typedef enum
{
	None	   = 0,
	Up	 	   = 1,
	Down	   = 2,
	Left	   = 3,
	Right	   = 4
} Direction;


typedef enum
{
	GameNotStartedNew     = 0,
	GameNotStartedResume  = 1,
	GamePaused            = 2,
	GameInProgress        = 3
} GameState;
