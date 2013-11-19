//
//  Accesser.h
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/19.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"


@interface Accesser : NSObject
-(id)initWithController:(ViewController *)controller;
-(void)callLibrary:(NSObject*)caller;
-(ViewController *)getViewController;
@end
