//
//  SaveDataSerializer.m
//  iCap
//
//  Created by 大畑貴史 on 2014/11/19.
//  Copyright (c) 2014年 大畑 貴史. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "SaveDataSerializer.h"

@implementation SaveDataSerializer

-(void)serializeViewData:(ViewController *)controller{
    NSString *fileName = @"Documents/ViewData";
    NSString *extention = @".dat";
    NSString *fileNum = [NSString stringWithFormat:@"%ld",(long)controller.view.tag];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@",fileName,fileNum,extention]];
    NSLog(@"save file path:%@",filePath);
    BOOL successful;
    
    successful = [NSKeyedArchiver archiveRootObject:[controller.scroller getSubview].image  toFile:filePath];
}

@end
