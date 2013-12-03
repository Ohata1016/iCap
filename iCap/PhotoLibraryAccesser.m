//
//  PhotoLibraryAccessHundler.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/10/29.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "PhotoLibraryAccesser.h"
#import "ViewController.h"

#import "iObject.h"
#import "iMusicObject.h"
#import "iImageObject.h"

@implementation PhotoLibraryAccesser
{
    PhotoLibraryAccessHundler *accsesser;
}

-(void) callLibrary:(NSObject*)caller{
    accsesser = (PhotoLibraryAccessHundler *)caller;
    [self startCameraPickerFromViewController:super.getViewController usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    [super.getViewController dismissViewControllerAnimated:YES completion:NULL];
    AudioServicesPlaySystemSound(OPENLIBRARYSOUNDNUM);//iphoneシステムサウンド
}

/// 画像の選択がキャンセルされたときに呼ばれるデリゲート関数
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)i_picker
{
    [super.getViewController dismissViewControllerAnimated:YES completion:^{
        AudioServicesPlaySystemSound(CLOSELIBRARYSOUNDNUM);//iphoneシステムサウンド
        [[[[accsesser superview] superview] viewWithTag:1] removeFromSuperview];
    }];
    
}

- (void) navigationController:(UINavigationController*)i_navigation_controller
        didShowViewController:(UIViewController*)i_view_controller
                     animated:(BOOL)i_animated
{
}

- (void)useImage:(UIImage*)i_image
{

    iObject *img = [[iImageObject alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    img.image = i_image;
    
    [super.getViewController.scroller.getSubview addSubview:img];
    
    [[[[accsesser superview] superview] viewWithTag:1] removeFromSuperview];
    
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
