//
//  KDScrollViewContentView.h
//  ScrollViewInfinit
//
//  Created by Katharina on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFWScrollViewProtocol.h"

@interface PFWScrollViewContentView : UIView<UIScrollViewDelegate, PFWScrollViewProtocol>{
    NSMutableArray *documentTitles;
    UILabel *label;
}

@property (nonatomic, retain) UILabel *label;

@property (nonatomic, retain) NSMutableArray *documentTitles;
@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;


@end
