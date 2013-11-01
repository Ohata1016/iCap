//
//  PhotoLibraryAccessHundler.h
//  iCap
//
//  Created by 大畑 貴史 on 2013/10/29.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "PhotoLibraryAccesser.h"
@interface PhotoLibraryAccessHundler : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>;

-(id)initWithController:(ViewController *)controller;
-(void) callPhotoLibrary:(PhotoLibraryAccesser*)caller;
@end
