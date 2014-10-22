//
//  HMProgressView.h
//  Hangman
//
//  Created by junchen on 10/18/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMProgressView : UIView

@property (weak, nonatomic) IBOutlet UIView *progress;

- (void)initiate;

@end
