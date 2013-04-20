//
//  ScrollView.h
//  ScrollViewInfinit
//
//  Created by Katharina on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFWScrollView;

@protocol PFWScrollViewDelegate

- (NSInteger)numberOfPages;
- (void)scrollview:(PFWScrollView *)aScrollView didScrollToPage:(NSInteger)newPageNum;

@end

@protocol PFWScrollViewDetailView

- (void)configureForPageNumber:(NSInteger)index size:(CGSize)aSize;
- (NSNumber *)pageNumber;

@end

@interface PFWScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger currentPageNum;
@property (nonatomic, retain) NSArray *pageArray;
@property (nonatomic, assign) id<PFWScrollViewDelegate> secondDelegate;

- (id)initWithArray:(NSArray *)array;
//- (void)scrollViewDidEndDecelerating:(NSArray *)array;
//- (NSArray *) declareArray:(NSArray *)array;
- (void)scrollToPage:(NSInteger)index;

@end
