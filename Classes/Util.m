//
//  Util.m
//  Y-Tiles
//
//  Created by Chris Yunker on 3/1/09.
//  Copyright 2009 chrisyunker.com. All rights reserved.
//

#import "Util.h"
#import "Constants.h"

@implementation Util

+ (CGContextRef)newBitmapContextForWidth:(float)width
								  height:(float)height
{	
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
												 width,
												 height,
												 8,
												 (width * 4),
												 colorSpaceRef,
												 kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpaceRef);
	
	return context;
}

+ (void)drawRoundedRectForPath:(CGMutablePathRef)path
						  rect:(CGRect)rect
						radius:(float)radius
{	
	CGPoint origin = rect.origin;
	CGSize size = rect.size;
	
	CGPathMoveToPoint(path, NULL, origin.x + radius, origin.y);
	
	CGPathAddLineToPoint(path, NULL,
						 (origin.x + size.width - radius), origin.y);
	CGPathAddArcToPoint(path, NULL,
						(origin.x + size.width), origin.y,
						(origin.x + size.width), (origin.y + radius),
						radius);
	CGPathAddLineToPoint(path, NULL,
						 (origin.x + size.width), (origin.y + size.height - radius));
	CGPathAddArcToPoint(path, NULL,
						(origin.x + size.width), (origin.y + size.height),
						(origin.x + size.width - radius), (origin.y + size.height),
						radius);
	CGPathAddLineToPoint(path, NULL,
						 (origin.x + radius), (origin.y + size.height));
	CGPathAddArcToPoint(path, NULL,
						origin.x, (origin.y + size.height),
						origin.x, (origin.y + size.height - radius),
						radius);
	CGPathAddLineToPoint(path, NULL,
						 origin.x, (origin.y + radius));
	CGPathAddArcToPoint(path, NULL,
						origin.x, origin.y,
						(origin.x + radius), origin.y,
						radius);
}

+ (UIButton *)createButtonForFrame:(CGRect)frame
							 image:(UIImage *)image
					 imageSelected:(UIImage *)imageSelected
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:frame];
	[button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newSelectedImage = [imageSelected stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newSelectedImage forState:UIControlStateHighlighted];
	
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button setBackgroundColor:[UIColor clearColor]];
	
	return button;
}

@end
