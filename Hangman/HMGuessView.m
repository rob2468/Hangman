//
//  HMGuessView.m
//  Hangman
//
//  Created by junchen on 10/18/14.
//  Copyright (c) 2014 Strikingly. All rights reserved.
//

#import "HMGuessView.h"

const static CGFloat PortraitKeybordHeight = 216;

@implementation HMGuessView

@synthesize textFieldContentViewOriginYPos;

// will draw a frame like picture below, that is two semicircle in the left and right side of the view, and
// a rectangle in the mid of the view.
// there is gradient effect in the edge of these shapes
//   ------
// (        )
//   ------

- (void)drawRect:(CGRect)rect {
    UIColor *myLightGraphColor0 = [UIColor colorWithRed:219/255.f green:207/255.f blue:202/255.f alpha:0];
    UIColor *myLightGraphColor1 = [UIColor colorWithRed:219/255.f green:207/255.f blue:202/255.f alpha:0.9];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextAddRect(context, CGRectMake(43, 0, 64, 50));
        CGContextClip(context);
        
        CGGradientRef gradient;
        CGColorSpaceRef colorspace;
        CGFloat locations[4] = {0.0, 0.3, 0.7, 1.0};
        
        NSArray *colors = @[(id)myLightGraphColor0.CGColor,
                            (id)myLightGraphColor1.CGColor,
                            (id)myLightGraphColor1.CGColor,
                            (id)myLightGraphColor0.CGColor];
        
        colorspace = CGColorSpaceCreateDeviceRGB();
        
        gradient = CGGradientCreateWithColors(colorspace,
                                              (CFArrayRef)colors, locations);
        
        CGPoint startPoint, endPoint;
        startPoint.x = 75;
        startPoint.y = 0;
        endPoint.x = 75;
        endPoint.y = 50;
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    }
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    {
        CGContextAddRect(context, CGRectMake(0, 0, 43, 50));
        CGContextClip(context);
        
        CGGradientRef gradient;
        CGColorSpaceRef colorspace;
        CGFloat locations[2] = {0.4, 1.0};
        
        NSArray *colors = @[(id)myLightGraphColor1.CGColor,
                            (id)myLightGraphColor0.CGColor];
        
        colorspace = CGColorSpaceCreateDeviceRGB();
        
        gradient = CGGradientCreateWithColors(colorspace,
                                              (CFArrayRef)colors, locations);
        
        CGPoint startPoint, endPoint;
        CGFloat startRadius, endRadius;
        startPoint.x = 43;
        startPoint.y = 25;
        endPoint.x = 43;
        endPoint.y = 25;
        startRadius = 0;
        endRadius = 25;
        CGContextDrawRadialGradient (context, gradient, startPoint,
                                     startRadius, endPoint, endRadius,
                                     0);
    }
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    {
        CGContextAddRect(context, CGRectMake(107, 0, 43, 50));
        CGContextClip(context);
        
        CGGradientRef gradient;
        CGColorSpaceRef colorspace;
        CGFloat locations[2] = {0.4, 1.0};
        
        NSArray *colors = @[(id)myLightGraphColor1.CGColor,
                            (id)myLightGraphColor0.CGColor];
        
        colorspace = CGColorSpaceCreateDeviceRGB();
        
        gradient = CGGradientCreateWithColors(colorspace,
                                              (CFArrayRef)colors, locations);
        
        CGPoint startPoint, endPoint;
        CGFloat startRadius, endRadius;
        startPoint.x = 107;
        startPoint.y = 25;
        endPoint.x = 107;
        endPoint.y = 25;
        startRadius = 0;
        endRadius = 25;
        CGContextDrawRadialGradient (context, gradient, startPoint,
                                     startRadius, endPoint, endRadius,
                                     0);
    }
    CGContextRestoreGState(context);
}

- (void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    float movementDistance = PortraitKeybordHeight+self.frame.size.height-textFieldContentViewOriginYPos;
    const float movementDuration = 0.3f;
    
    float movement = (up? -movementDistance: movementDistance);
    
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.frame = CGRectOffset(self.frame, 0, movement);
    [UIView commitAnimations];
}


@end
