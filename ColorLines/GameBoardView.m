//
//  GameBoardView.m
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import "GameBoardView.h"

@implementation GameBoardView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        _countOfFreeFields = BoardSizeHeight * BoardSizeWidth;
        
        self.boardFields = [[NSMutableArray alloc] init];
        self.fieldsBalls = [[NSMutableArray alloc] init];
        
        int fieldPointX = (self.frame.size.width - (FieldSizeWidth + SpaceBetweenFields) * BoardSizeWidth)/2;
        int fieldPointY = (self.frame.size.height - (FieldSizeHeight + SpaceBetweenFields) * BoardSizeHeight)/2;
        
        for(int i=0,c=1;i<BoardSizeHeight * BoardSizeWidth;++i,++c)
        {
            FieldView * tmp = [[FieldView alloc] initWithFrame:CGRectMake(fieldPointX, fieldPointY, FieldSizeWidth, FieldSizeHeight)];
            [self.boardFields addObject:tmp];
            tmp = nil;
            if(c == BoardSizeWidth)
            {
                fieldPointX = (self.frame.size.width - (FieldSizeWidth + SpaceBetweenFields) * BoardSizeWidth)/2;
                fieldPointY += SpaceBetweenFields + FieldSizeHeight;
                c = 0;
            }
            else
                fieldPointX += SpaceBetweenFields + FieldSizeWidth;
        }
        
        for(int i = 0,fieldsArrayinedx = 0;i<BoardSizeHeight;++i)
        {
            for(int j = 0;j<BoardSizeWidth;++j)
            {
                NSMutableArray *coordTmp = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:i],[NSNumber numberWithInt:j],nil];
                self.boardFields[fieldsArrayinedx].fieldCoordinatesOnBoard =coordTmp;
                [self addSubview:self.boardFields[fieldsArrayinedx++]];
                coordTmp = nil;
            }
        }
        
    }
    
    return self;
}

-(void)animateBallInCurrentField:(FieldView *)field
{
    for(int i = 0;i < self.fieldsBalls.count;++i)
    {
        if([self.fieldsBalls[i].ballFieldCoordinates[0] intValue] == [field.fieldCoordinatesOnBoard[0] intValue] && [self.fieldsBalls[i].ballFieldCoordinates[1] intValue] == [field.fieldCoordinatesOnBoard[1] intValue])
        {
            [self.fieldsBalls[i] animateBall];
        }
        else if(self.fieldsBalls[i].isBallAnimated)
        {
            [self.fieldsBalls[i] stopBallAnimation];
        }
    }
}

-(void)didNeedsAnimation:(FieldView *)fieldView
{
    [self animateBallInCurrentField:fieldView];
}

-(void)addBallToBoard
{
    int countOfCreatedBalls = (_countOfFreeFields > CountOfNewBalls)?CountOfNewBalls:_countOfFreeFields;
    
    for(int i = 0;i<countOfCreatedBalls;++i){
            NSMutableArray * gottenCords = [self.delegate didNeedsRandomCoordinates];
            int index = [self getIndexOfFieldByCoordinates:gottenCords];
            BallView * newBall = [[BallView alloc] initWithFrame: CGRectMake(self.boardFields[index].frame.size.width/10, self.boardFields[index].frame.size.height/10,self.boardFields[index].frame.size.width - self.boardFields[index].frame.size.width/5, self.boardFields[index].frame.size.height - self.boardFields[index].frame.size.height/5)];
            [newBall changeBallColor:[self.delegate didNeedsRandomColor]];
            [self.boardFields[index] addSubview:newBall];
            self.boardFields[index].isThereABallOnField = YES;
            newBall.ballFieldCoordinates = gottenCords;
            [self.fieldsBalls addObject:newBall];
            newBall = nil;
        [self.delegate didAddBall:gottenCords];
            _countOfFreeFields--;
        
        }
}

-(int)getIndexOfFieldByCoordinates:(NSMutableArray *)searchCords
{
    for(int i = 0;i<self.boardFields.count;++i)
    {
        if([self.boardFields[i].fieldCoordinatesOnBoard[0] intValue] == [searchCords[0] intValue] && [self.boardFields[i].fieldCoordinatesOnBoard[1] intValue] == [searchCords[1] intValue])
            return i;
    }
    return -1;
}

-(void)didNeedsBalls
{
    [self addBallToBoard];
}

-(void)changeBallPositionFromField:(FieldView *)startField to:(FieldView *)endField
{
    int index = [self getIndexOfBallByCoordinates:startField.fieldCoordinatesOnBoard];
    BallView * ball = self.fieldsBalls[index];
    
    
    startField.isThereABallOnField = NO;
    for(BallView * sub in [startField subviews])
                [sub removeFromSuperview];

    [self.delegate didRemoveBall:startField.fieldCoordinatesOnBoard];

    
    ball.ballFieldCoordinates[0] = endField.fieldCoordinatesOnBoard[0];
    ball.ballFieldCoordinates[1] = endField.fieldCoordinatesOnBoard[1];
    endField.isThereABallOnField = YES;
    [self.delegate didAddBall:endField.fieldCoordinatesOnBoard];
    [ball stopBallAnimation];
    
    ball.alpha = 0.0;
    [endField addSubview:ball];
    [UIView animateWithDuration:0.7f animations:^{ball.alpha = 1.0;} completion:^(BOOL finished){}];
    


    
    
}

-(void)didChangeBallPositionFrom:(FieldView *)start to:(FieldView *)end
{
    [self changeBallPositionFromField:start to:end];

}

-(FieldView *)findFieldWithCoordinates:(NSMutableArray *)coordinates
{
    int index = [self getIndexOfFieldByCoordinates:coordinates];
    
    return self.boardFields[index];
}

-(FieldView *)didFindFieldWithCoordinates:(NSMutableArray *)coordinates
{
    int index = [self getIndexOfFieldByCoordinates:coordinates];
      return self.boardFields[index];
}

-(int)getIndexOfBallByCoordinates:(NSMutableArray *)coordinates
{
    for(int i = 0;i<self.fieldsBalls.count;++i)
        if([self.fieldsBalls[i].ballFieldCoordinates[0] intValue] == [coordinates[0] intValue] && [self.fieldsBalls[i].ballFieldCoordinates[1] intValue] == [coordinates[1] intValue])
            return i;
    return -1;
}

-(BallView *)didNeedsBallAtCoordinate:(NSMutableArray *)cord
{
    int index =[self getIndexOfBallByCoordinates:cord];
    return self.fieldsBalls[index];
}

-(void)didRemoveBallFromFieldBalls:(NSMutableArray *)coordinates
{
    
    for(int i = 0;i<_fieldsBalls.count;++i)
    {
        if([self.fieldsBalls[i].ballFieldCoordinates[0] intValue] == [coordinates[0] intValue] && [self.fieldsBalls[i].ballFieldCoordinates[1] intValue] == [coordinates[1] intValue]){
            self.boardFields[i].isThereABallOnField = NO;
            [UIView animateWithDuration:0.7f animations:^{self.fieldsBalls[i].alpha = 0.0;} completion:^(BOOL finished){[self.fieldsBalls[i] removeFromSuperview];}];
            [self.fieldsBalls removeObjectAtIndex:i];
            _countOfFreeFields++;
            break;
        }
    }

}




@end
