//
//  IcImageView.h
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/01.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "ViewController.h"

@interface IcImageView : UIImageView<GKPeerPickerControllerDelegate, GKSessionDelegate>{
    
    ViewController *vc;
}

@property (nonatomic,strong)ViewController *vc;

@end
