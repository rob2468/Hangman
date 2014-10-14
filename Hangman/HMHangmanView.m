//
//  HMHangmanView.m
//  Hangman
//
//  Created by junchen on 10/14/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMHangmanView.h"

const static CGFloat TopCoverHeightOfPrisonerView = 310.0;  // when "prisoner" is pulled highest, the top height that out of the screen
static CGFloat AppFrameHeight;                              // the height of the app
const static CGFloat BottomGapHeightOfPrisonerView = 34.0;  // when "prisoner" is pulles lowest, the height from the bottom of the screen

static CGFloat BaseHeight;                      // the shortest height of this container view, equal the height of content view, i.e. the image view's height
const static CGFloat PullHeight = 50.0f;        // pull up 50.0 for the last wrong guess

@implementation HMHangmanView

@synthesize totalPullTimes;

- (void)initiate
{
    AppFrameHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    BaseHeight = self.prisonerImageView.frame.size.height;
    
    CGRect frame = self.frame;
    frame.size.height = BaseHeight;
    frame.origin.y = -(frame.size.height + BottomGapHeightOfPrisonerView - AppFrameHeight);
    self.frame = frame;
    
    self.hangAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.prisonerImageView]];
    self.gravityBehavior.gravityDirection = CGVectorMake(0.0, -1.0);
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.prisonerImageView]];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
}

- (void)resetToOriginState
{
    CGRect frame = self.frame;
    frame.size.height = BaseHeight;
    frame.origin.y = -(frame.size.height + BottomGapHeightOfPrisonerView - AppFrameHeight);
    self.frame = frame;
    
    frame = self.prisonerImageView.frame;
    frame.origin.y = 0;
    self.prisonerImageView.frame = frame;
    
    [self.hangAnimator removeAllBehaviors];
}

- (void)pullWithRemainPullTimes:(NSInteger)times
{
    [self.hangAnimator removeAllBehaviors];
    
    CGFloat IntervalHeight = (TopCoverHeightOfPrisonerView + AppFrameHeight - self.prisonerImageView.frame.size.height
                              - BottomGapHeightOfPrisonerView
                              - PullHeight)/(totalPullTimes - 1);
    
    CGRect frame = self.frame;
    if (times==0)
    {
        frame.size.height = BaseHeight + IntervalHeight*(totalPullTimes-times+1) + PullHeight;
    }
    else
    {
        frame.size.height = BaseHeight + IntervalHeight*(totalPullTimes-times);
    }
    frame.origin.y = -(frame.size.height + BottomGapHeightOfPrisonerView - AppFrameHeight);
    self.frame = frame;
    
    [self.hangAnimator addBehavior:self.gravityBehavior];
    [self.hangAnimator addBehavior:self.collisionBehavior];
}

@end
