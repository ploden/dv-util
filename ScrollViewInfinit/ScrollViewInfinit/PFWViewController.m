//
//  KDViewController.m
//  ScrollViewInfinit
//
//  Created by Katharina on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFWViewController.h"
#import "PFWScrollView.h"
#import "PFWScrollViewContentView.h"

@implementation PFWViewController

@synthesize pageSet;
@synthesize scrollView;
@synthesize contentViewOne;
@synthesize contentViewTwo;
@synthesize contentViewThree;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contentViewOne = [[PFWScrollViewContentView alloc] initWithFrame:CGRectMake(0,0,768,1024)];
    contentViewTwo = [[PFWScrollViewContentView alloc] initWithFrame:CGRectMake(768,0,768,1024)];
    contentViewThree = [[PFWScrollViewContentView alloc] initWithFrame:CGRectMake(1536,0,768,1024)];
    pageSet = [[NSArray alloc] initWithObjects: contentViewOne, contentViewTwo, contentViewThree, nil];
    
    NSLog(@"%@", scrollView);
    
    [self setScrollView:[[PFWScrollView alloc] initWithArray:pageSet]];
    
    NSLog(@"%@",scrollView);
    [scrollView setFrame:self.view.frame];
    [[self view] addSubview:[self scrollView]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
