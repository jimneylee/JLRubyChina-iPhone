//
//  RCUserEntity.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface RCUserEntity : JLNimbusEntity
@property (nonatomic, assign) unsigned long hashId;//注册后，服务器后台自动分配的hash值
@property (nonatomic, copy) NSString* loginId;// 用户注册时，用户自己输入的ID号，api接口均使用这个id
@property (nonatomic, copy) NSString* avatarUrl;
@end
