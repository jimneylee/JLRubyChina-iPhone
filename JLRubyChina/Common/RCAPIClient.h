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
// read
//================================================================================

// 热帖
+ (NSString*)relativePathForTopicsWithPageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount;
// 查看帖子详细
+ (NSString*)relativePathForTopicDetailWithTopicId:(unsigned long)topicId;

// 节点帖子
+ (NSString*)relativePathForTopicsWithNodeId:(unsigned int)nodeId
                                 PageCounter:(unsigned int)pageCounter
                                perpageCount:(unsigned int)perpageCount;

// 论坛所有节点
+ (NSString*)relativePathForForumNodes;

// 酷站
+ (NSString*)relativePathForCoolSites;

//================================================================================
// write
//================================================================================

// 发布新帖
+ (NSString*)relativePathForPostNewTopic;

// 回复帖子
+ (NSString*)relativePathForReplyTopicId:(unsigned long)topicId;

@end

NSString *const kAPIBaseURLString;