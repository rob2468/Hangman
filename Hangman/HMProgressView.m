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

const CGFloat interval = 320.0/80.0;        // one step length of increasing one progress

@implementation HMProgressView

- (void)initiate
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint p1 = CGPointMake(35.0, 480.0);
    CGPoint p2 = CGPointMake(35.0, 160.0);
    CGPoint p3 = CGPointMake(35.0, 480.0);
    NSArray *values = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:p1],
                       [NSValue valueWithCGPoint:p2],
                       [NSValue valueWithCGPoint:p3], nil];
    [anim setValues:values];
    [anim setDuration:2.0];
    CAMediaTimingFunction *tf1 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CAMediaTimingFunction *tf2 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    NSArray *timingFunctions = [NSArray arrayWithObjects:tf1, tf2, nil];
    [anim setTimingFunctions:timingFunctions];
    [self.progress.layer addAnimation:anim forKey:@"ani"];
}

- (void)increaseOneStepProgress
{
    
    CGRect frame = self.progress.frame;
    frame.origin.y -= interval;
    self.progress.frame = frame;
}

@end
