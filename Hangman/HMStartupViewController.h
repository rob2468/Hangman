//
//  HMStartupViewController.h
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMStartupViewContollerDelegate;

@interface HMStartupViewController : UIViewController

@property (nonatomic, assign) id<HMStartupViewContollerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@protocol HMStartupViewContollerDelegate <NSObject>

- (void)switchToMainFromStartup;

- (void)startupToastView:(NSDictionary *)toastInfo;

@end