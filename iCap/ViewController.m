//
//  ViewController.m
//  MyMusicLibrary
//
//  Created by Ohata Takashi on 2013/05/22.
//  Copyright (c) 2013年 Ohata Takashi. All rights reserved.
//

#import "ViewController.h"
#import "MusicImage.h"
#import "MusicSaveData.h"
#import "SuperView.h"
#import "EffectSoundBox.h"

#import "PhotoLibraryAccesser.h"
#import "iImageObject.h"
#import "SaveDataLoader.h"
#import "SaveDataSerializer.h"

#import "PhotoLibraryAccessHundler.h"
#import "MusicLibraryAccessHundler.h"


@implementation ViewController
{
    
    UISwipeGestureRecognizer *rightSwipeGesture;
    UISwipeGestureRecognizer *leftSwipeGesture;
    UITapGestureRecognizer *singleFingerTap;
    UITapGestureRecognizer *doubleFingerTap;
    UITapGestureRecognizer *singleFingerDoubleTap;
    BOOL makeAlbum;
    
    AppDelegate *appDelegate;
    
    EffectSoundBox *effectSoundBox;
    SuperView *scrollerView;
    
    NSMutableArray *albumViewControllerList;//アルバムのviewcontrollerをリスト管理する
    
    int canvasViewControllerNumber;//viewControllerの個体識別番号
    
}

@synthesize session = session_;
@synthesize peerID = peerID_;


- (void)viewDidLoad
{
    
    [super viewDidLoad];

    self.imageTag = STARTMUSICTAGNUMBER;
    
    self.scroller = [[MyScrollView alloc] initWithFrame:CGRectMake(0,0,MAXWIDTH,MAXHEIGHT)];
    [self.view addSubview:self.scroller];
    
    //addGestures
    //[self addSingleFingerDoubleTapGesture];
    [self addSingleFingerTapGesture];
    [self addDoubleFingerTaoGesture];
    [self addLeftSwipeGesture];
    [self addRightSwipeGesture];
//    [self addRotationGesture];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    effectSoundBox = [[EffectSoundBox alloc] init];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if(self.albumMusicArray){
        [self addMusicImage:self.albumMusicArray];
    }
    
    
///    [self.view addSubview:[_scroller getSubview]];
    _scroller.delegate = self;

    self.view = self.scroller;
    
    // Bluetooth btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(50, 50, 100, 30);
    [btn setTitle:@"connect" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchDown];
    [self.scroller.getSubview addSubview:btn];
}

// 接続先の検索
- (IBAction)connect:(id)sender
{
    NSLog(@"call connect");
    GKPeerPickerController* picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
}

// 接続先の指定
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    self.peerID = peerID;
    self.session = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    //[picker autorelease];
}

// 受信
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    NSLog(@"received image");
    UIImage *reImg = [UIImage imageWithData:data];
//    IcImageView *icImg = [[IcImageView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
  //  icImg.image = reImg;
 //   [self.scroller.getSubview addSubview:icImg];
}


-(void)setCanvasViewControllerNumber:(int)number{
    canvasViewControllerNumber = number;
}

- (SuperView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [_scroller getSubview];;
}

//一本指ジェスチャの追加
-(void)addSingleFingerTapGesture{
    singleFingerTap = [[UITapGestureRecognizer alloc]
                       initWithTarget:self  action:@selector(singleTapAction:)];
    [self.scroller addGestureRecognizer:singleFingerTap];
//    [singleFingerTap requireGestureRecognizerToFail:singleFingerDoubleTap];//ダブルタップが呼ばれないことを確認する
}

//一本指ダブルタップs
-(void)addSingleFingerDoubleTapGesture{
    singleFingerDoubleTap = [[UITapGestureRecognizer alloc]
                             initWithTarget:self  action:@selector(handleSingleDoubleTap:)];
    singleFingerDoubleTap.numberOfTapsRequired = 2;
  //  [self.scroller addGestureRecognizer:singleFingerDoubleTap];
}

-(void)addDoubleFingerTaoGesture{
    doubleFingerTap = [[UITapGestureRecognizer alloc]
                       initWithTarget:self  action:@selector(handleDoubleTap:)];
    doubleFingerTap.numberOfTouchesRequired = 2;
    
    [self.scroller addGestureRecognizer:doubleFingerTap];
}

-(void)addRightSwipeGesture{
    
    rightSwipeGesture = [[UISwipeGestureRecognizer alloc]
                         initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipeGesture.numberOfTouchesRequired = 2;
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.scroller addGestureRecognizer:rightSwipeGesture];
    
}

