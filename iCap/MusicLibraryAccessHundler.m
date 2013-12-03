//
//  MusicLibraryAccesser.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/19.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "MusicLibraryAccessHundler.h"
#import "MusicLibraryAccesser.h"
#import "ViewController.h"

@implementation MusicLibraryAccessHundler{
    MusicLibraryAccesser  *hundler;
}
    
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"MusicImageIcon.gif"];
        self.userInteractionEnabled = YES;
        [self becomeFirstResponder];
        [self addSingleFingerTapGesture];
    }
    return self;
}

    
-(void)actionSingleTap:(UITapGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateEnded){
        hundler = [[MusicLibraryAccesser alloc] initWithController:[super getViewController]];
        [hundler callLibrary:self];
//        sorcetype:フォトアルバム
    }
}
    



    
    
    
    
    
@end
