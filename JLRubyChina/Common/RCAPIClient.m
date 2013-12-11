//
//  RCAPIClient.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCAPIClient.h"

NSString *const kAPIBaseURLString = @"http://ruby-china.org/api/";

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
+ (NSString*)relativePathForTopicsWithPageCounter:(NSUInteger)pageCounter
                                     perpageCount:(NSUInteger)perpageCount
{
    return [NSString stringWithFormat:@"topics.json?page=%d&per_page=%d",
                                        pageCounter, perpageCount];
}

+ (NSString*)relativePathForTopicDetailWithTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%ld.json", topicId];
}

+ (NSString*)relativePathForTopicsWithNodeId:(NSUInteger)nodeId
                                 PageCounter:(NSUInteger)pageCounter
                                perpageCount:(NSUInteger)perpageCount
{
    return [NSString stringWithFormat:@"topics/node/%u.json?page=%d&per_page=%d",
                                        nodeId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForForumNodes
{
    return [NSString stringWithFormat:@"nodes.json"];
}

+ (NSString*)relativePathForReplyTopicId:(unsigned long)topicId
{
    return [NSString stringWithFormat:@"topics/%lu/replies.json", topicId];
}

@end
