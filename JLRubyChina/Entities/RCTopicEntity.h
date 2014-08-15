//
//  RCTopicEntity.h
//  JLRubyChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
#import "RCUserEntity.h"

@interface RCTopicEntity : JLNimbusEntity

@property (nonatomic, strong) RCUserEntity* user;
@property (nonatomic, assign) unsigned long topicId;
@property (nonatomic, copy) NSString* topicTitle;
@property (nonatomic, assign) NSUInteger nodeId;
@property (nonatomic, copy) NSString* nodeName;
@property (nonatomic, strong) NSDate* createdAtDate;
@property (nonatomic, strong) NSDate* updatedAtDate;
@property (nonatomic, strong) NSDate* repliedAtDate;
@property (nonatomic, assign) unsigned long repliesCount;
@property (nonatomic, strong) RCUserEntity* lastRepliedUser;

@end
