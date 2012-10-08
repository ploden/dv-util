//
//  KDScrollViewContentView.m
//  ScrollViewInfinit
//
//  Created by Katharina on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFWScrollViewContentView.h"

@implementation PFWScrollViewContentView

@synthesize documentTitles;
@synthesize prevIndex, currIndex, nextIndex;
@synthesize label;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    return self;
}

-(void)configureForPageNumber:(int)index{
    

    UILabel *labelTest = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    labelTest.text = [NSString stringWithFormat:@"TestPage %i", index];
    labelTest.textAlignment = UITextAlignmentCenter;
    [self addSubview:labelTest];
    [labelTest release];
}



@end