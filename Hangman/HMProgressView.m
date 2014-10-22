//
//  HMProgressView.m
//  Hangman
//
//  Created by junchen on 10/18/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMProgressView.h"

@interface HMProgress : UIView

@end

@implementation HMProgress

- (void)drawRect:(CGRect)rect
{
    
}

@end

@implementation HMProgressView

- (void)initiate
{
    [UIView animateWithDuration:1.0 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.progress.frame;
                         frame.origin.y = 0;
                         self.progress.frame = frame;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect frame = self.progress.frame;
                                              frame.origin.y = 320;
                                              self.progress.frame = frame;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                     }];
}

@end
