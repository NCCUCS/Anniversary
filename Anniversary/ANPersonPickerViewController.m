//
//  ANPersonPickerViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/13/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANPersonPickerViewController.h"
#import "NIPageView.h"

@interface ANPersonPickerViewController ()

@end

@implementation ANPersonPickerViewController

@synthesize button = _button;
@synthesize pageView = _pageView;

#pragma mark - Private

- (void)backButtonClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
  // Frame means where it is
  _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
  _button.backgroundColor = [UIColor redColor];
  [_button setTitle:@"Haha" forState:UIControlStateNormal];
  [self.view addSubview:_button];
  
  _pageView = [[NIPagingScrollView alloc] initWithFrame:self.view.bounds];
  _pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:_pageView];
  
  [self.button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _pageView.delegate = self;
  _pageView.dataSource = self;
  [_pageView reloadData];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  _button = nil;
  _pageView.delegate = nil;
  _pageView.dataSource = nil;
  _pageView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  
}

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
  return 3;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
  NIPageView *view = [[NIPageView alloc] initWithFrame:self.view.bounds];
  view.backgroundColor = [UIColor colorWithWhite:1.0 / 3 * (pageIndex + 1) alpha:1];
  UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
  label.text = [NSString stringWithFormat:@"Page %d", pageIndex];
  label.textAlignment = UITextAlignmentCenter;
  [view addSubview:label];
  
  return view;
}

@end
