//
//  ScrollView.m
//  ScrollViewInfinit
//
//  Created by Katharina on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFWScrollView.h"
#import "PFWScrollViewProtocol.h"



@implementation PFWScrollView

@synthesize pageArray;

- (id)initWithArray:(NSArray *)array{
    [super init];
    
    [self setScrollEnabled:YES];
    [self setPagingEnabled:YES];
    pageArray = [[NSArray alloc] initWithArray:array];

    currIndex = 4;

    for (int i=0; i<3; i++) {
        [[pageArray objectAtIndex:i] configureForPageNumber:currIndex + i];
        [self addSubview:[pageArray objectAtIndex:i]];
    }

    NSLog(@" %@",[pageArray objectAtIndex:1]);
    [self setContentSize:CGSizeMake(3*768, 1)];	
    [self scrollRectToVisible:CGRectMake(0,0,768,1024) animated:NO];
    
    self.delegate = self;
    
    return self;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@" %@",[pageArray objectAtIndex:1]);
    
    
    if (self.contentOffset.x == 0 && currIndex > 0) {
        currIndex = currIndex - 1;    
        for (int i=0; i<3; i++) {
            [[pageArray objectAtIndex:i] configureForPageNumber:currIndex + i];
            [self scrollRectToVisible:CGRectMake(768,0,768,1024) animated:NO];
        }
    } else if (self.contentOffset.x == 1536 && currIndex < 4){
        currIndex = currIndex + 1;
        for (int i=0; i<3; i++) {
            [[pageArray objectAtIndex:i] configureForPageNumber:currIndex + i];
            [self scrollRectToVisible:CGRectMake(768,0,768,1024) animated:NO];
        }
    }

    [self setContentOffset:CGPointMake(self.contentOffset.x,0)];
    
}


- (void)dealloc {
    for (int i=0; i<3; i++) {
    }
    [super dealloc];
}


@end
