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
        _sharedClient = [[RCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    });
    
    return _sharedClient;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // ruby china use AFJSONParameterEncoding encoding
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}

#pragma mark - Topics
// 活跃帖子、优质帖子、无人问津、最近创建
// TODO: add topic type:
+ (NSString*)relativePathForTopicsWithPageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"topics.json?page=%u&per_page=%u",
                                        pageCounter, perpageCount];
}

+ (NSString*)relativePathForTopicDetailWithTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%ld.json", topicId];
}

+ (NSString*)relativePathForTopicsWithNodeId:(unsigned int)nodeId
                                 PageCounter:(unsigned int)pageCounter
                                perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"topics/node/%u.json?page=%u&per_page=%u",
                                        nodeId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForPostedTopicsWithUserLoginId:(NSString*)loginId
                                            pageCounter:(unsigned int)pageCounter
                                           perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"users/%@/topics.json?page=%u&per_page=%u",
                                        loginId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForFavoritedTopicsWithUserLoginId:(NSString*)loginId
                                               pageCounter:(unsigned int)pageCounter
                                              perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"users/%@/topics/favorite.json?page=%u&per_page=%u",
                                        loginId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForForumNodes
{
    return [NSString stringWithFormat:@"nodes.json"];
}

+ (NSString*)relativePathForCoolSites
{
    return [NSString stringWithFormat:@"sites.json"];
}

+ (NSString*)relativePathForTopMembersWithPageCounter:(unsigned int)pageCounter
                                         perpageCount:(unsigned int)perpageCount;
{
    return [NSString stringWithFormat:@"users.json?page=%u&per_page=%u", pageCounter, perpageCount];
}

#pragma mark - Write

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

+ (NSString*)relativePathForVisitUserHomepageWithLoginId:(NSString*)username
{
    return [NSString stringWithFormat:@"users/%@.json", username];
}

@end
