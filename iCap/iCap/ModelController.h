//
//  ModelController.h
//  iCap
//
//  Created by 大畑 貴史 on 2013/08/26.
//  Copyright (c) 2013年 大畑 貴史. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end
