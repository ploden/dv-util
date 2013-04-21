//
//  DVUtil
//
//  Created by PHILIP LODEN on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVHelper.h"

@interface DVUtil : DVHelper {
	
}

+ (void)shiftOriginX:(UIView *)aView x:(CGFloat)x;
+ (void)shiftOriginY:(UIView *)aView y:(CGFloat)y;
+ (void)setOriginX:(UIView *)aView x:(CGFloat)x;
+ (void)setOriginY:(UIView *)aView y:(CGFloat)y;
+ (void)setOrigin:(UIView *)aView origin:(CGPoint)origin;
+ (void)setWidth:(UIView *)aView width:(CGFloat)width;

@end
