//
//  RCGlobalConfig.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RCForumTopicsType_LatestActivity,//当前活跃帖子
    RCForumTopicsType_HighQuality,//优质帖子
    RCForumTopicsType_NeverReviewed,//无人问津
    RCForumTopicsType_LatestCreate,//最新创建
    RCForumTopicsType_NodeList,//某一分类帖子
    RCForumTopicsType_UserPosted,//某个用户发的
    RCForumTopicsType_UserFavorited//某个用户收藏
}RCForumTopicsType;

@interface RCGlobalConfig : NSObject

//Global Data
+ (NSString*)myToken;
+ (void)setMyToken:(NSString*)token;
+ (NSString*)myLoginId;
+ (void)setMyLoginId:(NSString*)loginId;

// Global UI
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view;
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle Target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (void)showLoginControllerFromNavigationController:(UINavigationController*)navigationController;

@end