-(void)addLeftSwipeGesture{
    leftSwipeGesture = [[UISwipeGestureRecognizer alloc]
                        initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipeGesture.numberOfTouchesRequired = 2;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;

    [self.scroller addGestureRecognizer:leftSwipeGesture];
}

-(void)addRotationGesture{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:
                                                    self action:@selector(selRotationGesture:)];
    
    [rotationGesture requireGestureRecognizerToFail:rightSwipeGesture];
    [rotationGesture requireGestureRecognizerToFail:leftSwipeGesture];
    [self.scroller addGestureRecognizer:rotationGesture];
}

-(void)readSaveData{
    //保存していたデータを読み込む
    NSLog(@"read save data");
    SaveDataLoader *loader = [[SaveDataLoader alloc] init];
    
    
    [loader readViewData:self];//壁紙情報を読み込む そのままスクローラに貼り付け
    [loader readSerialData:self];//楽曲情報を読み込み　そのまま貼り付け
}


// ローテイトされた時に実行されるメソッド、selectorで指定します。
-(void) selRotationGesture:(UIRotationGestureRecognizer*) sender {
    UIRotationGestureRecognizer* selRotationGesture = (UIRotationGestureRecognizer*) sender;
    // 回転率 右回転の場合は +値 左回転の場合は -値
    NSLog(@"rotate:%f", selRotationGesture.rotation);
    //アフィン変換でスクローラを回転
    self.scroller.transform = CGAffineTransformMakeRotation(selRotationGesture.rotation);
    
}

