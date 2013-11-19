//
//  Accesser.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/19.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "Accesser.h"

@implementation Accesser
{
    ViewController *cnt;
}


- (id)initWithController:(ViewController *)controller{
    self = [super init];
    if (self) {
        cnt = controller;
    }
    return self;
}

-(void) callLibrary:(NSObject*)caller{
}

-(ViewController *)getViewController{
    return cnt;
}
@end
