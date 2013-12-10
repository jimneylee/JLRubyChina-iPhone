//
//  RCReplyEntity.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
#import "RCUserEntity.h"

@interface RCReplyEntity : JLNimbusEntity
@property (nonatomic, strong) RCUserEntity* user;
@property (nonatomic, copy) NSString* replyId;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, strong) NSDate* createdAtDate;
@property (nonatomic, strong) NSDate* updatedAtDate;
@property (nonatomic, assign) NSUInteger floorNumber;
@property (nonatomic, copy) NSString* floorNumberString;

@end
