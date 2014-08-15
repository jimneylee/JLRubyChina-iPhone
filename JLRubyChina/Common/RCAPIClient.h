//
//  RCAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLAFAPIBaseClient.h"

/* RubyChina
    GET     ruby-china.org/api/topics.json
    GET     ruby-china.org/api/topics/node/:id.json
    POST    ruby-china.org/api/topics.json
    GET     ruby-china.org/api/topics/:id.json
    POST    ruby-china.org/api/topics/:id/replies.json
    GET     ruby-china.org/api/nodes.json
    GET     ruby-china.org/api/sites.json
    PUT     ruby-china.org/api/user/favorite/:user/:topic.json
    GET     ruby-china.org/api/users.json
    GET     ruby-china.org/api/users/:user.json
    GET     ruby-china.org/api/users/:user/topics.json
    GET     ruby-china.org/api/users/:user/topics/favorite.json
    POST    ruby-china.org/api/topics/:id/follow.json
    POST    ruby-china.org/api/topics/:id/unfollow.json
    POST    ruby-china.org/api/topics/:id/favorite.json
    GET     ruby-china.org/api/users/temp_access_token.json
*/

/* V2EX
    ('/api/site/stats.json', SiteStatsHandler),
    ('/api/site/info.json', SiteInfoHandler),
    ('/api/nodes/all.json', NodesAllHandler),
    ('/api/nodes/show.json', NodesShowHandler),
    ('/api/topics/latest.json', TopicsLatestHandler),
    ('/api/topics/show.json', TopicsShowHandler),
    ('/api/topics/create.json', TopicsCreateHandler),
    ('/api/replies/show.json', RepliesShowHandler),
    ('/api/members/show.json', MembersShowHandler),
    ('/api/currency.json', CurrencyHandler)
*/

@interface RCAPIClient : JLAFAPIBaseClient

+ (RCAPIClient*)sharedClient;

//================================================================================
// account sing in
//================================================================================

// 登录
+ (NSString*)relativePathForSignIn;

//================================================================================
// topic read
//================================================================================

// 热帖
+ (NSString*)relativePathForTopicsWithPageIndex:(unsigned int)pageIndex
                                     pageSize:(unsigned int)pageSize;

// 查看帖子详细 TODO:评论没有按实现先后排序，有错乱
+ (NSString*)relativePathForTopicDetailWithTopicId:(unsigned long)topicId;

// 帖子回复列表
+ (NSString*)relativePathForTopicRepliesWithTopicId:(unsigned long)topicId
                                        pageIndex:(unsigned int)pageIndex
                                       pageSize:(unsigned int)pageSize;

// 节点帖子
+ (NSString*)relativePathForTopicsWithNodeId:(unsigned int)nodeId
                                 pageIndex:(unsigned int)pageIndex
                                pageSize:(unsigned int)pageSize;

// 用户发的帖子列表 TODO:此接口总是返回最新的15条:http://ruby-china.org/api/v2/users/huacnlee/topics.json?page=1&per_page=30
+ (NSString*)relativePathForPostedTopicsWithUserLoginId:(NSString*)loginId
                                            pageIndex:(unsigned int)pageIndex
                                           pageSize:(unsigned int)pageSize;

// 用户收藏帖子列表
+ (NSString*)relativePathForFavoritedTopicsWithUserLoginId:(NSString*)loginId
                                               pageIndex:(unsigned int)pageIndex
                                              pageSize:(unsigned int)pageSize;

// 论坛所有节点
+ (NSString*)relativePathForForumNodes;

// 酷站
+ (NSString*)relativePathForCoolSites;

// TOP会员
+ (NSString*)relativePathForTopMembersWithPageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize;

//================================================================================
// topic write
//================================================================================

// 发布新帖
+ (NSString*)relativePathForPostNewTopic;

// 回复帖子
+ (NSString*)relativePathForReplyTopicId:(unsigned long)topicId;

// 收藏帖子
+ (NSString*)relativePathForFavoriteTopicId:(unsigned long)topicId;

// 关注帖子
+ (NSString*)relativePathForFollowTopicId:(unsigned long)topicId;

// 取消关注帖子
+ (NSString*)relativePathForUnfollowTopicId:(unsigned long)topicId;

//================================================================================
// user page
//================================================================================

// 用户主页
+ (NSString*)relativePathForVisitUserHomepageWithLoginId:(NSString*)username;

@end

NSString *const kAPIBaseURLString;