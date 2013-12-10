//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNavigationController : UINavigationController

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic, assign) BOOL canDragBack;

// jimneylee add
@property (nonatomic, assign) NSUInteger backFloorNumber; // Default 1

// jimneylee add 
- (void)removeAllScreenshots;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated addScreenshot:(BOOL)addScreenshot;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated removeScreenshot:(BOOL)removeScreenshot;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated removeAllScreenshots:(BOOL)removeAllScreenshots;

@end
