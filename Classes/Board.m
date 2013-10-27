//
//  Board.m
//  Y-Tiles
//
//  Created by Chris Yunker on 12/15/08.
//  Copyright 2009 Chris Yunker. All rights reserved.
//

#import "Board.h"

@interface Board (Private)

- (void)makeClickSound;
- (void)createTiles;
- (void)scrambleBoard;
- (void)scrambleBoardComplete;
- (void)resetBoard;
- (void)showWaitView;
- (void)removeWaitView;
- (void)createTilesInThread;
- (void)drawBoard;
- (void)updateBoard;
- (void)restoreBoard;

@end


@implementation Board

@synthesize photo;
@synthesize config;
@synthesize tileLock;
@synthesize gameState;
@synthesize boardController;
@synthesize moves;
@synthesize clock;


- (id)init
{
	if (self = [super initWithFrame:CGRectMake(0, 0, kBoardWidth, kBoardHeight)])
	{
		config = [[Configuration alloc] initWithBoard:self];
		[config load];
		
		clock = [[Clock alloc] init];
		
		[self setBackgroundColor:[UIColor blackColor]];
		[self setMultipleTouchEnabled:NO];
		
		gameState = GameNotStartedNew;
		[self setMoves:0];

		// create grid to handle largest possible configuration
		
		grid = malloc(kColumnsMax * sizeof(Tile **));
		if (grid == NULL)
		{
			ALog("Board:init Memory allocation error");
			return nil;
		}
		for (int x = 0; x < kColumnsMax; x++)
		{
			grid[x] = malloc(kRowsMax * sizeof(Tile *));
			if (grid[x] == NULL)
			{
				ALog("Board:init Memory allocation error");
				return nil;
			}
		}
		
		
		// load photo from settings (or use default)
		
		if (config.photoType > 0)
		{
			// stock photo selection
			
			NSString *photoFile = [NSString stringWithFormat:kPhotoDefaultName, config.photoType];
			DLog("photoFile [%@]", photoFile);
			
			[self setPhoto:[[[UIImage alloc]
							 initWithContentsOfFile:[[NSBundle mainBundle]
													 pathForResource:photoFile 
													 ofType:kPhotoType]] autorelease]];
		}
		else if (config.photoType == 0)
		{
			// library photo selection
			
			[self setPhoto:[UIImage imageWithContentsOfFile:[kDocumentsDir
															 stringByAppendingPathComponent:kBoardPhoto]]];
			if ([self photo] == nil)
			{
				ALog("Board:init Failed to load last board image [%@]",
					 [kDocumentsDir stringByAppendingPathComponent:kBoardPhoto]);
				
				NSString *photoFile = [NSString stringWithFormat:kPhotoDefaultName, 1];

				[self setPhoto:[[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]
																		 pathForResource:photoFile
																		 ofType:kPhotoType]] autorelease]];
			}
		}
		else
		{
			// if all else fails, use first stock photo
			
			NSString *photoFile = [NSString stringWithFormat:kPhotoDefaultName, 1];
			
			[self setPhoto:[[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]
																	 pathForResource:photoFile
																	 ofType:kPhotoType]] autorelease]];
		}

		
		[self restoreBoard];
		
		tileLock = [[NSLock alloc] init];
		waitView = [[WaitImageView alloc] initWithFrame:[self frame]];		
		dialogView = [[DialogImageView alloc] initWithFrame:[self frame] board:self];

		// tile move tick sound
		NSBundle *uiKitBundle = [NSBundle bundleWithIdentifier:@"com.apple.UIKit"];
		NSURL *url = [NSURL fileURLWithPath:[uiKitBundle pathForResource:kTileSoundName ofType:kTileSoundType]];
		OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef) url, &tockSSID);
		if (error) ALog("Board:init Failed to create sound for URL [%@]", url);
	}
    return self;
}

- (void)startGame
{
	[self setMoves:0];
	[clock reset];
	[self scrambleBoard];	
	[self setGameState:GameInProgress];
}

- (void)pauseGame
{
	if (self.gameState == GameInProgress)
	{
		[self setGameState:GamePaused];
	}
}

- (void)resumeGame
{
	if (self.gameState == GamePaused)
	{
		[self setGameState:GameInProgress];
	}
}

- (void)resetGame
{
	[self setGameState:GameNotStartedNew];
	[self setMoves:0];
	[clock reset];
	[self resetBoard];
}

