//
//  RCAPIClient.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCAPIClient.h"

//NSString *const kAPIBaseURLString = @"http://ruby-china.org/api/";
NSString *const kAPIBaseURLString = @"http://ruby-china.org/api/v2";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCAPIClient

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (RCAPIClient*)sharedClient
{
    static RCAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:HOST_API_URL]];
    });
    
    return _sharedClient;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
//        self.parameterEncoding = AFJSONParameterEncoding;
        
        // 502-bad-gateway error, set user agent from http://whatsmyuseragent.com/
        // http://stackoverflow.com/questions/8487581/uiwebview-ios5-changing-user-agent/8666438#8666438
#warning "todo set default header for v2ex"
#if 0
        if (ForumBaseAPIType_V2EX == FORUM_BASE_API_TYPE) {
            NSString* testUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_3 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B508 Safari/9537.53";
            [self setDefaultHeader:@"User-Agent" value:testUserAgent];
        }
#endif
    }
    return self;
}

#pragma mark - Sign in

// 登录
+ (NSString*)relativePathForSignIn
{
    return [NSString stringWithFormat:@"account/sign_in.json"];
}

#pragma mark - Topics
// 活跃帖子、优质帖子、无人问津、最近创建
// TODO: add topic type:
+ (NSString*)relativePathForTopicsWithPageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount
{
    //TODO:add ForumBaseAPIType
    if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"topics.json?page=%u&per_page=%u",
                pageCounter, perpageCount];
    }
    else if (ForumBaseAPIType_V2EX == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"topics/latest.json?page=%u&per_page=%u",
                pageCounter, perpageCount];
    }
    return nil;
}

// 帖子详细
+ (NSString*)relativePathForTopicDetailWithTopicId:(unsigned long)topicId
{
    if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"topics/%ld.json", topicId];
    }
    else if (ForumBaseAPIType_V2EX == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"topics/show.json?id=%ld", topicId];
        //replies/show.json?topic_id=95398
    }
    return nil;
}

// 帖子回复列表
+ (NSString*)relativePathForTopicRepliesWithTopicId:(unsigned long)topicId
                                        pageCounter:(unsigned int)pageCounter
                                       perpageCount:(unsigned int)perpageCount
{
    if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
        return nil;
    }
    else if (ForumBaseAPIType_V2EX == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"replies/show.json?topic_id=%ld&page=%u&per_page=%u",
                                            topicId, pageCounter, perpageCount];
    }
    return nil;
}

// 节点帖子
+ (NSString*)relativePathForTopicsWithNodeId:(unsigned int)nodeId
                                 PageCounter:(unsigned int)pageCounter
                                perpageCount:(unsigned int)perpageCount
{
    if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"topics/node/%u.json?page=%u&per_page=%u",
                                            nodeId, pageCounter, perpageCount];
    }
    else if (ForumBaseAPIType_V2EX == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"nodes/show.json?id=%u&page=%u&per_page=%u",
                                            nodeId, pageCounter, perpageCount];
    }
    return nil;
}

// 用户发的帖子列表
+ (NSString*)relativePathForPostedTopicsWithUserLoginId:(NSString*)loginId
                                            pageCounter:(unsigned int)pageCounter
                                           perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"users/%@/topics.json?page=%u&per_page=%u",
                                        loginId, pageCounter, perpageCount];
}

// 用户收藏帖子列表
+ (NSString*)relativePathForFavoritedTopicsWithUserLoginId:(NSString*)loginId
                                               pageCounter:(unsigned int)pageCounter
                                              perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"users/%@/topics/favorite.json?page=%u&per_page=%u",
                                        loginId, pageCounter, perpageCount];
}

// 论坛所有节点
+ (NSString*)relativePathForForumNodes
{
    if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"nodes.json"];
    }
    else if (ForumBaseAPIType_V2EX == FORUM_BASE_API_TYPE) {
        return [NSString stringWithFormat:@"nodes/all.json"];
    }
    return nil;
}

// 酷站
+ (NSString*)relativePathForCoolSites
{
    return [NSString stringWithFormat:@"sites.json"];
}

// TOP会员
+ (NSString*)relativePathForTopMembersWithPageCounter:(unsigned int)pageCounter
                                         perpageCount:(unsigned int)perpageCount;
{
    return [NSString stringWithFormat:@"users.json?page=%u&per_page=%u", pageCounter, perpageCount];
}

#pragma mark - Write

// 发布新帖
+ (NSString*)relativePathForPostNewTopic
{
    return [NSString stringWithFormat:@"topics.json"];
}

// 回复帖子
+ (NSString*)relativePathForReplyTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%lu/replies.json", topicId];
}

// 收藏帖子
+ (NSString*)relativePathForFavoriteTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%lu/favorite.json", topicId];
}

// 关注帖子
+ (NSString*)relativePathForFollowTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%lu/follow.json", topicId];
}

// 取消关注帖子
+ (NSString*)relativePathForUnfollowTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%lu/unfollow.json", topicId];
}

#pragma mark - User

// 用户主页
+ (NSString*)relativePathForVisitUserHomepageWithLoginId:(NSString*)username
{
    return [NSString stringWithFormat:@"users/%@.json", username];
}

@end
