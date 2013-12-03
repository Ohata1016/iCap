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


// デリゲートの設定 Done 押下時に呼ばれます。
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection
{
    // 選択されたメディアは 配列で格納されている。
    [self makeImage:mediaPicker didPickMediaItems:collection];
    [super.getViewController dismissViewControllerAnimated:YES completion:NULL];
    AudioServicesPlaySystemSound(CLOSELIBRARYSOUNDNUM);//iphoneシステムサウンド
}

- (void)makeImage:(MPMediaPickerController *) mediaPicker
didPickMediaItems: (MPMediaItemCollection *) collection
{//アルバム、または楽曲イメージを作成する
    CGRect imageFrame = CGRectMake(0,0,DEFAULTSIZE,DEFAULTSIZE);
    CGRect labelFrame = CGRectMake(0,0,DEFAULTSIZE,DEFAULTSIZE);

        for (MPMediaItem *item in collection.items) {
            
            int extent = [[item valueForProperty:MPMediaItemPropertyPlayCount] integerValue];
            imageFrame = CGRectMake(imageFrame.origin.x,imageFrame.origin.y,DEFAULTSIZE + +extent/10,DEFAULTSIZE + +extent/10);
            labelFrame = CGRectMake(0,0,DEFAULTSIZE + +extent/10,DEFAULTSIZE + +extent/10);
            
            //ラベルの作成
            UILabel *label = [self makeLabel:labelFrame withString:[item valueForProperty:MPMediaItemPropertyTitle]];
            
            //アートワークからImage作成
            MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
            
            NSMutableArray *musicArray = [[NSMutableArray alloc] initWithCapacity:1];
            [musicArray addObject:item];
            
            MusicImage *musicImage = [[MusicImage alloc] initWithImage:[artwork imageWithSize:CGSizeMake(DEFAULTSIZE,DEFAULTSIZE)]];
            musicImage.tag = super.getViewController.imageTag;
            [super.getViewController updateTag];
            
            //queryの追加
            [musicImage addMusic:musicArray];
            
            if(musicImage.image == nil)
                musicImage.image = [UIImage imageNamed:@"albumDefault.jpg"];
            
            musicImage.frame = imageFrame;
            
            [musicImage addSubview:label];
            [super.getViewController.scroller addMusicImage:musicImage];
            
            imageFrame.origin.x+=5;
            imageFrame.origin.y+=5;//初期設置位置の更新
            if(imageFrame.origin.y>=MAXHEIGHT){
                imageFrame.origin.y = MAXHEIGHT;
                imageFrame.origin.x = MAXHEIGHT;
            }
    }
    [[[[accsesser superview] superview] viewWithTag:1] removeFromSuperview];
}


-(void)displayAlertview{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"アルバムを作成します"
                                                        message:@" "
                                                       delegate:self
                                              cancelButtonTitle:@"cancel"
                                              otherButtonTitles:@"OK", nil];
    UITextField *textField;
    // UITextFieldの生成
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    // textField.textAlignment = UITextAlignmentLeft;
    textField.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    textField.textColor = [UIColor grayColor];
    textField.minimumFontSize = 8;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setDelegate:super.getViewController];
    // アラートビューにテキストフィールドを埋め込む
    [alertView addSubview:textField];
    
    // アラート表示
    [alertView show];
    
    // テキストフィールドをファーストレスポンダに
    [textField becomeFirstResponder];
}

-(UILabel *)makeLabel:(CGRect)labelFrame withString:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.tag = super.getViewController.getImageTag + SONGLABEL;
    label.numberOfLines = 2;
    label.contentMode = UIViewContentModeScaleToFill;
    
    return label;
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [super.getViewController dismissViewControllerAnimated:YES completion:NULL];
    AudioServicesPlaySystemSound(CLOSELIBRARYSOUNDNUM);//iphoneシステムサウンド
}



@end
