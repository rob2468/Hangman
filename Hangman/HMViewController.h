//
//  HMViewController.h
//  Hangman
//
//  Created by junchen on 10/5/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMStartupViewController;
@class HMMainViewController;
@class HMScoreViewController;

@interface HMViewController : UIViewController

@property (strong, nonatomic) HMStartupViewController *startupViewController;
@property (strong, nonatomic) HMMainViewController *mainViewController;
@property (strong, nonatomic) HMScoreViewController *scoreViewController;

@end

