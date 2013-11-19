//
//  iMusicObject.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/12.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "iMusicObject.h"

@implementation iMusicObject

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"Icon.png"];
        self.userInteractionEnabled = YES;
        [self becomeFirstResponder];

    }
    return self;
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    NSLog(@"musicImage");
}

-(void)handleSingleDoubleTap:(UITapGestureRecognizer *)sender{
    NSLog(@"music hogehoge");
}


@end
