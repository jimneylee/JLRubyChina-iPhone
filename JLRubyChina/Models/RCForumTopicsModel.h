//
//  RCForumTopicsModel.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCBaseTableModel.h"

@interface RCForumTopicsModel : RCBaseTableModel
@property (nonatomic, assign) RCForumTopicsType topicsType;
@property (nonatomic, copy) NSString* nodeName;
@property (nonatomic, assign) NSUInteger nodeId;
@property (nonatomic, copy) NSString* loginId;
@end
