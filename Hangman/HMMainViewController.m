//
//  HMMainViewController.m
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMMainViewController.h"
#import "HMHangmanView.h"
#import "HMGuessView.h"
#import "HMProgressView.h"
#import "HMStaticData.h"
#import "UIView+Toast.h"

const static NSString *correctMsg = @"Great!";
const static NSString *failMsg = @"Fail!";

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maskView.layer.shadowOpacity = 0.5f;
    self.maskView.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
    [self.gallowsView initiate];
    HMStaticData *staticData = [HMStaticData instance];
    self.numberOfWordsToGuessLabel.text = [NSString stringWithFormat:@"%ld", (long)staticData.numberOfWordsToGuess];
    [self.progressView initiate];
    
    [self giveMeAWordMethod];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    self.textFieldContentView.textFieldContentViewOriginYPos = self.view.frame.size.height-self.textFieldContentView.frame.origin.y;
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
    [self.gallowsView resetToOriginState];
    if (data != nil)
    {
        NSString *word = [data objectForKey:@"word"];
        
        // request exceed the last word, finish this round
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
        // get a new word successfully
        else
        {
            NSDictionary *jsonData = [data objectForKey:@"data"];
            if (jsonData != nil)
            {
                NSInteger tried = [[jsonData objectForKey:@"numberOfWordsTried"] integerValue];
                NSInteger guessed = [[jsonData objectForKey:@"numberOfGuessAllowedForThisWord"] integerValue];
                
                self.gallowsView.totalPullTimes = guessed;
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
            NSInteger lastGuessed = [self.numberOfGuessAllowedForEachWordLabel.text integerValue];
            NSInteger guessed = [[jsonData objectForKey:@"numberOfGuessAllowedForThisWord"] integerValue];
            self.numberOfGuessAllowedForEachWordLabel.text = [NSString stringWithFormat:@"%ld", (long)guessed];
            
            // fail to guess this time
            if (guessed<lastGuessed)
            {
                [self.gallowsView pullWithRemainPullTimes:guessed];
            }
            
            // fail to guess this word
            if (guessed == 0)
            {
                self.statusLabel.text = [NSString stringWithFormat:@"%@", failMsg];
                self.skipWordButton.hidden = YES;
                self.nextWordButton.hidden = NO;
            }
        }
        NSString *word = [data objectForKey:@"word"];
        // keep guessing without guess times remain
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
            
            self.statusLabel.text = [NSString stringWithFormat:@"%@", failMsg];
            self.skipWordButton.hidden = YES;
            self.nextWordButton.hidden = NO;
        }
        // set word
        else
        {
            NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"*"];
            NSRange range = [word rangeOfCharacterFromSet:cs];
            if (range.location == NSNotFound)
            {
                self.statusLabel.text = [NSString stringWithFormat:@"%@", correctMsg];
                self.skipWordButton.hidden = YES;
                self.nextWordButton.hidden = NO;
            }
            self.wordLabel.text = word;
        }
    }
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

- (IBAction)endGameButtonTouchUpInsider:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"You will lose your game record.\nEnd game anyway?"
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.delegate switchToStartupFromMain];
    }
}

#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.textFieldContentView animateTextField:nil up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.textFieldContentView animateTextField:nil up:NO];
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
