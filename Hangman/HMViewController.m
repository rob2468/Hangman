//
//  HMViewController.m
//  Hangman
//
//  Created by junchen on 10/5/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMViewController.h"
#import "HMStartupViewController.h"
#import "UIView+Toast.h"

@interface HMViewController ()

@end

@implementation HMViewController

@synthesize startupViewController;
@synthesize mainViewController;
@synthesize scoreViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = self.frame;
    
    startupViewController = [[HMStartupViewController alloc] initWithNibName:@"HMStartupViewController" bundle:nil];
    startupViewController.frame = self.view.frame;
    startupViewController.delegate = self;
    [self.view addSubview:startupViewController.view];
}

#pragma mark Startup Delegate
- (void)switchToMainFromStartup
{
    [startupViewController.view removeFromSuperview];
    self.startupViewController = nil;
    
    mainViewController = [[HMMainViewController alloc] initWithNibName:@"HMMainViewController" bundle:nil];
    mainViewController.frame = self.view.frame;
    mainViewController.delegate = self;
    [self.view addSubview:mainViewController.view];
}

- (void)startupToastView:(NSDictionary *)toastInfo
{
    [self toastView:toastInfo];
}

#pragma mark Main Delegate
- (void)switchToScoreFromMain
{
    [mainViewController.view removeFromSuperview];
    mainViewController = nil;
    
    scoreViewController = [[HMScoreViewController alloc] initWithNibName:@"HMScoreViewController" bundle:nil];
    scoreViewController.frame = self.view.frame;
    scoreViewController.delegate = self;
    [self.view addSubview:scoreViewController.view];
}

- (void)switchToStartupFromMain
{
    [mainViewController.view removeFromSuperview];
    mainViewController = nil;
    
    startupViewController = [[HMStartupViewController alloc] initWithNibName:@"HMStartupViewController" bundle:nil];
    startupViewController.frame = self.view.frame;
    startupViewController.delegate = self;
    [self.view addSubview:startupViewController.view];
}

-(void)mainToastView:(NSDictionary *)toastInfo
{
    [self toastView:toastInfo];
}

#pragma mark Score Delegate
- (void)switchToStartupFromScore
{
    [scoreViewController.view removeFromSuperview];
    scoreViewController = nil;
    
    startupViewController = [[HMStartupViewController alloc] initWithNibName:@"HMStartupViewController" bundle:nil];
    startupViewController.frame = self.view.frame;
    startupViewController.delegate = self;
    [self.view addSubview:startupViewController.view];
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
