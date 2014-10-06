//
//  HMMainViewController.m
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMMainViewController.h"
#import "HMStaticData.h"

const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat TextFieldContentViewOriginHeight;

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
                                   NSLog(@"%@", json);
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
        NSDictionary *jsonData = [data objectForKey:@"data"];
        if (jsonData != nil)
        {
            NSInteger tried = [[jsonData objectForKey:@"numberOfWordsTried"] integerValue];
            NSInteger guessed = [[jsonData objectForKey:@"numberOfGuessAllowedForThisWord"] integerValue];
            
            self.numberOfWordsTriedLabel.text = [NSString stringWithFormat:@"%ld", (long)tried];
            self.numberOfGuessAllowedForEachWordLabel.text = [NSString stringWithFormat:@"%ld", (long)guessed];
        }
        self.wordLabel.text = [data objectForKey:@"word"];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 1) ? NO : YES;
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
