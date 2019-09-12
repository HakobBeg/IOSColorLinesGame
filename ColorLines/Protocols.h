//
//  Protocols.h
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Protocols_h
#define Protocols_h
@class FieldView;
@class BallView;

@protocol FieldViewDelegate <NSObject>

-(void)didWorkGestureTapRecognizer:(FieldView *)fieldView;

@end

@protocol GameEngineDelegate <NSObject>

-(void)didNeedsAnimation:(FieldView *)fieldView;
-(void)didNeedsBalls;
-(void)didChangeBallPositionFrom:(FieldView *)start to:(FieldView *)end;
-(FieldView *)didFindFieldWithCoordinates:(NSMutableArray *)coordinates;
-(BallView *)didNeedsBallAtCoordinate:(NSMutableArray *)cord;
-(void)didRemoveBallFromFieldBalls:(NSMutableArray *)coordinates;

@end

@protocol GameBoardViewDelegate <NSObject>

-(NSMutableArray *)didNeedsRandomCoordinates;
-(UIColor *)didNeedsRandomColor;
-(void)didAddBall:(NSMutableArray *)coordinates;
-(void)didRemoveBall:(NSMutableArray *)coordinates;
-(void)didSameColorInLine:(NSMutableArray *)coordinates;
-(void)check:(NSMutableArray *)coordinate;


@end

#endif /* Protocols_h */
