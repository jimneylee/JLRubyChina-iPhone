//
//  RCNodeEntity.m
//  JLRubyChina
//
//  Created by jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCNodeEntity.h"
#import "NSString+stringFromValue.h"

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

        if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
            self.nodeName = dic[JSON_NAME];
            self.topicsCount = [dic[JSON_TOPICS_COUNT] longValue];
            self.summary = dic[JSON_SUMMARY];
            self.sectionId = [dic[JSON_SECTION_ID] unsignedIntegerValue];
            self.sectionName = dic[JSON_SECTION_NAME];
        }
        else {
            self.nodeName = dic[JSON_TITLE];
            self.topicsCount = [dic[JSON_TOPICS] longValue];
            self.summary = [NSString stringFromValue:dic[JSON_HEADER]];
            // TODO: API need add
            self.sectionId = 1;
            self.sectionName = @"全部暂未分组";
            //self.sectionId = [dic[JSON_SECTION_ID] unsignedIntegerValue];
            //self.sectionName = dic[JSON_SECTION_NAME];
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
    
    RCNodeEntity* entity = [[RCNodeEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
