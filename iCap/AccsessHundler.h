//
//  Accesser.h
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/19.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AccsessHundler : UIImageView
-(void)setViewController:(ViewController *)controller;
-(void)addSingleFingerTapGesture;
-(void)actionSingleFingerTap:(UIGestureRecognizer *)sender;
-(ViewController *)getViewController;
    @end
