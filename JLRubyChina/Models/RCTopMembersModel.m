//
//  RCCoolSitesModel.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCTopMembersModel.h"
#import "RCAPIClient.h"
#import "RCUserEntity.h"

@implementation RCTopMembersModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    // 暂时未分页
    return [RCAPIClient relativePathForTopMembersWithPageCounter:0 perpageCount:0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadTopMembersWithBlock:(void(^)(NSArray* siteSectionsArray, NSError* error))block
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
                                            RCUserEntity* user = nil;
                                            NSMutableArray* topMembersArray = [NSMutableArray arrayWithCapacity:sourceArray.count];
                                            for (NSDictionary* dic in sourceArray) {
                                                user = [RCUserEntity entityWithDictionary:dic];
                                                [topMembersArray addObject:user];
                                            }
                                            self.topMembersArray = topMembersArray;
                                            if (block) {
                                                block(topMembersArray, nil);
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
