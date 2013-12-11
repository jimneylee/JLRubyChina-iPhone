//
//  RCTopicDetailEntity.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicDetailEntity.h"
#import "SCRegularParser.h"

@implementation RCTopicDetailEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.body = dic[JSON_BODY];
        self.hitsCount = [dic[JSON_HITS_COUNT] unsignedLongValue];
        [self parseAllKeywords];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCTopicDetailEntity* entity = [[RCTopicDetailEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 识别出 表情 at某人 share话题 标签
- (void)parseAllKeywords
{
    if (self.body.length) {
        // TODO: emotion
        // 考虑优先剔除表情，这样@和#不会勿标识
        if (!self.atPersonRanges) {
            self.atPersonRanges = [SCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
        if (!self.sharpFloorRanges) {
            self.sharpFloorRanges = [SCRegularParser keywordRangesOfSharpFloorInString:self.body];
        }
    }
}

@end
