//
//  RCUserEntity.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface RCAccountEntity : JLNimbusEntity
@property (nonatomic, copy) NSString* loginId;// 用户注册时，用户自己输入的ID号，api接口均使用这个id
@property (nonatomic, copy) NSString* privateToken;

+ (RCAccountEntity*)loadStoredUserAccount;

+ (void)storePrivateToken:(NSString*)privateToken forLoginId:(NSString*)loginId;
+ (void)deleteLoginedUserDiskData;

+ (void)storeLoginId:(NSString*)loginId;
+ (NSString*)readLoginId;
+ (void)deleteLoginId;

+ (NSString*)readPrivateToken;
+ (void)deletePrivateToken;

@end
