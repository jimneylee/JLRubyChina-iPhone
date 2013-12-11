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
//- (void)loadDataWithBlock:(void(^)(NSArray* indexPaths, NSError *error))block  more:(BOOL)more
//{
//    NSString* relativePath = [self relativePath];
//    [[RCAPIClient sharedClient] getPath:relativePath parameters:[self generateParameters]
//                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                    // remove all
//                                    for (int i = 0; i < self.sections.count; i++) {
//                                        [self removeSectionAtIndex:i];
//                                    }
//                                    // reset with latest
//                                    SMTrendListEntity* entity = [SMTrendListEntity entityWithDictionary:responseObject];
//                                    NITableViewModelSection* s = nil;
//                                    NSMutableArray* modelSections = [NSMutableArray arrayWithCapacity:entity.items.count];
//                                    for (int i = 0; i < entity.items.count; i++) {
//                                        s = [NITableViewModelSection section];
//                                        s.headerTitle = entity.sections[i];
//                                        s.rows = entity.items[i];
//                                        [modelSections addObject:s];
//                                    }
//                                    self.sections = modelSections;
//                                    self.sectionIndexTitles = entity.sections;
//                                    
//                                    if (block) {
//                                        block(self.sections, nil);
//                                    }
//                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                    NSLog(@"Error:%@", error.description);
//                                    if (block) {
//                                        block(nil, error);
//                                    }
//                                }];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)entitiesParsedFromResponseObject:(id)responseObject
{
    NSArray* entities = [super entitiesParsedFromResponseObject:responseObject];
    // 重新分组
//    RCNodeEntity* o = nil;
//    for (NSUInteger i = 0; i < entities.count; i++) {
//        o = entities[i];
//    }
    return entities;
}

@end
