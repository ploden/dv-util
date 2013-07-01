//
//  DVTabBarVC.m
//  HeinekenWingman
//
//  Created by Philip Loden on 4/26/13.
//  Copyright (c) 2013 HurleyApps. All rights reserved.
//

#import "DVTabBarVC.h"

@interface DVTabBarVC ()

- (IBAction)tabBarButtonTouched:(id)sender;

@end

@implementation DVTabBarVC

- (void)viewDidLoad {
  [super viewDidLoad];

  _selectedIndex = NSNotFound;
  [self setSelectedIndex:self.initialSelectedIndex];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  for (UIViewController *controller in self.childViewControllers) {
    if (controller != self.selectedViewController) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [controller removeFromParentViewController];
      });
    }
  }
}

- (void)configureWithViewController:(UIViewController *)aVC previousViewController:(UIViewController*)aPreviousVC {
  [aVC.view setFrame:[self childViewControllerFrameRect]];;
  
  if (! aVC.title && ! [DVHelper isNilOrEmtpyString:[self.tabBarButtons[aVC.view.tag] titleForState:UIControlStateNormal]]) {
    aVC.title = [self.tabBarButtons[aVC.view.tag] titleForState:UIControlStateNormal];
  }
  
  [self setTitle:aVC.title];
  
  if (aPreviousVC.parentViewController) {
    [self transitionFromViewController:aPreviousVC toViewController:aVC duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
  } else {
    // already child because of vcForIndex    
    [self.contentView addSubview:aVC.view];
  }
}

- (UIViewController *)selectedViewController {
  NSArray *vcArr = [self.childViewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"view.tag == %d",_selectedIndex]];
  return ([vcArr count] > 0) ? vcArr[0] : nil;
}

- (void)setSelectedIndex:(NSUInteger)idx {
  if (idx == _selectedIndex) return;
  
  if (_selectedIndex < [self.tabBarButtons count]) {
    UIButton *currentlySelectedButton = self.tabBarButtons[_selectedIndex];
    [currentlySelectedButton setSelected:NO];
  }
  
  UIButton *newlySelectedButton = [self.tabBarButtons objectAtIndex:idx];
  [newlySelectedButton setSelected:YES];
  
  UIViewController *currentViewController = [self selectedViewController];
  
  _selectedIndex = idx;
  
  [self configureWithViewController:[self vcForIndex:_selectedIndex] previousViewController:currentViewController];
}

- (CGRect)childViewControllerFrameRect {
  return self.contentView.bounds;
}

- (UIViewController *)vcForIndex:(NSUInteger)idx {
  NSArray *vcArr = [self.childViewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"view.tag == %d",idx]];
  if ([vcArr count] > 0) {
    UIViewController *vc = vcArr[0];
    if ([vc isViewLoaded]) {
      return vc;
    } else {
      [vc removeFromParentViewController];
    }
  }
  
  UIViewController *vc = [self createVCForIndex:idx];
  vc.view.tag = idx;
  [self addChildViewController:vc];
  
  return vc;
}

+ (NSUInteger)numTabs {
  // subclass
  [DVHelper raiseVirtualMethodCalledException];
  return NSNotFound;
}

- (UIViewController *)createVCForIndex:(NSUInteger)idx {
  // subclass
  [DVHelper raiseVirtualMethodCalledException];
  return nil;
}

- (NSArray *)tabBarButtons {
  // subclass
  [DVHelper raiseVirtualMethodCalledException];
  return nil;
}

- (IBAction)tabBarButtonTouched:(id)sender {
  NSUInteger idx = [self.tabBarButtons indexOfObject:sender];
  if ( idx != NSNotFound ) [self setSelectedIndex:idx];
}

@end
