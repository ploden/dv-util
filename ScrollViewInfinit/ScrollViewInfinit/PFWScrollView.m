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

- (id)initWithArray:(NSArray *)array {
  if ( ! (self = [super init]) ) return nil;
  
  [self setPageArray:array];
  
  [self setClipsToBounds:YES];
  
  [super setDelegate:self];

  _currentPageNum = 0;
  
  return self;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
  [super setDelegate:self];
}

- (void)setPageArray:(NSArray *)pageArray {
  self.delegate = self;
  
  if (pageArray != _pageArray) {
    [self setScrollEnabled:YES];
    [self setPagingEnabled:YES];
    
    _pageArray = pageArray;
        
    CGSize size = self.frame.size;

    for (int i = 0; i < 3; i++) {
      UIView<PFWScrollViewDetailView> *v = _pageArray[i];
      CGRect frameRect = CGRectMake(i * size.width, 0.0f, size.width, size.height);
      [v setFrame:frameRect];
      [self addSubview:v];
      [v configureForPageNumber:_currentPageNum + i size:CGSizeZero];
    }
    
    [self setContentSize:CGSizeMake(3*self.frame.size.width, self.frame.size.height)];
    [self scrollRectToVisible:CGRectMake(0,0,size.width,size.height) animated:NO];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGSize size = self.frame.size;
  
  CGFloat pageWidth = self.frame.size.width;
  float fractionalPage = self.contentOffset.x / pageWidth;
  NSInteger pageIndex = (int)lround(fractionalPage);
    
  NSInteger newPageNum = 0;
  
  NSInteger max = [self.secondDelegate numberOfPages];
  
  switch (pageIndex) {
    case 0:
      newPageNum = _currentPageNum - 1;
      break;
    case 1:
      if (_currentPageNum == 0) {
        newPageNum = 1;
      } else if (_currentPageNum == max) {
        newPageNum = max - 1;
      } else {
        return;
      }
      break;
    case 2:
      newPageNum = _currentPageNum + 1;
      break;
    default:
      break;
  }
  
  newPageNum = MAX(0, MIN(newPageNum, max - 1));
  
  if (newPageNum != _currentPageNum) {
    if (_currentPageNum <= 1 && newPageNum <= 1) {
      // do nothing, already scrolled far left
    } else if (_currentPageNum >= ([self.secondDelegate numberOfPages] - 2)) {
      // do nothing, already scrolled far right
      NSLog(@"right");
    } else {
      // scroll so that current page is now in middle
      for (int i = 0; i < 3; i++) {
        [_pageArray[i] configureForPageNumber:newPageNum + (i - 1) size:CGSizeZero];
      }
      [self scrollRectToVisible:CGRectMake(size.width,0,size.width,size.height) animated:NO];
    }
    
    _currentPageNum = newPageNum;
  }
  
  [self setContentOffset:CGPointMake(self.contentOffset.x,0)];

  [self.secondDelegate scrollview:self didScrollToPage:newPageNum];
}

- (void)scrollToPage:(NSInteger)index {
  if (index == _currentPageNum) return;
  
  _currentPageNum = index;
  
  CGSize size = self.frame.size;

  NSInteger offset = 0;
  
  CGFloat xOffset = 0.0f;
  
  if (index == 0) {
    offset = 0;
    xOffset = 0.0f;
  } else if (index == [self.secondDelegate numberOfPages] - 1) {
    offset = 2;
    xOffset = size.width * 2;
  } else {
    offset = 1;
    xOffset = size.width;
  }
  
  for (int i = 0; i < 3; i++) {
    [_pageArray[i] configureForPageNumber:index + (i - offset) size:CGSizeZero];
  }
  
  [self scrollRectToVisible:CGRectMake(xOffset, 0.0f, size.width, size.height) animated:NO];
}

- (void)layoutSubviews {
  CGSize size = self.frame.size;
  
  for (int i = 0; i < 3; i++) {
    UIView<PFWScrollViewDetailView> *v = _pageArray[i];
    CGRect frameRect = CGRectMake(i * size.width, 0.0f, size.width, size.height);
    [v setFrame:frameRect];
  }
  
  [self setContentSize:CGSizeMake(3*self.frame.size.width, self.frame.size.height)];
  ;
}

@end
