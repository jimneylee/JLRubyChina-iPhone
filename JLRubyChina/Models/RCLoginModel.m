//
//  SNLoginModel.m
//  SkyNet
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
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ruby-china.org/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    [httpClient postPath:path parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         RCAccountEntity* user = [RCAccountEntity entityWithDictionary:responseObject];
                                         [RCAccountEntity storePrivateToken:user.privateToken forLoginId:user.loginId];
                                         if (block) {
                                             block(user, nil);
                                         }
                                     }
                                     else {
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             NSDictionary* dic = (NSDictionary*)responseObject;
                                             NSString* msg = dic[@"message"];
                                             NSLog(@"message = %@", msg);
                                         }
                                         if (block) {
                                             NSError* error = [[NSError alloc] init];
                                             block(nil, error);
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (block) {
                                         block(nil, error);
                                     }
                                 }];
}

@end
