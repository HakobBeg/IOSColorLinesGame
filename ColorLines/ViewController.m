//
//  ViewController.m
//  ColorLines
//
//  Created by Jarvis on 7/17/17.
//  Copyright © 2017 joomag. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import "Definitions.h"
#import "GameEngine.h"
#import "FieldView.h"
#import "GameBoardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    GameEngine * engine = [GameEngine sharedEngine];
    GameBoardView * tmp = [[GameBoardView alloc] initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, ScreenSizeHeight)];
    for(int i = 0;i<BoardSizeWidth * BoardSizeHeight;++i)
        tmp.boardFields[i].delegate = engine;
    tmp.delegate = engine;
    engine.delegate = tmp;
    [self.view addSubview:tmp];



}




@end
