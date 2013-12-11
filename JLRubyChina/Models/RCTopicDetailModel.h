//
//  RCTopicDetailModel.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCBaseTableModel.h"
#import "RCTopicDetailEntity.h"

@interface RCTopicDetailModel : RCBaseTableModel
@property (nonatomic, assign) unsigned long topicId;
@property (nonatomic, strong) RCTopicDetailEntity* topicDetailEntity;
@end
