//
//  GameBoardView.h
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldView.h"
#import "BallView.h"
#import "Definitions.h"


@interface GameBoardView : UIView<GameEngineDelegate>

@property NSMutableArray<FieldView *> * boardFields;
@property NSMutableArray<BallView *> *fieldsBalls;
@property int countOfFreeFields;

-(void)animateBallInCurrentField:(FieldView *)field;
-(void)addBallToBoard;
-(void)changeBallPositionFromField:(FieldView *)startField to:(FieldView *)endField;
-(int)getIndexOfFieldByCoordinates:(NSMutableArray *)coordinates;
-(int)getIndexOfBallByCoordinates:(NSMutableArray *)coordinates;
-(FieldView *)findFieldWithCoordinates:(NSMutableArray *)coordinates;


@property(weak) id <GameBoardViewDelegate>delegate;
@end
