//
//  RCWikiC.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/14/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "NIWebController.h"

// TODO: 很奇怪，基于Ruby on rails后台web请求有时不被响应，
// 如：进入wiki页面后，点击一条wiki，webview的delegate没有调用
// - (void)webViewDidStartLoad:(UIWebView*)webView
// 导致底部前进和后退无法操作,疑问是
// 后台处理页面请求方式与php、js等是不是不太一样，小白，待求解
@interface RCWikiC : NIWebController

@end
