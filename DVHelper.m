//
//  DVHelper.m
//
//  Created by PHILIP LODEN on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DVHelper.h"

@implementation UITableView (XCRHelper)

- (void)deselectSelectedRow {
  if (self.indexPathForSelectedRow) {
    [self deselectRowAtIndexPath:self.indexPathForSelectedRow animated:YES];
  }
}

@end

@implementation DVHelper

+ (void)shiftOriginX:(UIView *)aView x:(CGFloat)x {
	CGRect frameRect = aView.frame;
	frameRect.origin.x += x;
	aView.frame = frameRect;
}

+ (void)shiftOriginY:(UIView *)aView y:(CGFloat)y {
	CGRect frameRect = aView.frame;
	frameRect.origin.y += y;
	aView.frame = frameRect;
}

+ (void)setOriginX:(UIView *)aView x:(CGFloat)x {
	CGRect frameRect = aView.frame;
	frameRect.origin.x = x;
	aView.frame = frameRect;
}

+ (void)setOriginY:(UIView *)aView y:(CGFloat)y {
	CGRect frameRect = aView.frame;
	frameRect.origin.y = y;
	aView.frame = frameRect;	
}

+ (void)setOrigin:(UIView *)aView origin:(CGPoint)origin {
	CGRect frameRect = aView.frame;
	frameRect.origin = origin;
	aView.frame = frameRect;
}

+ (void)setWidth:(UIView *)aView width:(CGFloat)width {
	CGRect frameRect = aView.frame;
	frameRect.size.width = width;
	aView.frame = frameRect;
}

@end
