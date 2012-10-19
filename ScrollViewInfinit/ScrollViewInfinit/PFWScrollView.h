//
//  ScrollView.h
//  ScrollViewInfinit
//
//  Created by Katharina on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFWScrollView : UIScrollView <UIScrollViewDelegate>{


    int currIndex;
    NSArray *pageArray;
//    NSArray *array;
}

@property (nonatomic, retain) NSArray *pageArray;

- (id) initWithArray:(NSArray *)array;
//- (void)scrollViewDidEndDecelerating:(NSArray *)array;
//- (NSArray *) declareArray:(NSArray *)array;

@end
