//
//  MusicLibraryAccesser.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/19.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "MusicLibraryAccessHundler.h"



@implementation MusicLibraryAccessHundler{
    // PhotoLibraryAccessHundler *hundler;
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
        //hundler = [[PhotoLibraryAccessHundler alloc] initWithController:cnt];
        //[hundler callPhotoLibrary:self];
        //sorcetype:フォトアルバム
    }
}
    
    
    
    
    
    
    
    
@end
