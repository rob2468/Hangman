//
//  HMScoreViewController.h
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMScoreViewControllerDelegate;

@interface HMScoreViewController : UIViewController

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) id<HMScoreViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (weak, nonatomic) IBOutlet UILabel *wordsTriedLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctWordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongGuessesLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;

@end

@protocol HMScoreViewControllerDelegate <NSObject>

- (void)switchToStartupFromScore;

@end