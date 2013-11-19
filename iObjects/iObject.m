//
//  iObject.m
//  iCap
//
//  Created by 大畑 貴史 on 2013/11/12.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import "iObject.h"
#import "SuperView.h"
#import "MyScrollView.h"
#import "ViewController.h"

@implementation iObject

@synthesize vc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPanGesture];
        self.userInteractionEnabled = YES;
        [self becomeFirstResponder];
        [self addSingleFingerTapGestures];
        
    }
    return self;
}

-(void)addSingleFingerTapGestures{
    UITapGestureRecognizer *singleFingerDoubleTap;
    singleFingerDoubleTap = [[UITapGestureRecognizer alloc]
                             initWithTarget:self  action:@selector(handleSingleDoubleTap:)];
    singleFingerDoubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:singleFingerDoubleTap];
    
    UITapGestureRecognizer *singleFingerTap;
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleFingerTap];
    [singleFingerTap requireGestureRecognizerToFail:singleFingerDoubleTap];//ダブルタップが呼ばれないことを確認する
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    [[self getSuperview] playSelectSound];;
}

-(void)handleSingleDoubleTap:(UITapGestureRecognizer*)sender{
    GKSession *session =  vc.session;
    NSString *peerID = vc.peerID;
    NSError* error = nil;
    NSData* data = UIImageJPEGRepresentation(self.image, 0.5);
    [session sendData:data toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataReliable error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    NSLog(@"send image");
}

-(SuperView *)getSuperview{
    return (SuperView *)self.superview;
}
-(MyScrollView *)getMyScrollView{
    return (MyScrollView *)self.superview.superview;
}

-(void)addPanGesture{
    UIPanGestureRecognizer *panGesture;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:panGesture];
}

-(void)panAction:(UIPanGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        [[self superview] bringSubviewToFront:self];
        [self dropShadow];
        [[self getSuperview] playPanActionSound];
    }
    if(sender.state == UIGestureRecognizerStateChanged){
        // imageの位置を更新する
        //imageの位置更新
        CGPoint location = [sender translationInView:self];
        CGPoint movePoint = CGPointMake(self.center.x+location.x,self.center.y+location.y);
        
        movePoint = [self checkPoint:movePoint];
        
        self.center = movePoint;
        [sender setTranslation:CGPointZero inView:self];
    }
    if(sender.state == UIGestureRecognizerStateEnded){//pangestureが終了した時
        //imageが他のイメージと重なっていたら、アルバムを作成する
        [[self getSuperview] playPanActionSound];
        self.layer.shadowOpacity = 0.0f;
    }
}

-(void)dropShadow{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.shadowRadius = 5.0f;
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}

-(CGPoint)checkPoint:(CGPoint)movePoint{
    if(movePoint.x+self.frame.size.width/2>MAXWIDTH)
        movePoint.x = MAXWIDTH - self.frame.size.width/2;
    if(movePoint.x-self.frame.size.width/2<0)
        movePoint.x = self.frame.size.width/2;
    if(movePoint.y+self.frame.size.height/2>MAXHEIGHT)
        movePoint.y = MAXHEIGHT - self.frame.size.height/2;
    if(movePoint.y-self.frame.size.height/2<0)
        movePoint.y = self.frame.size.height/2;
    return movePoint;
}


@end