-(void)handleSingleDoubleTap:(UIGestureRecognizer *)sender{    //アルバム作成　Musicライブラリにアクセスし、選択楽曲をスクローラに貼り付ける
    makeAlbum = YES;
    if(sender.state  == UIGestureRecognizerStateEnded){
        //imageTagの更新
        [self updateImageTag];
        //Dleterが出ていたら消す
        if([self checkDeleter]){
            for(int i = STARTMUSICTAGNUMBER; i < self.imageTag;i = i+DELETER+1){
                NSLog(@"remove deleter:%@",[[self.scroller getSubview] viewWithTag:i+DELETER]);
                [[[self.scroller getSubview] viewWithTag:i+DELETER] removeFromSuperview];
            }
        }else if([self deleteSelectFrame]){//SelectionFrame があったら消す
            self.scroller.delaysContentTouches = YES;
            return;
        }else{
            AudioServicesPlaySystemSound(OPENLIBRARYSOUNDNUM);//iphoneシステムサウンド
            // initWithMediaTypes の引数は下記を参照に利用したいメディアを設定しましょう。
            MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
            // デリゲートを自分クラスに設定
            picker.delegate = self;
            // 複数のメディアを選択可能に設定
            [picker setAllowsPickingMultipleItems: YES];
            
            // プロンプトに表示する文言を設定
            picker.prompt = NSLocalizedString (@"Add songs to play","Prompt in media item picker");
            // ViewController へピッカーを設定
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
    }
}


-(void)leftSwipeAction:(UIGestureRecognizer *)sender{//左にスワイプしたときの処理　ViewControllerを切り替え、別のスクローラを表示する
    NSLog(@"left swipe gesture called");
    if(self.prevController == nil){
        if(self.view.tag < [appDelegate.canvasViewControllerList count]){//ViewControllerを変更する
            ViewController *cnt= (ViewController *)[appDelegate.canvasViewControllerList objectAtIndex:self.view.tag];
            [appDelegate.window bringSubviewToFront:cnt.view];//別のコントローラの持つビューを全面へ持ってくる　つまり変更
            
            [self.view.window sendSubviewToBack:self.view];//自身を後ろへ
            appDelegate.window.rootViewController = cnt;//ビューコントローラの変更
        }else{
            //新しくcontrollerを作成
            [appDelegate addController];
            NSLog(@"change view controller tag:%@",[appDelegate.window viewWithTag:self.view.tag+1]);
        }
    }else{
        [appDelegate.window bringSubviewToFront:self.prevController.view];
        NSLog(@"change view controller tag:%@",self.prevController.view);
        [self.view.window sendSubviewToBack:self.prevController.view];
        appDelegate.window.rootViewController = self.prevController;
        [effectSoundBox playDeleteSound];
    }
}

-(void)rightSwipeAction:(UIGestureRecognizer *)sender{
    //フロントに持ってくるviewを指定　self.tag -1
    NSLog(@"right Swipe gesture called");
    if(self.view.tag>1){
        ViewController *cnt= (ViewController *)[appDelegate.canvasViewControllerList objectAtIndex:self.view.tag-2];
        [appDelegate.window bringSubviewToFront:cnt.view];
        NSLog(@"change view controller tag:%@",cnt.view);
        [self.view.window sendSubviewToBack:self.view];
        appDelegate.window.rootViewController = cnt;
    }else{
        NSLog(@"cant swipe right");
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    NSLog(@"singletap gesture called");
    makeAlbum = NO;
    if(sender.state  == UIGestureRecognizerStateEnded){
        //imageTagの更新
        [self updateImageTag];
            
        if([self checkDeleter]){
            for(int i = STARTMUSICTAGNUMBER; i < self.imageTag;i = i+DELETER+1){
                NSLog(@"remove deleter:%@",[[self.scroller getSubview] viewWithTag:i+DELETER]);
                [[[self.scroller getSubview] viewWithTag:i+DELETER] removeFromSuperview];
            }
        }else if([self deleteSelectFrame]){
            self.scroller.delaysContentTouches = YES;
            return;
        }else{
        AudioServicesPlaySystemSound(OPENLIBRARYSOUNDNUM);//iphoneシステムサウンド　
        // initWithMediaTypes の引数は下記を参照に利用したいメディアを設定
        MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
        // デリゲートを自分クラスに設定
        picker.delegate = self;
        // 複数のメディアを選択可能に設定
        [picker setAllowsPickingMultipleItems: YES];
        
        // プロンプトに表示する文言を設定
        picker.prompt = NSLocalizedString (@"Add songs to play","Prompt in media item picker");
        
        // ViewController へピッカーを設定
        [self presentViewController:picker animated:YES completion:^{
        }];
        }
    }
}

-(void)singleTapAction:(UIGestureRecognizer *)sender{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
    
    if([self.scroller.getSubview viewWithTag:1] ==nil){
        //大本のimageを追加する
        UIImageView *img = [[UIImageView alloc] init];
        CGPoint p = [sender locationInView:scrollerView];
        img.frame = CGRectMake(p.x, p.y, 100, 100);
        img.userInteractionEnabled = YES;
        img.tag = 1;
        
        //ライブラリアクセス用のアイコン追加
        AccsessHundler *accesser = [[PhotoLibraryAccessHundler alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        accesser.alpha = 1.0f;
        [accesser setViewController:self];
        
        //ミュージックライブラリアクセス用のアイコン追加
        AccsessHundler *musicAccesser = [[MusicLibraryAccessHundler alloc] initWithFrame:CGRectMake(0, 20, 20, 20)];
        [musicAccesser setViewController:self];
        musicAccesser.alpha = 1.0f;
        
        //scrollerに追加
        [img addSubview:accesser];
        [img addSubview:musicAccesser];
        [self.scroller.getSubview addSubview:img];
    }else{
        [[self.scroller.getSubview viewWithTag:1] removeFromSuperview];
    }
}

-(void)handleDoubleTap:(UIGestureRecognizer *)sender{//ダブルタップ時の処理　フォトアルバムへアクセス　壁紙を設定
    NSLog(@"double finger tap called");
    AudioServicesPlaySystemSound(OPENLIBRARYSOUNDNUM);//iphoneシステムサウンド　
    if(sender.state == UIGestureRecognizerStateEnded){
        [self startCameraPickerFromViewController:self usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        //sorcetype:フォトアルバム
    }
}
-(BOOL) startCameraPickerFromViewController:(UIViewController*)i_controller
                              usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)i_delegate
                                 sourceType:(UIImagePickerControllerSourceType)i_type
{
    if( ![UIImagePickerController isSourceTypeAvailable:i_type]
       || (i_delegate == nil)
       || (i_controller == nil ) ){
        return NO;
    }
    
    UIImagePickerController* a_picker = [[UIImagePickerController alloc] init];
    a_picker.sourceType = i_type;
    a_picker.delegate = i_delegate;
    a_picker.allowsEditing = NO;
    
    // ピッカーは非同期に表示される
    [i_controller presentViewController: a_picker animated:YES completion: ^{
    }];
    
    return YES;
}

/// 画像が選択されたときに呼ばれるデリゲート関数
- (void) imagePickerController:(UIImagePickerController*)i_picker
         didFinishPickingImage:(UIImage*)i_image
                   editingInfo:(NSDictionary*)i_editing_info
{
    
    [self useImage:i_image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    AudioServicesPlaySystemSound(OPENLIBRARYSOUNDNUM);//iphoneシステムサウンド　
}

/// 画像の選択がキャンセルされたときに呼ばれるデリゲート関数
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)i_picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"canceled");
        AudioServicesPlaySystemSound(CLOSELIBRARYSOUNDNUM);//iphoneシステムサウンド
    }];
    
}

