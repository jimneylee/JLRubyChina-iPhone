//
//  RCCoolSitesModel.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCCoolSitesModel.h"
#import "RCAPIClient.h"
#import "RCSiteSectionEntity.h"
#import "RCSiteEntity.h"
#import "RCSiteCell.h"

@implementation RCCoolSitesModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self)
	{
        if (delegate && [delegate isKindOfClass:[NICellFactory class]]) {
            NICellFactory* factory = (NICellFactory*)delegate;
            NIDASSERT([self objectClass]);
            NIDASSERT([self cellClass]);
            [factory mapObjectClass:[self objectClass]
                        toCellClass:[self cellClass]];
        }
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [RCAPIClient relativePathForCoolSites];//tid = @"111837"
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [RCSiteEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [RCSiteCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadCoolSitesWithBlock:(void(^)(NSArray* siteSectionsArray, NSError* error))block
{
    if (self.isLoading) {
        return;
    }
    else {
        self.isLoading = YES;
    }
    [[RCAPIClient sharedClient] getPath:[self relativePath] parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    self.isLoading = NO;
                                    if ([responseObject isKindOfClass:[NSArray class]]) {
                                        NSArray* sourceArray = (NSArray*)responseObject;
                                        if (sourceArray.count) {
                                            RCSiteSectionEntity* sectionEntity = nil;
                                            NSMutableArray* siteSectionsArray = [NSMutableArray arrayWithCapacity:sourceArray.count];
                                            for (NSDictionary* dic in sourceArray) {
                                                sectionEntity = [RCSiteSectionEntity entityWithDictionary:dic];
                                                [siteSectionsArray addObject:sectionEntity];
                                            }
                                            self.siteSectionsArray = siteSectionsArray;
                                            if (block) {
                                                block(siteSectionsArray, nil);
                                                return;
                                            }
                                        }
                                    }
                                    if (block) {
                                        NSError* error = [[NSError alloc] init];
                                        block(nil, error);
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
        [[RCAPIClient sharedClient] cancelAllHTTPOperationsWithMethod:@"GET" path:[self relativePath]];
        self.isLoading = NO;
    }
}

@end
