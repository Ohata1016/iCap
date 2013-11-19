//
//  MusicLibraryAccesser.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/19.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "MusicLibraryAccesser.h"
#import "MusicLibraryAccessHundler.h"


@implementation MusicLibraryAccesser
{
    MusicLibraryAccessHundler *accsesser;
}

-(void) callLibrary:(NSObject*)caller{
    accsesser = (MusicLibraryAccessHundler *)caller;
    //[self startCameraPickerFromViewController:super.getViewController usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    NSLog(@"singletap gesture called");

        //imageTagの更新
        [super.getViewController updateImageTag];
        
        if([super.getViewController checkDeleter]){
            for(int i = STARTMUSICTAGNUMBER; i < super.getViewController.imageTag;i = i+DELETER+1){
                NSLog(@"remove deleter:%@",[[super.getViewController.scroller getSubview] viewWithTag:i+DELETER]);
                [[[super.getViewController.scroller getSubview] viewWithTag:i+DELETER] removeFromSuperview];
            }
        }else if([super.getViewController deleteSelectFrame]){
            super.getViewController.scroller.delaysContentTouches = YES;
            return;
        }else{
            AudioServicesPlaySystemSound(OPENLIBRARYSOUNDNUM);//iphoneシステムサウンド
            // initWithMediaTypes の引数は下記を参照に利用したいメディアを設定
            MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
            // デリゲートを自分クラスに設定
            picker.delegate = super.getViewController;
            // 複数のメディアを選択可能に設定
            [picker setAllowsPickingMultipleItems: YES];
            
            // プロンプトに表示する文言を設定
            picker.prompt = NSLocalizedString (@"Add songs to play","Prompt in media item picker");
            
            // ViewController へピッカーを設定
            [super.getViewController presentViewController:picker animated:YES completion:^{
            }];
        }
}

@end
