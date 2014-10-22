//
//  HMProgressView.m
//  Hangman
//
//  Created by junchen on 10/18/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMProgressView.h"

@interface HMProgress : UIView

@end

@implementation HMProgress

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = {0.1, 0.9};
    UIColor *startColor = [UIColor colorWithRed:107/255.f green:90/255.f blue:82/255.f alpha:1];
    UIColor *endColor = [UIColor colorWithRed:219/255.f green:207/255.f blue:202/255.f alpha:1];
    NSArray *colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, 320.0);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
}

@end

@implementation HMProgressView

- (void)initiate
{
    [UIView animateWithDuration:1.0 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.progress.frame;
                         frame.origin.y = 0;
                         self.progress.frame = frame;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect frame = self.progress.frame;
                                              frame.origin.y = 320;
                                              self.progress.frame = frame;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                     }];
}

@end
