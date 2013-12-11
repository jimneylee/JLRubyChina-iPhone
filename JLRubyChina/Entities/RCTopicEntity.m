//
//  RCTopicEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCTopicEntity.h"
#import "NSDate+RubyChina.h"

//{
//    "id": 16115,
//    "title": "鍒╃敤 net-ssh 鏈嶅姟鍣ㄤ箣闂村彂閫佹枃浠�",
//    "created_at": "2013-12-10T13:27:41.334+08:00",
//    "updated_at": "2013-12-10T13:27:41.334+08:00",
//    "replied_at": null,
//    "replies_count": 0,
//    "node_name": "Ruby",
//    "node_id": 1,
//    "last_reply_user_id": null,
//    "last_reply_user_login": null,
//    "user": {
//        "id": 2596,
//        "login": "fengzhilian818",
//        "avatar_url": "http://ruby-china.org/avatar/e351cfb6c0fa7e761e5287952f292a16.png?s=120"
//            }
//}

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
