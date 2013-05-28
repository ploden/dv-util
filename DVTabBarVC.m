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

- (void)viewDidLoad
{
  [super viewDidLoad];

  _selectedIndex = NSNotFound;
  [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  
  for (int i = 0; i < [self.class numTabs]; i++) {
    id obj = _viewControllers[i];
    
    if (obj == [NSNull null]) continue;
    
    if (i != _selectedIndex) {
      UIViewController *vc = (UIViewController *)obj;
      [vc removeFromParentViewController];
      _viewControllers[i] = [NSNull null];
    }
  }
}

- (void)configureWithViewController:(UIViewController *)aVC previousViewController:(UIViewController*)aPreviousVC {
  [aVC.view setFrame:[self childViewControllerFrameRect]];
  [aVC.view setTag:1001];
  
  [self setTitle:aVC.title];
  
  if (aPreviousVC.parentViewController) {
    [self transitionFromViewController:aPreviousVC toViewController:aVC duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
  } else {
    // already child because of vcForIndex
    [self.contentView addSubview:aVC.view];
  }
}

- (NSArray *)viewControllers {
  if ( ! _viewControllers ) {
    _viewControllers = [[NSMutableArray alloc] initWithCapacity:[self.class numTabs]];
    
    for (int i = 0; i < [self.class numTabs]; i++) {
      _viewControllers[i] = [NSNull null];
    }
  }
  return _viewControllers;
}

- (UIViewController *)selectedViewController {
  return (_selectedIndex < [self.viewControllers count]) ? self.viewControllers[_selectedIndex] : nil;
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
  if (idx < [_viewControllers count]) {
    UIViewController *vc = _viewControllers[idx];
    if ((id)vc != [NSNull null]) {
      if ([vc isViewLoaded]) {
        return vc;
      } else {
        [vc removeFromParentViewController];
        [_viewControllers replaceObjectAtIndex:idx withObject:[NSNull null]];
      }
    }
  }
  
  UIViewController *vc = [self createVCForIndex:idx];
  [self addChildViewController:vc];
  _viewControllers[idx] = vc;
  
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
