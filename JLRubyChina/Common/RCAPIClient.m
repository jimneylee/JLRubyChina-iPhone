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

+ (NSString*)relativePathForTopicsWithUserLoginId:(NSString*)loginId
                                      pageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"users/%@/topics.json?page=%u&per_page=%u",
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

+ (NSString*)relativePathForReplyTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%lu/replies.json", topicId];
}

#pragma mark - User

+ (NSString*)relativePathForVisitUserHomepageWithLoginId:(NSString*)username
{
    return [NSString stringWithFormat:@"users/%@.json", username];
}

@end
