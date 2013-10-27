//
//  Clock.m
//  Y-Tiles
//
//  Created by Chris Yunker on 7/24/10.
//  Copyright 2010 chrisyunker.com. All rights reserved.
//

#import "Clock.h"


@interface Clock (Private)

- (void)updateSecond:(NSTimer *)timer;
- (void)updateClock;
- (void)setTimer;

@end


@implementation Clock

@synthesize seconds;
@synthesize startTime;

- (id)init
{
	if (self = [super init])
	{
		running = NO;
		baseSeconds = 0.0f;
		currentSeconds = 0.0f;
		[self setStartTime:nil];
		[self setSeconds:0];
	}
	return self;
}

- (void)dealloc
{
	[startTime release];
	[super dealloc];
}


- (void)start
{
	if (!running)
	{
		running = YES;
	
		[self setStartTime:[NSDate date]];
		[self setTimer];
	}
}

- (void)stop
{
	if (running)
	{		
		running = NO;
		
		[self updateClock];
		baseSeconds = currentSeconds;
		[self setStartTime:nil];	
	}
}

- (void)reset
{	
	running = NO;
	baseSeconds = 0.0f;
	currentSeconds = 0.0f;
	[self setStartTime:nil];
	[self setSeconds:0];
}

- (void)resetToSeconds:(int)aSeconds
{
	running = NO;
	baseSeconds = (float) aSeconds;
	currentSeconds = (float) aSeconds;
	[self setStartTime:nil];
	[self setSeconds:aSeconds];
}


- (void)updateSecond:(NSTimer *)timer
{	
	if (running)
	{
		[self updateClock];
		[self setTimer];
	}
}

- (void)updateClock
{
	NSDate *currentTime = [NSDate date];
	float difference = [currentTime timeIntervalSinceDate:startTime];
	if (difference > 0)
	{
		currentSeconds = (baseSeconds + difference);
		[self setSeconds:(int) currentSeconds];
	}
}

- (void)setTimer
{
	float interval = 1.0f - (currentSeconds - trunc(currentSeconds));
	
	[NSTimer scheduledTimerWithTimeInterval:interval
									 target:self
								   selector:@selector(updateSecond:)
								   userInfo:nil
									repeats:NO];
}

@end
