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
#import "UIView+Toast.h"

@interface HMViewController ()

@end

@implementation HMViewController

@synthesize startupViewController;
@synthesize mainViewController;
@synthesize scoreViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    startupViewController = [[HMStartupViewController alloc] initWithNibName:@"HMStartupViewController" bundle:nil];
    startupViewController.view.frame = self.view.frame;
    startupViewController.delegate = self;
    [self.view addSubview:startupViewController.view];
}

#pragma mark Startup Delegate
- (void)switchToMainFromStartup
{
    [startupViewController.view removeFromSuperview];
    self.startupViewController = nil;
    
    mainViewController = [[HMMainViewController alloc] initWithNibName:@"HMMainViewController" bundle:nil];
    mainViewController.view.frame = self.view.frame;
    [self.view addSubview:mainViewController.view];
}

- (void)startupToastView:(NSDictionary *)toastInfo
{
    [self toastView:toastInfo];
}

#pragma mark
-(void)toastView:(NSDictionary *)toastInfo
{
    [self.view makeToast:[toastInfo objectForKey:@"message"]
                duration:[[toastInfo objectForKey:@"duration"] floatValue]
                position:[toastInfo objectForKey:@"position"]
                   title:[toastInfo objectForKey:@"title"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
