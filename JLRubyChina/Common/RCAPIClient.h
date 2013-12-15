//
//  RCAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AFHTTPClient.h"
#import "JLAFHTTPClient.h"

/** UNDO
 POST   ruby-china.org/api/topics/:id/follow.json
 POST   ruby-china.org/api/topics/:id/unfollow.json
 POST   ruby-china.org/api/topics/:id/favorite.json
 GET	ruby-china.org/api/users/temp_access_token.json
*/

/* DONE
 GET     ruby-china.org/api/topics.json
 GET     ruby-china.org/api/topics/node/:id.json
 POST    ruby-china.org/api/topics.json
 GET     ruby-china.org/api/topics/:id.json
 POST    ruby-china.org/api/topics/:id/replies.json
 GET     ruby-china.org/api/nodes.json
 GET     ruby-china.org/api/sites.json
 PUT    ruby-china.org/api/user/favorite/:user/:topic.json
 GET    ruby-china.org/api/users.json
 GET	ruby-china.org/api/users/:user.json
 GET	ruby-china.org/api/users/:user/topics.json
 GET	ruby-china.org/api/users/:user/topics/favorite.json
*/
@interface RCAPIClient : JLAFHTTPClient

+ (RCAPIClient*)sharedClient;

//================================================================================
// topic read
//================================================================================

// 热帖
+ (NSString*)relativePathForTopicsWithPageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount;

// 查看帖子详细 TODO:评论没有按实现先后排序，有错乱
+ (NSString*)relativePathForTopicDetailWithTopicId:(unsigned long)topicId;

// 节点帖子
+ (NSString*)relativePathForTopicsWithNodeId:(unsigned int)nodeId
                                 PageCounter:(unsigned int)pageCounter
                                perpageCount:(unsigned int)perpageCount;

// 用户发的帖子列表 TODO:此接口总是返回最新的15条:http://ruby-china.org/api/v2/users/huacnlee/topics.json?page=1&per_page=30
+ (NSString*)relativePathForPostedTopicsWithUserLoginId:(NSString*)loginId
                                            pageCounter:(unsigned int)pageCounter
                                           perpageCount:(unsigned int)perpageCount;

// 用户收藏帖子列表
+ (NSString*)relativePathForFavoritedTopicsWithUserLoginId:(NSString*)loginId
                                               pageCounter:(unsigned int)pageCounter
                                              perpageCount:(unsigned int)perpageCount;

// 论坛所有节点
+ (NSString*)relativePathForForumNodes;

// 酷站
+ (NSString*)relativePathForCoolSites;

// TOP会员
+ (NSString*)relativePathForTopMembersWithPageCounter:(unsigned int)pageCounter
                                         perpageCount:(unsigned int)perpageCount;

//================================================================================
// topic write
//================================================================================

// 发布新帖
+ (NSString*)relativePathForPostNewTopic;

// 回复帖子
+ (NSString*)relativePathForReplyTopicId:(unsigned long)topicId;

//================================================================================
// user page
//================================================================================
+ (NSString*)relativePathForVisitUserHomepageWithLoginId:(NSString*)username;

@end

NSString *const kAPIBaseURLString;