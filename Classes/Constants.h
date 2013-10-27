//
//  Constants.h
//  Y-Tiles
//
//  Created by Chris Yunker on 1/3/09.
//  Copyright Chris Yunker 2009. All rights reserved.
//

#define kVersionMajor            1
#define kVersionMinor            0

#define kRowsMin                 4
#define kRowsMax                 12
#define kColumnsMin              4
#define kColumnsMax              9

// Photos
#define kDocumentsDir            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kPhotoType               @"jpg"
#define kPhotoDefaultName        @"Photo%d"
#define kPhotoSmallDefaultName   @"Photo%d_sm"
#define kBoardPhoto              @"BoardPhoto.jpg"
#define kBoardPhotoInvalid       -1
#define kBoardPhotoType          0

// Board
#define kDisplayModeBoardIndex   0
#define kDisplayModePhotoIndex   1
#define kTileScrambleTime        1.0f
#define kTileResetTime           0.7f
