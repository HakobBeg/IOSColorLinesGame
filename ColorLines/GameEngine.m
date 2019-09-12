//
//  GameEngine.m
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import "GameEngine.h"

static GameEngine * _sharedEngine = nil;

@implementation GameEngine

+(instancetype)sharedEngine
{
    if(_sharedEngine == nil)
        _sharedEngine = [[GameEngine alloc] init];
    
    return _sharedEngine;
}

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        countOfFreeFields = BoardSizeWidth * BoardSizeHeight;
        isBallChecked = NO;
        for(int i = 0;i<BoardSizeHeight;++i)
            for(int j = 0;j<BoardSizeWidth;++j)
                logicBoard[i][j] = NO;
        colorsArray = [[NSMutableArray alloc] init];
        countOfFreeFields = BoardSizeWidth * BoardSizeHeight;
        
        
        for(int i = 0;i<25;++i)
        {
            [colorsArray addObject:[self randomColorGenerator]];
        }

    }
    
    return self;
}

-(NSMutableArray *)randomCoordinatesGenerator
{

    
    int  i = arc4random()%(BoardSizeHeight), j = arc4random()%(BoardSizeWidth);
    
    while(![self isTheFreeFieldInCurrentRow:i])
    {
        i = arc4random()%(BoardSizeHeight);
    }
    while(logicBoard[i][j])
    {
        j = arc4random()%(BoardSizeWidth);
    }
    
    
    NSMutableArray * result = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:i],[NSNumber numberWithInt:j], nil];
    
    return result;
}

-(UIColor *)randomColorGenerator
{
    UIColor * color = [UIColor colorWithHue:drand48() saturation:1.0 brightness:0.8 alpha:1.0];
    return color;
    
}

-(BOOL)isTheFreeFieldInCurrentRow:(int)row
{
    for(int i = 0;i<BoardSizeWidth;++i)
        if(!logicBoard[row][i])
            return YES;
    return NO;
}


-(void)printLogicBoard{
    
    for(int i = 0;i<BoardSizeHeight;++i)
        NSLog(@"%i%i%i%i\n",logicBoard[i][0],logicBoard[i][1],logicBoard[i][2],logicBoard[i][3]);
    NSLog(@"\n");
}

-(void)didWorkGestureTapRecognizer:(FieldView *)fieldView
{
    
    
    if(countOfFreeFields == BoardSizeWidth * BoardSizeHeight)
        [self.delegate didNeedsBalls];
    
    if(!fieldView.isThereABallOnField && isBallChecked)
    {
     
       NSMutableArray * path = [self findPathFrom:checkedBallField.fieldCoordinatesOnBoard to:fieldView.fieldCoordinatesOnBoard];
        if(path == nil)
        {
            NSLog(@"cant jump on wall");
        }
        else
        {
            for(int i = (int)path.count-1;i>0;--i){
                [self.delegate didChangeBallPositionFrom:[self.delegate didFindFieldWithCoordinates:path[i]] to:[self.delegate didFindFieldWithCoordinates:path[i-1]]];
            }
            [self cleanBallsIfLastStepIsVictorious:path[0]];
            [self.delegate didNeedsBalls];
            isBallChecked = NO;
        }
    }
    else if(fieldView.isThereABallOnField){
        if([self.delegate respondsToSelector:@selector(didNeedsAnimation:)])
            [self.delegate didNeedsAnimation:fieldView];
        checkedBallField = fieldView;
        isBallChecked = YES;
    }
    
}

-(NSMutableArray *)didNeedsRandomCoordinates
{
    countOfFreeFields--;
    NSMutableArray * newCoords = [self randomCoordinatesGenerator];
    return newCoords;
}


-(UIColor *)didNeedsRandomColor
{
    return colorsArray[arc4random()%MaxColorsCount];
}

