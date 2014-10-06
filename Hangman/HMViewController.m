//
//  HMViewController.m
//  Hangman
//
//  Created by junchen on 10/5/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMViewController.h"
#import "HMStartupViewController.h"
#import "HMMainViewController.h"
#import "HMScoreViewController.h"

@interface HMViewController ()

@end

@implementation HMViewController

@synthesize startupViewController;
@synthesize mainViewController;
@synthesize scoreViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    startupViewController = [[HMStartupViewController alloc] initWithNibName:@"HMStartupViewController" bundle:nil];
    [self.view addSubview:startupViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
