//
//  HMMainViewController.h
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMainViewController : UIViewController
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *textFieldContentView;
@property (weak, nonatomic) IBOutlet UITextField *guessTextField;

@end
