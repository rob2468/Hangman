//
//  HMStaticData.m
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMStaticData.h"

@implementation HMStaticData

@synthesize urlString;
@synthesize userId;
@synthesize secret;

@synthesize InitiateGameAction;
@synthesize GiveMeAWordAction;
@synthesize MakeAGuessAction;
@synthesize GetTestResultsAction;
@synthesize SubmitTestResultsAction;

@synthesize numberOfWordsToGuess;
@synthesize numberOfGuessAllowedForEachWord;

+ (HMStaticData *)instance
{
    static HMStaticData *staticData;
    
    @synchronized(self)
    {
        if (!staticData)
        {
            staticData = [[HMStaticData alloc] init];
            staticData.urlString = @"http://strikingly-interview-test.herokuapp.com/guess/process";
            staticData.userId = @"jam.chenjun@gmail.com";
            
            staticData.InitiateGameAction = @"initiateGame";
            staticData.GiveMeAWordAction = @"nextWord";
            staticData.MakeAGuessAction = @"guessWord";
            staticData.GetTestResultsAction = @"getTestResults";
            staticData.SubmitTestResultsAction = @"submitTestResults";
        }
    }
    return staticData;
}

@end
