//
//  RCNodeEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCNodeEntity.h"

@implementation RCNodeEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.nodeId = [dic[JSON_ID] unsignedIntegerValue];
        self.nodeName = dic[JSON_NAME];
        self.topicsCount = [dic[JSON_TOPICS_COUNT] longValue];
        self.summary = dic[JSON_SUMMARY];
        self.sectionId = [dic[JSON_SECTION_ID] unsignedIntegerValue];
        self.sectionName = dic[JSON_SECTION_NAME];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCNodeEntity* entity = [[RCNodeEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
