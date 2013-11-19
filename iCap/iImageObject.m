//
//  iImageObject.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/12.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "iImageObject.h"

@implementation iImageObject
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
    NSLog(@"image");
}

-(void)handleSingleDoubleTap:(UITapGestureRecognizer *)sender{
    NSLog(@"image hogehoge");
}
@end
