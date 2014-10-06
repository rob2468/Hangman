//
//  HMScoreViewController.m
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMScoreViewController.h"
#import "HMStaticData.h"
#import "UIView+Toast.h"

@interface HMScoreViewController ()

@end

@implementation HMScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getTestResultsMethod];
}

#pragma mark
- (void)getTestResultsMethod
{
    HMStaticData *staticData = [HMStaticData instance];
    NSURL *url = [NSURL URLWithString:staticData.urlString];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          staticData.userId, @"userId",
                          staticData.GetTestResultsAction, @"action",
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
                               [self performSelectorOnMainThread:@selector(postGetTestResults) withObject:nil waitUntilDone:YES];
                               if (connectionError)
                               {
                                   NSLog(@"Httperror: %@%ld", connectionError.localizedDescription, (long)connectionError.code);
                               }
                               else
                               {
                                   NSError *error;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   NSLog(@"%@", json);
                                   [self performSelectorOnMainThread:@selector(postGetTestResultsSuccess:) withObject:json waitUntilDone:YES];
                               }
                           }];
}

- (void)postGetTestResults
{
    [self.activity stopAnimating];
}

- (void)postGetTestResultsSuccess:(NSDictionary *)data
{
    if (data != nil)
    {
        NSString *message = [data objectForKey:@"message"];
        NSDictionary *toastInfo = [[NSDictionary alloc]
                                   initWithObjectsAndKeys:
                                   message, @"message",
                                   @"3.0", @"duration",
                                   @"center", @"position",
                                   nil, @"title", nil];
        [self toastView:toastInfo];
        
        NSDictionary *jsonData = [data objectForKey:@"data"];
        if (jsonData != nil)
        {
            NSInteger wordsTried = [[jsonData objectForKey:@"numberOfWordsTried"] integerValue];
            NSInteger correctWords = [[jsonData objectForKey:@"numberOfCorrectWords"] integerValue];
            NSInteger wrongGuesses = [[jsonData objectForKey:@"numberOfWrongGuesses"] integerValue];
            NSInteger totalScore = [[jsonData objectForKey:@"totalScore"] integerValue];
            
            self.wordsTriedLabel.text = [NSString stringWithFormat:@"%ld", (long)wordsTried];
            self.correctWordsLabel.text = [NSString stringWithFormat:@"%ld", (long)correctWords];
            self.wrongGuessesLabel.text = [NSString stringWithFormat:@"%ld", (long)wrongGuesses];
            self.totalScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)totalScore];
        }
    }
}

#pragma mark
- (IBAction)submitButtonTouchUpInside:(UIButton *)sender
{
    HMStaticData *staticData = [HMStaticData instance];
    NSURL *url = [NSURL URLWithString:staticData.urlString];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          staticData.userId, @"userId",
                          staticData.SubmitTestResultsAction, @"action",
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
                               [self performSelectorOnMainThread:@selector(postSubmit) withObject:nil waitUntilDone:YES];
                               if (connectionError)
                               {
                                   NSLog(@"Httperror: %@%ld", connectionError.localizedDescription, (long)connectionError.code);
                               }
                               else
                               {
                                   NSError *error;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   NSLog(@"%@", json);
                                   [self performSelectorOnMainThread:@selector(postSubmitSuccess:) withObject:json waitUntilDone:YES];
                               }
                           }];
}

- (void)postSubmit
{
    [self.activity stopAnimating];
}

- (void)postSubmitSuccess:(NSDictionary *)data
{
    [self.delegate switchToStartupFromScore];
}

- (IBAction)ignoreButtonTouchUpInside:(UIButton *)sender
{
    [self.delegate switchToStartupFromScore];
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