- (void) navigationController:(UINavigationController*)i_navigation_controller
        didShowViewController:(UIViewController*)i_view_controller
                     animated:(BOOL)i_animated
{
}

- (void)useImage:(UIImage*)i_image
{
    SuperView *view = [_scroller getSubview];
    SaveDataSerializer *serializer = [[SaveDataSerializer alloc] init];
    
    view.image = i_image;
    
    [serializer serializeViewData:self];
    
}

-(BOOL)checkDeleter{
    for(int i = STARTMUSICTAGNUMBER;i<self.imageTag;i=i+DELETER+1){
        if([[self.scroller getSubview] viewWithTag:i+DELETER] != nil)
            return YES;
    }
    return NO;
}
-(BOOL)deleteSelectFrame{
    BOOL deleted = NO;
    SuperView *view = [_scroller getSubview];
    if([view getHaveRedFrame]!=0){
        [[view  viewWithTag:[view getHaveRedFrame]] removeFromSuperview];
        [view updateHaveRedFrame:0];
        deleted = YES;
    }
    return deleted;
}

-(void)updateImageTag{
    if([[self.scroller getSubview] viewWithTag:STARTMUSICTAGNUMBER] == nil){
        self.imageTag = STARTMUSICTAGNUMBER;//初期化
        return;
    }
    for(int i = STARTMUSICTAGNUMBER;[[self.scroller getSubview] viewWithTag:i]!=nil;i=i+DELETER+1){
        self.imageTag = i;
    }
    self.imageTag = self.imageTag +DELETER+1;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion &&
        motion == UIEventSubtypeMotionShake ) {
        int i;
        for(i = STARTMUSICTAGNUMBER; [self.scroller viewWithTag:i] != nil;i += (DELETER + 1 )){
            if([self.scroller viewWithTag:i+PLAYINGFRAME]!= nil){
                break;
            }
        }//playingを特定
        //そのmusicimageの再生アイテムをシャッフルする関数を呼ぶ
        MusicImage *img = (MusicImage *)[self.scroller viewWithTag:i];
        [img shuffleMusic];
        }
}


// デリゲートの設定 Done 押下時に呼ばれます。
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection
{
    // 選択されたメディアは 配列で格納されている。
    [self makeImage:mediaPicker didPickMediaItems:collection];
    [self dismissViewControllerAnimated:YES completion:NULL];
    AudioServicesPlaySystemSound(CLOSELIBRARYSOUNDNUM);//iphoneシステムサウンド
}

