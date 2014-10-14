//
//  HMHangmanView.h
//  Hangman
//
//  Created by junchen on 10/14/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHangmanView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *prisonerImageView;
@property (strong, nonatomic) UIDynamicAnimator *hangAnimator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;

@property (nonatomic, assign) NSInteger totalPullTimes;      // "prisoner" will be pulled totalPullTimes times to death

- (void)initiate;                                   // set variable
- (void)resetToOriginState;                         //
- (void)pullWithRemainPullTimes:(NSInteger)times;   // implement pull action

@end
