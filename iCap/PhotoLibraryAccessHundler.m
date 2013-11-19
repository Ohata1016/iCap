//
//  PhotoLivraryAccesser.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/10/29.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "PhotoLibraryAccessHundler.h"
#import "ViewController.h"
#import "PhotoLibraryAccesser.h"


@implementation PhotoLibraryAccessHundler
{
    PhotoLibraryAccesser *hundler;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        self.image = [UIImage imageNamed:@"ImageIcon.gif"];
        self.userInteractionEnabled = YES;
        [self becomeFirstResponder];
        [self addSingleFingerTapGesture];
    }
    return self;
}


-(void)actionSingleTap:(UIGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateEnded){
        hundler = [[PhotoLibraryAccesser alloc] initWithController:[super getViewController]];
        [hundler callLibrary:self];
        //sorcetype:フォトアルバム
    }
}

- (void)drawRect:(CGRect)rect
{

     IcImageView *view =[[IcImageView alloc] initWithImage:i_image];
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
    img.vc = cnt;
    img.image = i_image;
    
    [cnt.scroller.getSubview addSubview:img];
    
    //  SuperView *view = [_scroller getSubview];
    // view.image = i_image;
    //    [self serializeViewData];
    NSLog(@"%@",[accsesser superview]);
    NSLog(@"%@",[[accsesser superview] superview]);
    [[[[accsesser superview] superview] viewWithTag:[accsesser superview].hash] removeFromSuperview];
}


@end
