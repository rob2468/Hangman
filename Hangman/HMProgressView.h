//
//  HMProgressView.h
//  Hangman
//
//  Created by junchen on 10/18/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMProgress;

@interface HMProgressView : UIView

@property (weak, nonatomic) IBOutlet HMProgress *progress;

- (void)initiate;

@end
