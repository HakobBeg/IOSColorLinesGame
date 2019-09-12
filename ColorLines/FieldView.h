//
//  FieldView.h
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "Protocols.h"

@interface FieldView : UIView

{
    UITapGestureRecognizer * tap;
}


-(IBAction)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender;


@property NSMutableArray * fieldCoordinatesOnBoard;
@property BOOL isThereABallOnField;


@property(weak)id <FieldViewDelegate>delegate;

@end