- (void)setPhoto:(UIImage *)aPhoto type:(int)aType
{
	[self setPhoto:aPhoto];
	DLog("setPhoto [%@] [%d]", aPhoto, aType);
		
	[config setPhotoType:aType];
	[config setPhotoEnabled:YES];
	[config save:YES];	
}

- (void)configChanged:(BOOL)restart
{
	DLog("configChanged [%d]\n\n", restart);
	
	if (restart)
	{
		self.gameState = GameNotStartedNew;
		[self setMoves:0];
		[clock reset];
		
		[self createNewBoard];
	}
	else
	{
		[self drawBoard];
	}
}

- (void)setGameState:(GameState)state
{
	if (gameState == state)
	{
		return;
	}
	
	DLog("Old State [%d] -> New State [%d]", gameState, state);
	gameState = state;
	
	switch (gameState)
	{
		case GameNotStartedNew:
			[clock stop];
			
		case GameNotStartedResume:
			[clock stop];
			
			break;
		case GamePaused:
			[clock stop];
			
			break;
		case GameInProgress:
			[clock start];
			
			break;
		default:
			break;
	}
}

- (void)makeClickSound
{
	if (config.soundEnabled)
	{
		AudioServicesPlaySystemSound(tockSSID);
	}
}


// Methods to create tiles in separate thread

- (void)createNewBoard
{
	[self showWaitView];
	
	[NSThread detachNewThreadSelector:@selector(createTilesInThread)
							 toTarget:self
						   withObject:nil];
}

- (void)createTilesInThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
	[self createTiles];
	
	[self performSelectorOnMainThread:@selector(removeWaitView)
						   withObject:self
						waitUntilDone:YES];
	
	[pool release];
	pool = nil;
}

- (void)showWaitView
{
	DLog("showWaitView");
	
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	[waitView updateProgress:0.0f];
	[self addSubview:waitView];
	
	//TODO Debug
	//[NSThread sleepForTimeInterval:3000];
	
	[boardController.displayModeControl setSelectedSegmentIndex:kDisplayModeBoardIndex];
	[boardController displayModeControlAction];
}

- (void)removeWaitView
{
	[self drawBoard];

	if (self.gameState == GameNotStartedResume)
	{
		[self updateBoard];
		[self setGameState:GamePaused];
		[waitView removeFromSuperview];
		[dialogView displayPauseDialog];
	}
	else
	{
		[self setMoves:0];
		[clock reset];
		[waitView removeFromSuperview];
		[dialogView displayStartDialog];
	}
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

// Method to bridge progress updates from detached thread
- (void)updateProgress:(NSNumber *)progressValue
{	
	[waitView updateProgress:[progressValue floatValue]];
}


// Save/Restore Board state

- (void)saveBoard
{
	DLog("saveBoard");
	
	if ((gameState == GamePaused) ||
		(gameState == GameInProgress))
	{
		DLog("Saving board...");
		
		[clock stop];

		NSMutableArray *stateArray = [[NSMutableArray alloc] initWithCapacity:(config.columns * config.rows)];
	
		for (int y = 0; y < config.rows; y++)
		{
			for (int x = 0; x < config.columns; x++)
			{
				Tile *tile = grid[x][y];
								
				if (tile == nil)
				{
					[stateArray addObject:[NSNumber numberWithInt:0]];
				}
				else
				{
					[stateArray addObject:[NSNumber numberWithInt:[tile tileId]]];
				}
			}
		}
				
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:stateArray forKey:kKeyBoardState];
		[defaults setObject:[NSNumber numberWithInt:moves] forKey:kKeyNumberMoves];
		[defaults setObject:[NSNumber numberWithInt:clock.seconds] forKey:kKeyTimeSeconds];
		[defaults setBool:YES forKey:kKeyBoardSaved];
		[defaults synchronize];
	
		[stateArray release];
	}
}

