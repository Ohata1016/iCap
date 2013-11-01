//
//  PhotoLivraryAccesser.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/10/29.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "PhotoLibraryAccesser.h"
#import "ViewController.h"
#import "PhotoLibraryAccessHundler.h"


@implementation PhotoLibraryAccesser
{
    ViewController *cnt;
    PhotoLibraryAccessHundler *hundler;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        self.image = [UIImage imageNamed:@"Icon.png"];
        self.userInteractionEnabled = YES;
        [self becomeFirstResponder];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSingleTap:)];
        [self addGestureRecognizer:singleTap];   
    }
    return self;
}

-(void)setViewController:(ViewController *)controller{
    cnt = controller;
}

-(void)actionSingleTap:(UIGestureRecognizer *)sender{
    NSLog(@"test");
    if(sender.state == UIGestureRecognizerStateEnded){
        hundler = [[PhotoLibraryAccessHundler alloc] initWithController:cnt];
        [hundler callPhotoLibrary:self];
        //sorcetype:フォトアルバム
    }
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
