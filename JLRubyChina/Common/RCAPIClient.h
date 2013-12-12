//
//  RCAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AFHTTPClient.h"
#import "JLAFHTTPClient.h"

@interface RCAPIClient : JLAFHTTPClient

+ (RCAPIClient*)sharedClient;

//================================================================================
// search
//================================================================================
// 搜索用户
+ (NSString*)relativePathForTopicsWithPageCounter:(NSUInteger)pageCounter
                                     perpageCount:(NSUInteger)perpageCount;
// 查看帖子详细
+ (NSString*)relativePathForTopicDetailWithTopicId:(unsigned long)topicId;

// 节点帖子
+ (NSString*)relativePathForTopicsWithNodeId:(NSUInteger)nodeId
                                 PageCounter:(NSUInteger)pageCounter
                                perpageCount:(NSUInteger)perpageCount;
// 论坛所有节点
+ (NSString*)relativePathForForumNodes;

// 回复帖子
+ (NSString*)relativePathForReplyTopicId:(unsigned long)topicId;

// 酷站
+ (NSString*)relativePathForCoolSites;

@end

NSString *const kAPIBaseURLString;