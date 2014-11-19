//
//  ViewController.h
//  MyMusicLibrary
//
//  Created by Ohata Takashi on 2013/05/22.
//  Copyright (c) 2013年 Ohata Takashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <GameKit/GameKit.h>
#import "APPDelegate.h"
#import "MyScrollView.h"
#import "CommonLibrary.h"

#define OPENLIBRARYSOUNDNUM 1100//iphoneシステムサウンドの番号
#define CLOSELIBRARYSOUNDNUM 1101

@interface ViewController : UIViewController<GKPeerPickerControllerDelegate, GKSessionDelegate, MPMediaPickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSCoding,MyScrollViewDelegate>{
    
    GKSession* session_;
    NSString* peearID_;
    
}



@property (nonatomic,strong)MyScrollView *scroller;
@property (nonatomic,strong)ViewController *prevController;
@property (nonatomic,strong)NSMutableArray *albumMusicArray;
@property  int imageTag;

@property (nonatomic, retain) GKSession* session;
@property (nonatomic, retain) NSString* peerID;

- (IBAction)connect:(id)sender;

-(UILabel *)makeLabel:(CGRect)labelFrame withString:(NSString *)text;
-(void)readSaveData;
-(void)addMusicImage:(NSMutableArray *)array;
-(void)setCanvasViewControllerNumber:(int)number;
-(void)updateImageTag;
-(BOOL)checkDeleter;
-(BOOL)deleteSelectFrame;
-(void)updateTag;
-(int)getImageTag;


@end
