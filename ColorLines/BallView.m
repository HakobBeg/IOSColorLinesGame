//
//  BallView.m
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import "BallView.h"

@implementation BallView

@synthesize isBallAnimated = isBallAnimated;
@synthesize ballColor = ballColor;
@synthesize ballFieldCoordinates = ballFieldCoordinates;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
     //   [self.delegate didNeedsColor];
        ballColor = [UIColor redColor];//[self.delegate didNeedsColor];
        ballFieldCoordinates = [[NSMutableArray alloc] initWithCapacity:2];
        isBallAnimated = NO;
        self.layer.cornerRadius = frame.size.width/2.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = { 0.0, 1.0};
    
    UIColor * randomColor = ballColor;
    
    NSArray *colors = @[(id)[UIColor whiteColor].CGColor,
                        (id)randomColor.CGColor];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColors(colorspace,
                                          (CFArrayRef)colors, locations);
    
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    startPoint.x = self.frame.size.width/2-self.frame.size.width/8;
    startPoint.y = self.frame.size.height/2-self.frame.size.height/8;
    endPoint.x = self.frame.size.width/2;
    endPoint.y = self.frame.size.height/2;
    startRadius = 0;
    endRadius = self.frame.size.width/2;
    
    CGContextDrawRadialGradient (context, gradient, startPoint,
                                 startRadius, endPoint, endRadius,
                                 0);
}

-(void)animateBall
{
    isBallAnimated = YES;
    CGRect tmp = self.frame;
    [UIView animateWithDuration:0.3
                          delay:0.1f
                        options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.size.height/12 - self.frame.size.height/17 , self.frame.size.width, self.frame.size.height - self.frame.size.height/12);
                         
                         
                     }
                     completion:^(BOOL fin) {
                         [UIView animateWithDuration:0.5f animations:^{
                             self.frame = tmp;
                         }];

                     }];
    
    
    
}

-(void)stopBallAnimation
{
    isBallAnimated = NO;
    [self.layer removeAllAnimations];
}

-(void)changeBallColor:(UIColor *)newColor
{
    ballColor = newColor;
    
}

@end
