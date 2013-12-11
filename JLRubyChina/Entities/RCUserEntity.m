//
//  RCUserEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCUserEntity.h"

//    "user": {
//        "id": 2596,
//        "login": "fengzhilian818",
//        "avatar_url": "http://ruby-china.org/avatar/e351cfb6c0fa7e761e5287952f292a16.png?s=120"
//            }
@implementation RCUserEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.userId = [dic[JSON_ID] unsignedLongValue];
        self.username = dic[JSON_LOGIN];
        self.avatarUrl = dic[JSON_AVATAR_URL];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCUserEntity* entity = [[RCUserEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
