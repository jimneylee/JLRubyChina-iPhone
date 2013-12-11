//
//  RCGlobalConfig.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_ID [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APP_STORE_ID"] longValue]
#define IOS_7_X (([[UIDevice currentDevice].systemVersion floatValue] > 6.99))

// iOS 系统版本
#define IOS_IS_AT_LEAST_6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IOS_IS_AT_LEAST_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define INVALID_INDEX -1
#define CELL_PADDING_10 10
#define CELL_PADDING_8 8
#define CELL_PADDING_6 6
#define CELL_PADDING_4 4
#define CELL_PADDING_2 2
#define PHONE_SCREEN_WIDTH 320

#define APP_THEME_COLOR [RCGlobalConfig mainThemeColor]
#define TABLE_VIEW_BG_COLOR RGBCOLOR(230, 230, 230)
#define CELL_CONTENT_VIEW_BG_COLOR RGBCOLOR(247, 247, 247)
#define CELL_CONTENT_VIEW_BORDER_COLOR RGBCOLOR(234, 234, 234)
#define SIDE_DIRECTION_LEFT_OFFSET 160//左边栏tableview离右边距离，理解有点别扭，后面简洁化

// 自定义链接协议
#define PROTOCOL_AT_SOMEONE @"atsomeone://"
#define PROTOCOL_SHARP_FLOOR @"sharpfloor://"
#define PROTOCOL_NODE @"node://"

typedef enum {
    RCForumTopicsType_LatestActivity,//当前活跃帖子
    RCForumTopicsType_HighQuality,//优质帖子
    RCForumTopicsType_NeverReviewed,//无人问津
    RCForumTopicsType_LatestCreate,//最新创建
    RCForumTopicsType_NodeList//分类帖子
}RCForumTopicsType;

@interface RCGlobalConfig : NSObject

// UI
+ (void)showHUDMessage:(NSString*)msg addedToView:(UIView*)view;
+ (UIColor *)mainThemeColor;
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle Target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action;
@end
