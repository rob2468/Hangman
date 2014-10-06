//
//  HMMainViewController.m
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMMainViewController.h"

const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat TextFieldContentViewOriginHeight;

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TextFieldContentViewOriginHeight = self.view.frame.size.height-self.textFieldContentView.frame.origin.y;
}

- (void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    float movementDistance = PORTRAIT_KEYBOARD_HEIGHT+self.textFieldContentView.frame.size.height-TextFieldContentViewOriginHeight;
    const float movementDuration = 0.3f;
    
    float movement = (up? -movementDistance: movementDistance);
    
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.textFieldContentView.frame = CGRectOffset(self.textFieldContentView.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:nil up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:nil up:NO];
}

- (IBAction)backgroundTouchUpInside:(id)sender
{
    [self.guessTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
