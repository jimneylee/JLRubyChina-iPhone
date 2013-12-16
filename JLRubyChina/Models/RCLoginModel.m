//
//  RCLoginModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCLoginModel.h"
#import "RCAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "NSDataAdditions.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCLoginModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(RCAccountEntity* user, NSError *error))block
{
    NSString* path = [RCAPIClient relativePathForSignIn];
    
    // 由于登录的接口与其他接口base_url不太一样，后台没有放到api路径下，故单独处理
    // ruby-china.org/account/sign_in.json
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ruby-china.org/"]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient postPath:path parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         RCAccountEntity* account = [RCAccountEntity entityWithDictionary:responseObject];
                                         [RCGlobalConfig setMyLoginId:account.loginId];
                                         [RCGlobalConfig setMyToken:account.privateToken];
                                         [RCAccountEntity storePrivateToken:account.privateToken forLoginId:account.loginId];
                                         if (block) {
                                             block(account, nil);
                                         }
                                     }
                                     else {
                                         if (block) {
                                             NSError* error = [[NSError alloc] init];
                                             block(nil, error);
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSDictionary* info = [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                                     NSLog(@"error: %@", info[@"error"]);
                                     NSLog(@"error: %@", error);
                                     if (block) {
                                         block(nil, error);
                                     }
                                 }];
}

@end
