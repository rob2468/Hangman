//
//  HMStaticData.h
//  Hangman
//
//  Created by junchen on 10/6/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMStaticData : NSObject

+ (HMStaticData *)instance;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *secret;

@property (nonatomic, copy) NSString *InitiateGameAction;
@property (nonatomic, copy) NSString *GiveMeAWordAction;
@property (nonatomic, copy) NSString *MakeAGuessAction;
@property (nonatomic, copy) NSString *GetTestResultsAction;
@property (nonatomic, copy) NSString *SubmitTestResultsAction;

@property (nonatomic, assign) NSInteger numberOfWordsToGuess;
@property (nonatomic, assign) NSInteger numberOfGuessAllowedForEachWord;

@end
