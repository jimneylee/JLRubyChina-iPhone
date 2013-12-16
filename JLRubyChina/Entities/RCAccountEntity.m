//
//  RCAccountEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCAccountEntity.h"
#import "SSKeychain.h"

NSString* kRubyChinaService = @"RubyChinaService";
NSString* kLoginId = @"LoginId";

//{
//    avatar =     {
//        big =         {
//            url = "photo/big.jpg";
//        };
//        large =         {
//            url = "photo/large.jpg";
//        };
//        normal =         {
//            url = "photo/normal.jpg";
//        };
//        small =         {
//            url = "photo/small.jpg";
//        };
//        url = "photo/.jpg";
//    };
//    email = "jimneylee@gmail.com";
//    login = jimneylee;
//    "private_token" = "8a67b1e1042c8093f709:4988";
//}
@implementation RCAccountEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.loginId = dic[JSON_LOGIN];
        self.privateToken = dic[JSON_PRIVATE_TOKEN];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCAccountEntity* entity = [[RCAccountEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load & Delete logined user

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (RCAccountEntity*)loadStoredUserAccount
{
    NSString* loginId = [RCAccountEntity readLoginId];
    NSString* privateToken = [RCAccountEntity readPrivateToken];
    if (loginId && privateToken) {
        RCAccountEntity* user = [[RCAccountEntity alloc] init];
        user.loginId = loginId;
        user.privateToken = privateToken;
        return user;
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteLoginedUserDiskData
{
    [RCAccountEntity deletePrivateToken];
    [RCAccountEntity deleteLoginId];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Store & Read login id
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storeLoginId:(NSString*)loginId
{
    [[NSUserDefaults standardUserDefaults] setObject:loginId forKey:kLoginId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readLoginId
{
    NSString* LoginedLoginId = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginId];
    return LoginedLoginId;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteLoginId
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Store & Read private token

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storePrivateToken:(NSString*)privateToken forLoginId:(NSString*)loginId
{
    NSError *error = nil;
    BOOL success = [SSKeychain setPassword:privateToken
                                forService:kRubyChinaService
                                   account:loginId error:&error];
    if (!success || error) {
        NSLog(@"can NOT store account");
    }
    else {
        [RCAccountEntity storeLoginId:loginId];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readPrivateToken
{
    NSString* LoginedLoginId = [RCAccountEntity readLoginId];
    NSString* password = [SSKeychain passwordForService:kRubyChinaService
                                                account:LoginedLoginId];
    return password;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deletePrivateToken
{
    NSString* LoginedLoginId = [RCAccountEntity readLoginId];
    [SSKeychain deletePasswordForService:kRubyChinaService account:LoginedLoginId];
}

@end