-(NSMutableArray *)findPathFrom:(NSMutableArray *)coordinate1 to:(NSMutableArray *)coordinate2
{
    int map[BoardSizeHeight][BoardSizeWidth];
    for(int i = 0;i<BoardSizeHeight;++i)
        for(int j = 0;j<BoardSizeWidth;++j)
        {
            if(logicBoard[i][j] == YES)
                map[i][j] = -1;
            else
                map[i][j] = -2;
        }
    
    int step = 0;
    map[[coordinate1[0] intValue]][[coordinate1[1] intValue]] = step;
    map[[coordinate2[0] intValue]][[coordinate2[1] intValue]] = -3;
    
    
    
    BOOL flag = false;
    while(step<BoardSizeWidth * BoardSizeHeight){
    
    for(int i = 0;i<BoardSizeHeight;++i)
    {
        for(int j = 0;j<BoardSizeWidth;++j)
        {
            if(i+1<BoardSizeHeight && map[i+1][j]!=-1 && !flag && map[i+1][j]!=step-1 && map[i][j]==step)
            {
                if(map[i+1][j] == -3)
                {
                    flag = true;
                    break;
                }
                map[i+1][j] = step+1;
            }
            if(i-1>=0 && map[i-1][j]!=-1 && !flag && map[i-1][j]!=step-1 && map[i][j]==step)
            {
                if(map[i-1][j] == -3)
                {
                    flag = true;
                    break;
                }
                map[i-1][j] = step+1;
            }
            if(j+1<BoardSizeWidth && map[i][j+1]!=-1 && !flag && map[i][j+1]!=step-1 && map[i][j]==step)
            {
                if(map[i][j+1] == -3)
                {
                    flag = true;
                    break;
                }
                map[i][j+1] = step+1;
            }
            
            if(j-1 >= 0 && map[i][j-1]!=-1 && !flag && map[i][j-1]!=step-1 && map[i][j]==step)
            {
                if(map[i][j-1] == -3)
                {
                    flag = true;
                    break;
                }
                map[i][j-1] = step+1;
            }
            if(flag)
                break;

                }
        if(flag)
            break;
        
    }
            ++step;
        if(flag)
            break;
    
    
    }
    if (!flag) {
        return nil;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    int posX = [coordinate2[0] intValue],posY = [coordinate2[1] intValue];
    
    [result addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:posX],[NSNumber numberWithInt:posY],nil]];
    
    while (step>0) {
        
        if(posX+1<BoardSizeHeight &&  map[posX+1][posY] == step - 1)
        {
            posX++;
            [result addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:posX],[NSNumber numberWithInt:posY],nil]];
        }
       else if(posX-1<BoardSizeHeight &&  map[posX-1][posY] == step - 1)
        {
            posX--;
            [result addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:posX],[NSNumber numberWithInt:posY],nil]];
        }
        else if(posY+1<BoardSizeHeight &&  map[posX][posY+1] == step - 1)
        {
            posY++;
            [result addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:posX],[NSNumber numberWithInt:posY],nil]];
        }
        else if(posY - 1<BoardSizeHeight &&  map[posX][posY-1] == step - 1)
        {
            posY--;
            [result addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:posX],[NSNumber numberWithInt:posY],nil]];
        }
        
        step--;
        
    }
    
    
    return result;

}


-(void)didAddBall:(NSMutableArray *)coordinates
{
    logicBoard[[coordinates[0] intValue]][[coordinates[1] intValue]] = YES;
    

}

-(void)didRemoveBall:(NSMutableArray *)coordinates
{
    logicBoard[[coordinates[0] intValue]][[coordinates[1] intValue]] = NO;
    
}


