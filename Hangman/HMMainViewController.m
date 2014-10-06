//
//  HMMainViewController.m
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMMainViewController.h"
#import "HMStaticData.h"
#import "UIView+Toast.h"

CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat TextFieldContentViewOriginHeight;
NSString *correctMsg = @"Great!";
NSString *failMsg = @"Fail!";

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TextFieldContentViewOriginHeight = self.view.frame.size.height-self.textFieldContentView.frame.origin.y;
    
    HMStaticData *staticData = [HMStaticData instance];
    self.numberOfWordsToGuessLabel.text = [NSString stringWithFormat:@"%ld", (long)staticData.numberOfWordsToGuess];
    
    [self giveMeAWordMethod];
}

#pragma mark
- (void)giveMeAWordMethod
{
    HMStaticData *staticData = [HMStaticData instance];
    NSURL *url = [NSURL URLWithString:staticData.urlString];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          staticData.userId, @"userId",
                          staticData.GiveMeAWordAction, @"action",
                          staticData.secret, @"secret", nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPBody:postData];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [req setHTTPMethod:@"POST"];
    
    [self.activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               [self performSelectorOnMainThread:@selector(postGiveMeAWord) withObject:nil waitUntilDone:YES];
                               if (connectionError)
                               {
                                   NSLog(@"Httperror: %@%ld", connectionError.localizedDescription, (long)connectionError.code);
                               }
                               else
                               {
                                   NSError *error;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//                                   NSLog(@"%@", json);
                                   [self performSelectorOnMainThread:@selector(postGiveMeAWordSuccess:) withObject:json waitUntilDone:YES];
                               }
                           }];
}

- (void)postGiveMeAWord
{
    [self.activity stopAnimating];
}

- (void)postGiveMeAWordSuccess:(NSDictionary *)data
{
    if (data != nil)
    {
        NSString *word = [data objectForKey:@"word"];
        if (word == nil)
        {
            NSString *message = [data objectForKey:@"message"];
            NSDictionary *toastInfo = [[NSDictionary alloc]
                                       initWithObjectsAndKeys:
                                       message, @"message",
                                       @"3.0", @"duration",
                                       @"center", @"position",
                                       nil, @"title", nil];
            [self.delegate mainToastView:toastInfo];
            [self.delegate switchToScoreFromMain];
        }
        else
        {
            NSDictionary *jsonData = [data objectForKey:@"data"];
            if (jsonData != nil)
            {
                NSInteger tried = [[jsonData objectForKey:@"numberOfWordsTried"] integerValue];
                NSInteger guessed = [[jsonData objectForKey:@"numberOfGuessAllowedForThisWord"] integerValue];
                
                self.numberOfWordsTriedLabel.text = [NSString stringWithFormat:@"%ld", (long)tried];
                self.numberOfGuessAllowedForEachWordLabel.text = [NSString stringWithFormat:@"%ld", (long)guessed];
            }
            self.wordLabel.text = word;
        }
    }
}

#pragma mark
- (void)makeAGuessMethod
{
    HMStaticData *staticData = [HMStaticData instance];
    NSURL *url = [NSURL URLWithString:staticData.urlString];
    NSString *guessChar = self.guessTextField.text;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          staticData.userId, @"userId",
                          staticData.MakeAGuessAction, @"action",
                          staticData.secret, @"secret",
                          guessChar, @"guess", nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPBody:postData];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [req setHTTPMethod:@"POST"];
    
    [self.activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               [self performSelectorOnMainThread:@selector(postMakeAGuess) withObject:nil waitUntilDone:YES];
                               if (connectionError)
                               {
                                   NSLog(@"Httperror: %@%ld", connectionError.localizedDescription, (long)connectionError.code);
                               }
                               else
                               {
                                   NSError *error;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   NSLog(@"%@", json);
                                   [self performSelectorOnMainThread:@selector(postMakeAGuessSuccess:) withObject:json waitUntilDone:YES];
                               }
                           }];
}

- (void)postMakeAGuess
{
    [self.activity stopAnimating];
}

- (void)postMakeAGuessSuccess:(NSDictionary *)data
{
    if (data != nil)
    {
        NSDictionary *jsonData = [data objectForKey:@"data"];
        if (jsonData != nil)
        {
            NSInteger guessed = [[jsonData objectForKey:@"numberOfGuessAllowedForThisWord"] integerValue];
            self.numberOfGuessAllowedForEachWordLabel.text = [NSString stringWithFormat:@"%ld", (long)guessed];
        }
        NSString *word = [data objectForKey:@"word"];
        if (word == nil)
        {
            NSString *message = [data objectForKey:@"message"];
            NSDictionary *toastInfo = [[NSDictionary alloc]
                                       initWithObjectsAndKeys:
                                       message, @"message",
                                       @"3.0", @"duration",
                                       @"center", @"position",
                                       nil, @"title", nil];
            [self toastView:toastInfo];
            
            self.statusLabel.text = failMsg;
            self.skipWordButton.hidden = YES;
            self.nextWordButton.hidden = NO;
        }
        else
        {
            NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"*"];
            NSRange range = [word rangeOfCharacterFromSet:cs];
            if (range.location == NSNotFound)
            {
                self.statusLabel.text = correctMsg;
                self.skipWordButton.hidden = YES;
                self.nextWordButton.hidden = NO;
            }
            self.wordLabel.text = word;
        }
    }
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

#pragma mark
- (IBAction)skipWordButtonTouchUpInsider:(UIButton *)sender
{
    self.wordLabel.text = @"---------";
    self.statusLabel.text = @"";
    self.numberOfGuessAllowedForEachWordLabel.text = @"-";
    [self giveMeAWordMethod];
}

- (IBAction)nextWordButtonTouchUpInsider:(UIButton *)sender
{
    self.wordLabel.text = @"---------";
    self.statusLabel.text = @"";
    self.numberOfGuessAllowedForEachWordLabel.text = @"-";
    self.skipWordButton.hidden = NO;
    self.nextWordButton.hidden = YES;
    [self giveMeAWordMethod];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.guessTextField resignFirstResponder];
    
    if (!(self.guessTextField.text == nil || [self.guessTextField.text isEqualToString:@""]
        || [[self.guessTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]))
    {
        [self makeAGuessMethod];
    }
    
    return YES;
}

- (IBAction)backgroundTouchUpInside:(id)sender
{
    [self.guessTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 1) ? NO : YES;
}

-(void)toastView:(NSDictionary *)toastInfo
{
    [self.view makeToast:[toastInfo objectForKey:@"message"]
                duration:[[toastInfo objectForKey:@"duration"] floatValue]
                position:[toastInfo objectForKey:@"position"]
                   title:[toastInfo objectForKey:@"title"]];
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
