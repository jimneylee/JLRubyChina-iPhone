//
//  RCCoolSitesModel.h
//  JLRubyChina
//
//  Created by jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

@interface RCCoolSitesModel : NIMutableTableViewModel
@property (nonatomic, strong) NSMutableArray* siteSectionsArray;
@property (nonatomic, assign) BOOL isLoading;
- (Class)objectClass;
- (Class)cellClass;
- (void)loadCoolSitesWithBlock:(void(^)(NSArray* siteSectionsArray, NSError* error))block;
- (void)cancelRequstOperation;
@end
