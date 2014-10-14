//
//  HMStartupViewController.m
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMStartupViewController.h"
#import "HMStaticData.h"
#import "UIView+Toast.h"

@interface HMStartupViewController ()

@end

@implementation HMStartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
}

- (IBAction)startGameButtonTouchUpInside:(UIButton *)sender
{
    HMStaticData *staticData = [HMStaticData instance];
    NSURL *url = [NSURL URLWithString:staticData.urlString];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:staticData.userId, @"userId",
                          staticData.InitiateGameAction, @"action", nil];
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
                               [self performSelectorOnMainThread:@selector(postInitiateGame) withObject:nil waitUntilDone:YES];
                               if (connectionError)
                               {
                                   NSLog(@"Httperror: %@%ld", connectionError.localizedDescription, (long)connectionError.code);
                               }
                               else
                               {
                                   HMStaticData *staticData = [HMStaticData instance];
                                   NSError *error;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   if (json != nil)
                                   {
                                       // set data
                                       NSDictionary *jsonData = [json objectForKey:@"data"];
                                       if (jsonData != nil)
                                       {
                                           NSString *numberOfWordsToGuess = [jsonData objectForKey:@"numberOfWordsToGuess"];
                                           NSString *numberOfGuessAllowedForEachWord = [jsonData objectForKey:@"numberOfGuessAllowedForEachWord"];
                                           if (numberOfWordsToGuess != nil && numberOfGuessAllowedForEachWord != nil)
                                           {
                                               staticData.numberOfWordsToGuess = [numberOfWordsToGuess integerValue];
                                               staticData.numberOfGuessAllowedForEachWord = [numberOfGuessAllowedForEachWord integerValue];
                                           }
                                       }
                                       NSString *secret = [json objectForKey:@"secret"];
                                       staticData.secret = secret;
                                       // set view
                                       [self performSelectorOnMainThread:@selector(postInitiateGameSuccess:) withObject:json waitUntilDone:YES];
                                   }
                                }
                           }];
}

- (void)postInitiateGame
{
    [self.activity stopAnimating];
}

- (void)postInitiateGameSuccess:(NSDictionary *)data
{
    [self.delegate switchToMainFromStartup];
    if (data != nil)
    {
        NSString *message = [data objectForKey:@"message"];
        NSDictionary *toastInfo = [[NSDictionary alloc]
                                   initWithObjectsAndKeys:
                                   message, @"message",
                                   @"3.0", @"duration",
                                   @"center", @"position",
                                   nil, @"title", nil];
        [self.delegate startupToastView:toastInfo];
    }
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
