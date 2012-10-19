//
//  KDViewController.h
//  ScrollViewInfinit
//
//  Created by Katharina on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFWScrollView.h"
#import "PFWScrollViewContentView.h"

@class PFWScrollView;

@interface PFWViewController : UIViewController <UIScrollViewDelegate>{
    NSArray *pageSet;
    PFWScrollView *scrollView;
    PFWScrollViewContentView *contentViewOne;
    PFWScrollViewContentView *contentViewTwo;
    PFWScrollViewContentView *contentViewThree;
}

@property (nonatomic, retain) NSArray *pageSet;
@property (nonatomic, retain) PFWScrollView *scrollView;
@property (nonatomic, retain) PFWScrollViewContentView *contentViewOne;
@property (nonatomic, retain) PFWScrollViewContentView *contentViewTwo;
@property (nonatomic, retain) PFWScrollViewContentView *contentViewThree;

@end
