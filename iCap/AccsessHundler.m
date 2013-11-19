//
//  Accesser.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/19.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "AccsessHundler.h"

@implementation AccsessHundler
{
    ViewController *cnt;
}


-(void)addSingleFingerTapGesture{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSingleTap:)];
    [self addGestureRecognizer:singleTap];
}


-(void)setViewController:(ViewController *)controller{
    cnt = controller;
}

-(ViewController *)getViewController{
    return cnt;
}

-(void)actionSingleFingerTap:(UIGestureRecognizer *)sender{
    
}
@end