- (void)restoreBoard
{
	DLog("restoreBoard");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([defaults boolForKey:kKeyBoardSaved])
	{
		DLog("Restoring board...");
		
		//TODO: Defensive code?
		
		[self setMoves:[(NSNumber *) [defaults objectForKey:kKeyNumberMoves] intValue]];
		[clock resetToSeconds:[(NSNumber *) [defaults objectForKey:kKeyTimeSeconds] intValue]];
		NSArray *stateArray = (NSArray *) [defaults objectForKey:kKeyBoardState];
		
		[defaults setBool:NO forKey:kKeyBoardSaved];
		[defaults removeObjectForKey:kKeyBoardState];
		[defaults synchronize];
		
		int tileCount = (config.columns * config.rows);
		
		// Check Size
		if ([stateArray count] != tileCount)
		{
			ALog("Saved Board has been corrupted. Number of saves values [%d] different than expected [%d]",
				 [stateArray count], tileCount); 
			return;
		}
		
		boardState = [[NSMutableDictionary alloc] initWithCapacity:tileCount];
				
		for (int i = 0; i < stateArray.count; i++)
		{
			int x = (i % config.columns);
			int y = (i / config.columns);

			NSNumber *tileId = (NSNumber *) [stateArray objectAtIndex:i];
			NSArray *coord = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:x], [NSNumber numberWithInt:y], nil];
			
			[boardState setObject:coord forKey:tileId];
			[coord release];
		}
		
		gameState = GameNotStartedResume;
	}
}


// Board manipulation methods

- (void)drawBoard
{
	for (Tile *tile in tiles)
	{
		[tile drawTile];
	}
}

- (void)updateAfterMove
{
	[self makeClickSound];
	
	// Increment move count
	[self setMoves:(moves + 1)];	
	[self updateBoard];
}

- (void)updateBoard
{
	//DLog("updateBoard");
	
	bool solved = YES;
	for (Tile *tile in tiles)
	{
		// Check if board is solved
		if (![tile solved]) solved = NO;
		
		// Reset move state
		[tile setMoveType:None];
		[tile setPushTile:nil];
	}
	
	if (solved)
	{
		[self setGameState:GameNotStartedNew];
		[dialogView displaySolvedDialog];
		
		return;
	}
		
	// Go left
	for (int i = 0; (empty.x - 1 - i) >= 0; i++)
	{
		grid[empty.x - 1 - i][empty.y].moveType = Right;
		if (i > 0)
		{
			grid[empty.x - 1 - i][empty.y].pushTile = grid[empty.x - i][empty.y];
		}
	}
	
	// Go right
	for (int i = 0; (empty.x + 1 + i) < config.columns; i++)
	{
		grid[empty.x + 1 + i][empty.y].moveType = Left;
		if (i > 0)
		{
			grid[empty.x + 1 + i][empty.y].pushTile = grid[empty.x + i][empty.y];
		}
	}
	
	// Go up
	for (int i = 0; (empty.y - 1 - i) >= 0; i++)
	{
		grid[empty.x][empty.y - 1 - i].moveType = Down;
		if (i > 0)
		{
			grid[empty.x][empty.y - 1 - i].pushTile = grid[empty.x][empty.y - i];
		}
	}
	
	// Go down
	for (int i = 0; (empty.y + 1 + i) < config.rows; i++)
	{
		grid[empty.x][empty.y + 1 + i].moveType = Up;
		if (i > 0)
		{
			grid[empty.x][empty.y + 1 + i].pushTile = grid[empty.x][empty.y + i];
		}
	}
}

- (void)moveTileFromCoordinate:(Coord)coord1 toCoordinate:(Coord)coord2
{
	grid[coord2.x][coord2.y] = grid[coord1.x][coord1.y];
	grid[coord1.x][coord1.y] = NULL;
	
	empty = coord1;
}


// Board creation methods

- (void)scrambleBoard
{
	DLog("scrambleBoard");
	
	[self setUserInteractionEnabled:NO];
	
	DLog("config col:rows %d:%d", config.columns, config.rows);
	
	// Clear grid
	for (int x = 0; x < config.columns; x++)
	{
		for (int y = 0; y < config.rows; y++)
		{
			grid[x][y] = NULL;
		}
	}
	
	NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:tiles.count];
	for (int i = 0; i < (config.rows * config.columns); i++)
	{
		[numberArray insertObject:[NSNumber numberWithInt:i] atIndex:i];
	}
	
	// Scramble Animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kTileScrambleTime];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(scrambleBoardComplete)];
	
	for (int y = 0; y < config.rows; y++)
	{
		for (int x = 0; x < config.columns; x++)
		{
			if (numberArray.count > 0)
			{
				int randomNum = arc4random() % numberArray.count;
				
#ifdef DEBUG
				if (numberArray.count > 2)
					randomNum = 0;
				else if (numberArray.count == 2)
					randomNum = 1;
				else
					randomNum = 0;
#endif
				
				int index = [[numberArray objectAtIndex:randomNum] intValue];
				[numberArray removeObjectAtIndex:randomNum];
				if (index < tiles.count)
				{
					Tile *tile = [tiles objectAtIndex:index];
					grid[x][y] = tile;
					
					[tile moveToCoordX:x coordY:y];
				}
				else
				{
					// Empty slot
					empty.x = x;
					empty.y = y;
					
					DLog("Empty slot [%d][%d]", empty.x, empty.y);
				}
			}
		}
	}
	
	[UIView commitAnimations];
}

