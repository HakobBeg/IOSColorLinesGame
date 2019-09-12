//
//  BallView.h
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface BallView : UIView


@property NSMutableArray * ballFieldCoordinates;
@property(readonly) BOOL isBallAnimated;
@property(readonly) UIColor * ballColor; 

-(void)animateBall;
-(void)stopBallAnimation;
-(void)changeBallColor:(UIColor *)newColor;




@end
