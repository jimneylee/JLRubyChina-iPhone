//
//  RCForumNodesModel.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCForumNodesModel.h"
#import "RCNodeCell.h"
#import "RCNodeEntity.h"

@implementation RCForumNodesModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        // TODO:数据一次性获取过来，没有分页，这边逻辑有点别扭，待修改
        self.perpageCount = NSUIntegerMax;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [RCAPIClient relativePathForForumNodes];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [RCNodeEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [RCNodeCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)entitiesParsedFromResponseObject:(id)responseObject
{
    NSArray* entities = [super entitiesParsedFromResponseObject:responseObject];
    self.nodesArray = entities;
    // 重新分组
//    RCNodeEntity* o = nil;
//    for (NSUInteger i = 0; i < entities.count; i++) {
//        o = entities[i];
//    }
    return entities;
}

@end
