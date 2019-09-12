//
//  FieldView.m
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import "FieldView.h"

@implementation FieldView

@synthesize isThereABallOnField = isThereABallOnField;
@synthesize fieldCoordinatesOnBoard = fieldCoordinatesOnBoard;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        fieldCoordinatesOnBoard = [[NSMutableArray alloc] init];
        isThereABallOnField = NO;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = FieldColor;
        self.layer.borderWidth = FieldSizeWidth/25;
        self.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:0.5].CGColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        self.layer.shadowOpacity = 1;
    }
    
    return self;
    
}


-(IBAction)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender
{
    if([self.delegate respondsToSelector:@selector(didWorkGestureTapRecognizer:)])
        [self.delegate didWorkGestureTapRecognizer:self];
}



@end
