//
//  RCForumNodesModel.h
//  JLRubyChina
//
//  Created by jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCBaseTableModel.h"

@interface RCForumNodesModel : NIMutableTableViewModel

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSArray* nodesArray;

@property (nonatomic, strong) NSMutableArray* nodeSectionsArray;
- (Class)objectClass;
- (Class)cellClass;
- (void)loadNodesWithBlock:(void(^)(NSArray* nodeSectionsArray, NSError *error))block;
- (void)cancelRequstOperation;

@end
