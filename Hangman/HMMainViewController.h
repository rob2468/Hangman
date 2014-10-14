//
//  HMMainViewController.h
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMMainViewControllerDelegate;

@interface HMMainViewController : UIViewController
<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) id<HMMainViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *numberOfWordsTriedLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfWordsToGuessLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipWordButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *textFieldContentView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuessAllowedForEachWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *guessTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextWordButton;

@property (weak, nonatomic) IBOutlet UIView *gallowsView;
@property (weak, nonatomic) IBOutlet UIImageView *prisonerImageView;
@property (strong, nonatomic) UIDynamicAnimator *hangAnimator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;

@end

@protocol HMMainViewControllerDelegate <NSObject>

- (void)switchToScoreFromMain;
- (void)switchToStartupFromMain;

- (void)mainToastView:(NSDictionary *)toastInfo;

@end