//
//  MacroDefines.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/16/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#ifndef JLRubyChina_MacroDefines_h
#define JLRubyChina_MacroDefines_h

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_ID [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APP_STORE_ID"] longValue]
#define HOST_API_URL [[NSBundle mainBundle] objectForInfoDictionaryKey:@"HOST_API_URL"]

// iOS 系统版本
#define IOS_IS_AT_LEAST_6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IOS_IS_AT_LEAST_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// 兼容ios6.0
#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1  993.00
#endif

// 是否是iphone5的判断
#define IS_WIDESCREEN ([[UIScreen mainScreen] bounds].size.height > 500)
#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] \
                  ||[[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])
#define IS_IPHONE5 (IS_IPHONE && IS_WIDESCREEN)

// Cell布局
#define CELL_PADDING_10 10
#define CELL_PADDING_8 8
#define CELL_PADDING_6 6
#define CELL_PADDING_4 4
#define CELL_PADDING_2 2


#define APP_THEME_COLOR RGBCOLOR(41, 41, 41)
#define RUBY_RED_COLOR RGBCOLOR(177, 9, 0)
#define TABLE_VIEW_BG_COLOR RGBCOLOR(230, 230, 230)
#define CELL_CONTENT_VIEW_BG_COLOR RGBCOLOR(247, 247, 247)
#define CELL_CONTENT_VIEW_BORDER_COLOR RGBCOLOR(234, 234, 234)
#define SIDE_DIRECTION_LEFT_OFFSET 160//左边栏tableview离右边距离，理解有点别扭，后面简洁化

#define RC_WIKI_URL @"http://ruby-china.org/wiki"

// 自定义链接协议
#define PROTOCOL_AT_SOMEONE @"atsomeone://"
#define PROTOCOL_SHARP_FLOOR @"sharpfloor://"
#define PROTOCOL_NODE @"node://"

// Notification通知
#define DID_LOGIN_NOTIFICATION @"DID_LOGIN_NOTIFICATION"
#define DID_LOGOUT_NOTIFICATION @"DID_LOGOUT_NOTIFICATION"

#endif