- (void)scrambleBoardComplete
{
	DLog("scrambleBoardComplete");
	[self makeClickSound];
	[self updateBoard];
	[self setUserInteractionEnabled:YES];
}

- (void)resetBoard
{
	[self setUserInteractionEnabled:NO];
	
	// Clear grid
	for (int x = 0; x < config.columns; x++)
	{
		for (int y = 0; y < config.rows; y++)
		{
			grid[x][y] = NULL;
		}
	}
	
	// Scramble Animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kTileResetTime];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(resetBoardComplete)];
	
	
	for (Tile *tile in tiles)
	{		
		int x = ((tile.tileId - 1) % config.columns);
		int y = ((tile.tileId - 1) / config.columns);
		grid[x][y] = tile;
		[tile moveToCoordX:x coordY:y];
	}
	
	[UIView commitAnimations];
}

- (void)resetBoardComplete
{
	DLog("resetBoardComplete");
	[self makeClickSound];
	[self setUserInteractionEnabled:YES];
	[dialogView displayStartDialog];
}

- (void)createTiles
{	
	// Clean up/remove previous tiles (if exist)
	for (Tile *tile in tiles)
	{
		[tile removeFromSuperview];
	}
	[tiles removeAllObjects];
	[tiles release];
	
	CGImageRef imageRef = [photo CGImage];
	
	// Calculate tile size
	CGSize tileSize = CGSizeMake(trunc(self.frame.size.width / config.columns),
								 trunc(self.frame.size.height / config.rows));
	
	int numberTiles = (config.columns * config.rows);
	tiles = [[NSMutableArray arrayWithCapacity:numberTiles] retain];
	
	Coord coord = { 0, 0 };
	int tileId = 1;
	do
	{
		CGRect tileRect = CGRectMake((coord.x * tileSize.width),
									 (coord.y * tileSize.height),
									 tileSize.width, 
									 tileSize.height);
		CGImageRef tileRef = CGImageCreateWithImageInRect(imageRef, tileRect);

		Tile *tile = [[Tile alloc] initWithId:tileId
										board:self
										coord:coord
										photo:tileRef];
		CGImageRelease(tileRef);
		
		[tiles addObject:tile];
		[tile release];
		
		if (++coord.x >= config.columns)
		{
			coord.x = 0;
			coord.y++;
		}
		
		[self performSelectorOnMainThread:@selector(updateProgress:)
							   withObject:[NSNumber numberWithFloat:((float) tileId/(float) numberTiles)]
							waitUntilDone:NO];
		tileId++;
	} while (coord.x < config.columns && (coord.y < config.rows));
	
	// Removed last tile
	[tiles removeLastObject];
	
	// Restore previous board state (if applicable)
	if (self.gameState == GameNotStartedResume)
	{		
		for (Tile *tile in tiles)
		{
			NSNumber *tileId = [NSNumber numberWithInt:[tile tileId]];
			NSArray *coord = (NSArray *) [boardState objectForKey:tileId];
			if (coord != nil)
			{
				int x = [(NSNumber *) [coord objectAtIndex:0] intValue];
				int y = [(NSNumber *) [coord objectAtIndex:1] intValue];
				
				[tile moveToCoordX:x coordY:y];
				grid[x][y] = tile;
			}
		}
		
		NSArray *coord = (NSArray *) [boardState objectForKey:[NSNumber numberWithInt:0]];
		empty.x = [(NSNumber *) [coord objectAtIndex:0] intValue];
		empty.y = [(NSNumber *) [coord objectAtIndex:1] intValue];
		
		[boardState removeAllObjects];
	}
	
	// Add tiles to board
	for (Tile *tile in tiles)
	{
		[self addSubview:tile];
	}
}

- (void)dealloc
{
	DLog("dealloc");
	
	// Free 2D grid array
	for (int i = 0; i < kColumnsMax; i++)
	{
		if (grid[i]) free(grid[i]);
	}
	if (grid) free(grid);
	
	AudioServicesDisposeSystemSoundID(tockSSID);
	[config release];
	[waitView release];
	[dialogView release];
	[photo release];
	[tiles release];
	[tileLock release];
	[boardController release];
	[boardState release];
	[clock release];
	[super dealloc];
}

@end
