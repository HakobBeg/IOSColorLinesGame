//
//  GameEngine.h
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "Definitions.h"
#import "FieldView.h"
#import "BallView.h"
#import "Protocols.h"
@interface GameEngine : NSObject<FieldViewDelegate,GameBoardViewDelegate>

{
    FieldView * checkedBallField;
    int countOfFreeFields;
    BOOL isBallChecked;
    BOOL logicBoard[BoardSizeHeight][BoardSizeWidth];
    NSMutableArray<UIColor *> * colorsArray;
}

+(instancetype)sharedEngine;
-(NSMutableArray *)randomCoordinatesGenerator;
-(UIColor *)randomColorGenerator;
-(BOOL)isTheFreeFieldInCurrentRow:(int)row;
-(NSMutableArray *)findPathFrom:(NSMutableArray *)coordinate1 to:(NSMutableArray*)coordinate2;
-(void)cleanBallsIfLastStepIsVictorious:(NSMutableArray *)lastStepCoordinates;

@property(weak) id <GameEngineDelegate>delegate;

@end
