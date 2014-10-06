//
//  HMViewController.h
//  Hangman
//
//  Created by junchen on 10/5/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMStartupViewController.h"
#import "HMMainViewController.h"
#import "HMScoreViewController.h"

@interface HMViewController : UIViewController
<HMStartupViewContollerDelegate, HMMainViewControllerDelegate, HMScoreViewControllerDelegate>

@property (strong, nonatomic) HMStartupViewController *startupViewController;
@property (strong, nonatomic) HMMainViewController *mainViewController;
@property (strong, nonatomic) HMScoreViewController *scoreViewController;

@end

