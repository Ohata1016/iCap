//
//  SaveDataLoader.h
//  iCap
//
//  Created by 大畑貴史 on 2014/11/19.
//  Copyright (c) 2014年 大畑 貴史. All rights reserved.
//

#ifndef iCap_SaveDataLoader_h
#define iCap_SaveDataLoader_h

@interface SaveDataLoader : NSObject

-(void)readViewData:(UIViewController *)controller;
-(void)readSerialData:(ViewController *)controller;

@end

#endif
