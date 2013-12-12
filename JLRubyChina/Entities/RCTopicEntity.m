//
//  RCTopicEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCTopicEntity.h"
#import "NSDate+RubyChina.h"

@implementation RCTopicEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        
        self.topicId = [dic[JSON_ID] unsignedLongValue];
        self.topicTitle = dic[JSON_TITLE];
        self.nodeId = [dic[JSON_NODE_ID] unsignedIntegerValue];
        self.nodeName = dic[JSON_NODE_NAME];
        self.createdAtDate = [NSDate dateFromSourceDateString:dic[JSON_CREATEED_AT]];
        self.updatedAtDate = [NSDate dateFromSourceDateString:dic[JSON_UPDATEED_AT]];
        self.repliedAtDate = [NSDate dateFromSourceDateString:dic[JSON_REPLIED_AT]];
        self.repliesCount = [dic[JSON_REPLIES_COUNT] unsignedLongValue];
        self.user = [RCUserEntity entityWithDictionary:dic[JSON_USER]];
        
        NSString* lastRepliedUserName = dic[JSON_LAST_REPLY_USER_LOGIN];
        if (lastRepliedUserName && [lastRepliedUserName isKindOfClass:[NSString class]] && lastRepliedUserName.length) {
            self.lastRepliedUser = [[RCUserEntity alloc] init];
            self.lastRepliedUser.userId = [dic[JSON_LAST_REPLY_USER_ID] unsignedLongValue];
            self.lastRepliedUser.username = lastRepliedUserName;
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCTopicEntity* entity = [[RCTopicEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