-(void)cleanBallsIfLastStepIsVictorious:(NSMutableArray *)lastStepCoordinates
{

    NSMutableArray * horDeletables = [[NSMutableArray alloc] init];
    NSMutableArray * vertDeletables = [[NSMutableArray alloc] init];;
    NSMutableArray * rightUpDeletables = [[NSMutableArray alloc] init];
    NSMutableArray * rightDownDeletables = [[NSMutableArray alloc] init];

        [horDeletables addObject:[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates]];
        [vertDeletables addObject:[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates]];
        [rightUpDeletables addObject:[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates]];
        [rightDownDeletables addObject:[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates]];
    
    int startX = [lastStepCoordinates[0] intValue]+1 ,startY = [lastStepCoordinates[1] intValue];
    
 //up
    
    while( startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES  && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [horDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startX++;
    }
    
//down
    startX = [lastStepCoordinates[0] intValue]-1;
    startY = [lastStepCoordinates[1] intValue];
    
    while(startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [horDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startX--;
    }
    
    startX = [lastStepCoordinates[0] intValue];
    startY = [lastStepCoordinates[1] intValue]+1;
//right
    while( startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [vertDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startY++;
    }
    
//left
    startX = [lastStepCoordinates[0] intValue];
    startY = [lastStepCoordinates[1] intValue]-1;
    
    while( startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [vertDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startY--;
    }
    
 //right up
    startX = [lastStepCoordinates[0] intValue]-1;
    startY = [lastStepCoordinates[1] intValue]+1;

    while( startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [rightUpDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startY++;
        startX--;
    }
    
    startX = [lastStepCoordinates[0] intValue]+1;
    startY = [lastStepCoordinates[1] intValue]-1;
    
    while( startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [rightUpDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startY--;
        startX++;
    }
    
//right down
    
    startX = [lastStepCoordinates[0] intValue]+1;
    startY = [lastStepCoordinates[1] intValue]+1;
    
    while( startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [rightDownDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startY++;
        startX++;
    }
    
    startX = [lastStepCoordinates[0] intValue]-1;
    startY = [lastStepCoordinates[1] intValue]-1;
    
    while(  startX>=0 && startX<BoardSizeHeight && startY>=0 && startY<BoardSizeWidth && [self.delegate didFindFieldWithCoordinates:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]].isThereABallOnField == YES && [[self.delegate didNeedsBallAtCoordinate:lastStepCoordinates] ballColor] == [[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]] ballColor])
    {
        [rightDownDeletables addObject:[self.delegate didNeedsBallAtCoordinate:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:startX],[NSNumber numberWithInt:startY], nil]]];
        startY--;
        startX--;
    }
    
    
    NSMutableArray * deletableBallsArray = [[NSMutableArray alloc] init];
    
    if([horDeletables count]>= MaxCountInSameLineInSameColor)
    {
        for(int i = 0;i<horDeletables.count;++i)
            [deletableBallsArray addObject:horDeletables[i]];
    }
    
    if([vertDeletables count]>= MaxCountInSameLineInSameColor)
    {
        for(int i = 0;i<vertDeletables.count;++i)
            [deletableBallsArray addObject:vertDeletables[i]];
    }

    if([rightUpDeletables count]>= MaxCountInSameLineInSameColor)
    {
        for(int i = 0;i<rightUpDeletables.count;++i)
            [deletableBallsArray addObject:rightUpDeletables[i]];
    }
    
    if([rightDownDeletables count]>= MaxCountInSameLineInSameColor)
    {
        for(int i = 0;i<rightDownDeletables.count;++i)
            [deletableBallsArray addObject:rightDownDeletables[i]];
    }
    
    
    
    if(deletableBallsArray.count>1){
    for(int i = 0;i<deletableBallsArray.count;++i)
    {
     //   [((BallView *)deletableBallsArray[i]) removeFromSuperview];
        
        //logicBoard[[((BallView *)deletableBallsArray[i]).ballFieldCoordinates[0] intValue]][[((BallView *)deletableBallsArray[i]).ballFieldCoordinates[1] intValue] ] = NO;
        
        [self.delegate didRemoveBallFromFieldBalls:((BallView *)deletableBallsArray[i]).ballFieldCoordinates];

    }

    countOfFreeFields+=deletableBallsArray.count;
    }
    
}


-(void)didSameColorInLine:(NSMutableArray *)coordinates
{
    [self cleanBallsIfLastStepIsVictorious:coordinates];
}

-(void)check:(NSMutableArray *)coordinate
{
    [self cleanBallsIfLastStepIsVictorious:coordinate];
}

@end
