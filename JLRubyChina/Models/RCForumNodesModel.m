//
//  RCForumNodesModel.m
//  JLRubyChina
//
//  Created by jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCForumNodesModel.h"
#import "RCNodeCell.h"
#import "RCNodeEntity.h"
#import "RCNodeSectionEntity.h"
#import "RCAPIClient.h"

@implementation RCForumNodesModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        // TODO:数据一次性获取过来，没有分页，这边逻辑有点别扭，待修改
        if (delegate && [delegate isKindOfClass:[NICellFactory class]]) {
            NICellFactory* factory = (NICellFactory*)delegate;
            NIDASSERT([self objectClass]);
            NIDASSERT([self cellClass]);
            [factory mapObjectClass:[self objectClass]
                        toCellClass:[self cellClass]];
        }
        self.nodeSectionsArray = [[NSMutableArray alloc] init];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [RCAPIClient relativePathForForumNodes];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)apiSharedClient
{
    return [RCAPIClient sharedClient];
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
    NSArray* sourceArray = (NSArray*)responseObject;
    RCNodeEntity* entity = nil;
    NSMutableArray* entities = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in sourceArray) {
        entity = [RCNodeEntity entityWithDictionary:dic];
        [entities addObject:entity];
    }
    self.nodesArray = entities;
    for (RCNodeEntity* o in entities) {
        
        BOOL hasExist = NO;
        for (RCNodeSectionEntity* s in _nodeSectionsArray) {
            if (s.sectionId == o.sectionId) {
                hasExist = YES;
                break;
            }
        }
        if (!hasExist) {
            RCNodeSectionEntity* s = [[RCNodeSectionEntity alloc] init];
            s.sectionId = o.sectionId;
            s.name = o.sectionName;
            s.nodesArray = [[NSMutableArray alloc] init];
            [_nodeSectionsArray addObject:s];
        }
    }
    for (RCNodeEntity* o in entities) {
        for (RCNodeSectionEntity* s in _nodeSectionsArray) {
            if (s.sectionId == o.sectionId) {
                [s.nodesArray addObject:o];
                break;
            }
        }
    }
    return _nodeSectionsArray;
}

- (void)loadNodesWithBlock:(void(^)(NSArray* nodeSectionsArray, NSError *error))block
{
    if (self.isLoading) {
        return;
    }
    else {
        self.isLoading = YES;
    }
    
    NSString* relativePath = [self relativePath];
    [[self apiSharedClient] GET:relativePath parameters:nil
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            self.isLoading = NO;
                            if ([responseObject isKindOfClass:[NSArray class]]) {
                                NSArray* sectionsArray = [self entitiesParsedFromResponseObject:responseObject];
                                if (block) {
                                    block(sectionsArray, nil);
                                }
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            self.isLoading = NO;
                            if (block) {
                                block(nil, error);
                            }
                        }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancelRequstOperation
{
    if (self.isLoading) {
        [[RCAPIClient sharedClient] cancelAllHTTPOperationsWithPath:[self relativePath]];
        self.isLoading = NO;
    }
}

@end
