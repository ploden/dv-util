//
//  DVTabBarVC.h
//  HeinekenWingman
//
//  Created by Philip Loden on 4/26/13.
//  Copyright (c) 2013 HurleyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVTabBarVC : UIViewController {
  NSArray *_tabBarButtons;
}

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *tabBarButtons;
@property (nonatomic, assign) NSUInteger selectedIndex;

- (UIViewController *)selectedViewController;
- (CGRect)childViewControllerFrameRect;
+ (NSUInteger)numTabs;
- (UIViewController *)createVCForIndex:(NSUInteger)idx;

@end
