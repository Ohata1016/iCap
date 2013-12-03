//
//  iObject.h
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/12.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface iObject : UIImageView
@property (nonatomic,strong)ViewController *vc;
-(void)handleSingleTap:(UIGestureRecognizer *)sender;
-(void)handleSingleDoubleTap:(UITapGestureRecognizer *)sender;
@end
