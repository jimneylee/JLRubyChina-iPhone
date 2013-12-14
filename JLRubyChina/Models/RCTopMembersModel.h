//
//  RCCoolSitesModel.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

@interface RCTopMembersModel : NIMutableTableViewModel

@property (nonatomic, strong) NSMutableArray* topMembersArray;
@property (nonatomic, assign) BOOL isLoading;

- (void)loadTopMembersWithBlock:(void(^)(NSArray* topMembersArray, NSError* error))block;
- (void)cancelRequstOperation;

@end
