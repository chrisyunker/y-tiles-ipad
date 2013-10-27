//
//  Clock.h
//  Y-Tiles
//
//  Created by Chris Yunker on 7/24/10.
//  Copyright 2010 chrisyunker.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Clock : NSObject
{
	bool running;
	int seconds;
	float baseSeconds;
	float currentSeconds;
	NSDate *startTime;
}

@property (nonatomic, assign) int seconds;
@property (nonatomic, retain) NSDate *startTime;

- (void)start;
- (void)stop;
- (void)reset;
- (void)resetToSeconds:(int)aSeconds;

@end
