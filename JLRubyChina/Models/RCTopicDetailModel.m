//
//  RCTopicDetailModel.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicDetailModel.h"
#import "RCReplyCell.h"
#import "RCReplyEntity.h"

@implementation RCTopicDetailModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        // TODO:数据一次性获取过来，没有分页，后面建议后台做分页
        self.perpageCount = NSIntegerMax;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    // TODO: set type
    return [RCAPIClient relativePathForTopicDetailWithTopicId:self.topicId];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)listKey
{
	return JSON_REPLIES_LIST;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [RCReplyEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [RCReplyCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)entitiesParsedFromResponseObject:(id)responseObject
{
    // 1、parse topic detail body
    self.topicDetailEntity = [RCTopicDetailEntity entityWithDictionary:responseObject];
    
    // 2、parse replies list with key: JSON_REPLIES_LIST
    NSArray* entities = [super entitiesParsedFromResponseObject:responseObject];
    RCReplyEntity* o = nil;
    for (NSUInteger i = 0; i < entities.count; i++) {
        o = entities[i];
        o.floorNumber = i+1;
    }
    
    // 3、call inline sort
    entities = [entities sortedArrayUsingSelector:@selector(compare:)];
    
    return entities;
}

@end
