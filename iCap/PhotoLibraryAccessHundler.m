//
//  PhotoLibraryAccessHundler.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/10/29.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "PhotoLibraryAccessHundler.h"
#import "ViewController.h"
#import "IcImageView.h"

@implementation PhotoLibraryAccessHundler
{
    ViewController *cnt;
    PhotoLibraryAccesser *accsesser;
}


- (id)initWithController:(ViewController *)controller{
    self = [super init];
        if (self) {
            cnt = controller;
        }
    return self;
}

-(void) callPhotoLibrary:(PhotoLibraryAccesser*)caller{
    accsesser = caller;
    [self startCameraPickerFromViewController:cnt usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    [cnt dismissViewControllerAnimated:YES completion:NULL];
    AudioServicesPlaySystemSound(OPENLIBRARYSOUNDNUM);//iphoneシステムサウンド
}

/// 画像の選択がキャンセルされたときに呼ばれるデリゲート関数
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)i_picker
{
    [cnt dismissViewControllerAnimated:YES completion:^{
        NSLog(@"canceled");
        AudioServicesPlaySystemSound(CLOSELIBRARYSOUNDNUM);//iphoneシステムサウンド
            [[[[accsesser superview] superview] viewWithTag:[accsesser superview].hash] removeFromSuperview];
    }];
    
}

- (void) navigationController:(UINavigationController*)i_navigation_controller
        didShowViewController:(UIViewController*)i_view_controller
                     animated:(BOOL)i_animated
{
}

- (void)useImage:(UIImage*)i_image
{
/*     IcImageView *view =[[IcImageView alloc] initWithImage:i_image];
     MyLabel *textView = [[MyLabel alloc] initWithFrame:CGRectMake(view.frame.origin.x,view.frame.origin.y,
     view.frame.size.width,view.frame.size.height/4)];
     textView.text = @"TEST";
     textView.tag = imageTag + TEXT;
     textView.backgroundColor = [UIColor clearColor];
     
     view.userInteractionEnabled = YES;
     view.tag = imageTag;
     NSLog(@"tag = %d",view.tag);
     imageTag+=4;
     [view addSubview:textView];
     [_scroller addSubview:view];
     
     view.delegate = self;*/

    IcImageView *img = [[IcImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    img.image = i_image;
    
    [cnt.scroller.getSubview addSubview:img];
    
    //  SuperView *view = [_scroller getSubview];
    // view.image = i_image;
    //    [self serializeViewData];
    NSLog(@"%@",[accsesser superview]);
    NSLog(@"%@",[[accsesser superview] superview]);
    [[[[accsesser superview] superview] viewWithTag:[accsesser superview].hash] removeFromSuperview];

    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
