//
//  SaveDataLoader.m
//  iCap
//
//  Created by 大畑貴史 on 2014/11/19.
//  Copyright (c) 2014年 大畑 貴史. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyScrollView.h"
#import "ViewController.h"
#import "SaveDataLoader.h"


@implementation SaveDataLoader : NSObject 

-(void)readViewData:(ViewController *)controller{
    NSString *fileName = @"Documents/ViewData";
    NSString *extention = @".dat";
    NSString *fileNum = [NSString stringWithFormat:@"%ld",(long)controller.view.tag];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@",fileName,fileNum,extention]];

    UIImage *img = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if(img){
        [controller.scroller getSubview].image = img;
    }
}


-(void)readSerialData:(ViewController *)controller{
    //serialData読み込み
    NSString *fileName = @"Documents/data";
    NSString *extention = @".dat";
    NSString *fileNum = [NSString stringWithFormat:@"%ld",(long)controller.view.tag];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@",fileName,fileNum,extention]];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    //    MusicImage *view = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (array) {
        for(int i=0; i<[array count];i++){
            MusicSaveData *loadData = [array objectAtIndex:i];
            MPMediaItem *item = (MPMediaItem *)[loadData.musicArray objectAtIndex:0];
            
            //ラベルの作成
            CGRect labelFrame = CGRectMake(0,loadData.bounds.size.height/2,loadData.bounds.size.width,loadData.bounds.size.height/2);
            UILabel *label = [controller makeLabel:labelFrame withString:[item valueForProperty:MPMediaItemPropertyTitle]];
            
            //アルバムラベルの作成
            CGRect albumLabelFrame = CGRectMake(0,0,loadData.bounds.size.width,loadData.bounds.size.height/2);
            UILabel *albumLabel = [controller makeLabel:albumLabelFrame withString:loadData.albumName];
            albumLabel.tag = controller.imageTag + ALBUMLABEL;
            
            
            //アートワークからImage作成
            MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
            
            MusicImage *musicImage = [[MusicImage alloc] initWithImage:[artwork imageWithSize:CGSizeMake(DEFAULTSIZE,DEFAULTSIZE)]];
            if(musicImage.image == nil)
                musicImage.image = [UIImage imageNamed:@"albumDefault.jpg"];
            
            musicImage.tag = controller.imageTag;
            //queryの追加
            [musicImage addMusic:loadData.musicArray];
            //frameの設定
            musicImage.frame = loadData.bounds;
            //ラベルの貼り付け
            [musicImage addSubview:label];
            [musicImage addSubview:albumLabel];
            musicImage.albumName = albumLabel.text;
            [musicImage serializer];
            [controller.scroller addMusicImage:musicImage];
            controller.imageTag +=DELETER+1;
        }
    } else {
        NSLog(@"%@", @"データが存在しません。");
    }
}


@end

