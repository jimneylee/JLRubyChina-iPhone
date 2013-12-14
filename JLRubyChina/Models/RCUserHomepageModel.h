//
//  RCTopicDetailModel.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCBaseTableModel.h"
#import "RCUserFullEntity.h"

@interface RCUserHomepageModel : RCBaseTableModel
@property (nonatomic, copy) NSString* loginId;
@property (nonatomic, strong) RCUserFullEntity* userEntity;//TODO:replace with RCUserFullEntity
@end