- (void)makeImage:(MPMediaPickerController *) mediaPicker
didPickMediaItems: (MPMediaItemCollection *) collection
{//アルバム、または楽曲イメージを作成する
    NSLog(@"Done pressed");
    CGRect imageFrame = CGRectMake(0,0,DEFAULTSIZE,DEFAULTSIZE);
    CGRect labelFrame = CGRectMake(0,0,DEFAULTSIZE,DEFAULTSIZE);
    
    if(makeAlbum){
        //アラートビュー表示
        //label作成
        
        [self displayAlertview];
        
        NSMutableArray *musicArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (MPMediaItem *item in collection.items) {
            [musicArray addObject:item];   
        }
        
        MusicImage *musicImage = [[MusicImage alloc] initWithImage:[UIImage imageNamed:@"albumDefault.jpg"]];
        [musicImage addMusic:musicArray];
        musicImage.frame = imageFrame;
        
        [musicImage makeAlbumController];
        [self.scroller addMusicImage:musicImage];
    }else{
        for (MPMediaItem *item in collection.items) {
            
            long extent = [[item valueForProperty:MPMediaItemPropertyPlayCount] integerValue];
            imageFrame = CGRectMake(imageFrame.origin.x,imageFrame.origin.y,DEFAULTSIZE + +extent/10,DEFAULTSIZE + +extent/10);
            labelFrame = CGRectMake(0,0,DEFAULTSIZE + +extent/10,DEFAULTSIZE + +extent/10);
            
            //ラベルの作成
            UILabel *label = [self makeLabel:labelFrame withString:[item valueForProperty:MPMediaItemPropertyTitle]];
            
            //アートワークからImage作成
            MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
            
            NSMutableArray *musicArray = [[NSMutableArray alloc] initWithCapacity:1];
            [musicArray addObject:item];
            
            MusicImage *musicImage = [[MusicImage alloc] initWithImage:[artwork imageWithSize:CGSizeMake(DEFAULTSIZE,DEFAULTSIZE)]];
            musicImage.tag = self.imageTag;
            [self updateTag];
            
            //queryの追加
            [musicImage addMusic:musicArray];
            
            if(musicImage.image == nil)
                musicImage.image = [UIImage imageNamed:@"albumDefault.jpg"];
            
            musicImage.frame = imageFrame;
            
            [musicImage addSubview:label];
            [self.scroller addMusicImage:musicImage];
            
            imageFrame.origin.x+=5;
            imageFrame.origin.y+=5;//初期設置位置の更新
            if(imageFrame.origin.y>=MAXHEIGHT){
                imageFrame.origin.y = MAXHEIGHT;
                imageFrame.origin.x = MAXHEIGHT;
            }
        }
        
    }
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
    [textField setDelegate:self];
    // アラートビューにテキストフィールドを埋め込む
    [alertView addSubview:textField];
    
    // アラート表示
    [alertView show];
    
    // テキストフィールドをファーストレスポンダに
    [textField becomeFirstResponder];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {//アルバム作成時のためのアラートビューの表示　作成中　　
    // OKが選択された場合
    UITextField *textField;
    if (buttonIndex == 1) {
        // テキストフィールドに一文字以上入力されていれば
        if ([textField.text length]){//アルバム作成時の処理
            NSLog(@"albumlabel:%@",textField.text);
        }else{
            return;
        }
        textField.text = nil;//textFieldに値が入ったままになってしまうので、初期化
    }
}

-(void)updateTag{
    self.imageTag = self.imageTag + DELETER + 1;//tag の更新
}

- (void)printSubviews:(UIView*)uiView addNSString:(NSString *)str
{
    NSLog(@"%@ %@", str, uiView);
    
    for (UIView* nextView in [uiView subviews])
    {
        [self printSubviews:nextView
                addNSString:[NSString stringWithFormat:@"%@==> ", str]];
    }
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    AudioServicesPlaySystemSound(CLOSELIBRARYSOUNDNUM);//iphoneシステムサウンド
}


-(UILabel *)makeLabel:(CGRect)labelFrame withString:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.tag = self.imageTag + SONGLABEL;
    label.numberOfLines = 2;
    label.contentMode = UIViewContentModeScaleToFill;
    
    return label;
}



-(void)addMusicImage:(NSMutableArray *)array{
    NSLog(@"add music images to ViewController");
    NSLog(@"array:%@",array);
    CGRect imageFrame = CGRectMake(0,0,DEFAULTSIZE,DEFAULTSIZE);
    CGRect labelFrame = CGRectMake(0,0,DEFAULTSIZE,DEFAULTSIZE);
    
    for (int i = 0;i<[array count];i++) {
        MPMediaItem *item = (MPMediaItem *)[array objectAtIndex:i];
        long extent = [[item valueForProperty:MPMediaItemPropertyPlayCount] integerValue];
        imageFrame = CGRectMake(imageFrame.origin.x,imageFrame.origin.y,DEFAULTSIZE + +extent/10,DEFAULTSIZE + +extent/10);
        labelFrame = CGRectMake(0,0,DEFAULTSIZE + +extent/10,DEFAULTSIZE + +extent/10);
        
        //ラベルの作成
        UILabel *label = [self makeLabel:labelFrame withString:[item valueForProperty:MPMediaItemPropertyTitle]];
        
        //アートワークからImage作成
        MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        
        NSMutableArray *musicArray = [[NSMutableArray alloc] initWithCapacity:1];
        [musicArray addObject:item];
        
        MusicImage *musicImage = [[MusicImage alloc] initWithImage:[artwork imageWithSize:CGSizeMake(DEFAULTSIZE,DEFAULTSIZE)]];
        musicImage.tag = self.imageTag;
        [self updateTag];
        
        //queryの追加
        [musicImage addMusic:musicArray];
        
        if(musicImage.image == nil)
            musicImage.image = [UIImage imageNamed:@"albumDefault.jpg"];
        
        musicImage.frame = imageFrame;
        
        [musicImage addSubview:label];
        
        [self.scroller addMusicImage:musicImage];
        
        imageFrame.origin.x+=5;
        imageFrame.origin.y+=5;//初期設置位置の更新
        if(imageFrame.origin.y>=MAXHEIGHT){
            imageFrame.origin.y = MAXHEIGHT;
            imageFrame.origin.x = MAXHEIGHT;
        }
    }
}

/**
 * デリゲートメソッドその1を実装
 */
- (void)changeViewController:(NSMutableArray *)cnt
{
    ViewController *nextController = (ViewController *)cnt;
    nextController.prevController = self;
    [appDelegate addController:(ViewController *)nextController];
}

-(int)getImageTag{
    return self.imageTag;
}

@end

