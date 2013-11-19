//
//  PhotoLibraryAccessHundler.h
//  iCap
//
//  Created by 大畑 貴史 on 2013/10/29.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "PhotoLibraryAccessHundler.h"
#import "Accesser.h"

@interface PhotoLibraryAccesser : Accesser<UIImagePickerControllerDelegate, UINavigationControllerDelegate>;

@end
