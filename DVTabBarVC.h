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
  NSUInteger _selectedIndex;
}

@property (nonatomic, strong) NSArray *tabBarButtons;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSUInteger initialSelectedIndex;
@property (nonatomic, strong) IBOutlet UIView *contentView;

- (UIViewController *)selectedViewController;
- (CGRect)childViewControllerFrameRect;
+ (NSUInteger)numTabs;
- (UIViewController *)createVCForIndex:(NSUInteger)idx;
- (IBAction)tabBarButtonTouched:(id)sender;
- (void)configureWithViewController:(UIViewController *)aVC previousViewController:(UIViewController*)aPreviousVC;
- (void)setSelectedIndex:(NSUInteger)idx;

@end
