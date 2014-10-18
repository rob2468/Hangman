//
//  HMGuessView.h
//  Hangman
//
//  Created by junchen on 10/18/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMGuessView : UIView

@property (nonatomic, assign) CGFloat textFieldContentViewOriginYPos;

- (void)animateTextField:(UITextField *)textField up:(BOOL)up;

@end
