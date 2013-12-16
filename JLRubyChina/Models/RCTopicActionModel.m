//
//  RCTopicActionModel.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicActionModel.h"
#import "RCAPIClient.h"
#import "AFHTTPRequestOperation.h"

@implementation RCTopicActionModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePathWithTopicId:(unsigned long)topicId actionType:(RCTopicActionType)actionType
{
    NSString* path = nil;
    switch (actionType) {
        case RCTopicActionType_Follow:
            path = [RCAPIClient relativePathForFollowTopicId:topicId];
            break;
        
        case RCTopicActionType_Unfollow:
            path = [RCAPIClient relativePathForUnfollowTopicId:topicId];
            break;
            
        case RCTopicActionType_Favorite:
            path = [RCAPIClient relativePathForFavoriteTopicId:topicId];
            break;
            
        default:
            break;
    }
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)followTopicId:(unsigned long)topicId
                success:(void(^)())success
                failure:(void(^)(NSError *error))failure
{
    [self doActionWithTopicId_json_response:topicId actionType:RCTopicActionType_Follow
                      success:success failure:failure];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unfollowTopicId:(unsigned long)topicId
              success:(void(^)())success
              failure:(void(^)(NSError *error))failure
{
    [self doActionWithTopicId_json_response:topicId actionType:RCTopicActionType_Unfollow
                      success:success failure:failure];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)favoriteTopicId:(unsigned long)topicId
                success:(void(^)())success
                failure:(void(^)(NSError *error))failure
{
    [self doActionWithTopicId:topicId actionType:RCTopicActionType_Favorite
                      success:success failure:failure];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 返回的是json数据 => follow unfollow，不同于favorite，DT!:(
- (void)doActionWithTopicId_json_response:(unsigned long)topicId
                 actionType:(RCTopicActionType)actionType
                    success:(void(^)())success
                    failure:(void(^)(NSError *error))failure
{
    if (topicId > 0) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [self relativePathWithTopicId:topicId actionType:actionType];
        [[RCAPIClient sharedClient] postPath:path parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"%@", responseObject);
                                         success();
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         // TODO: 已关注，返回不是json，建议后台统一处理
                                         // (JSON text did not start with array or object and option to allow fragments not set.)
                                         NSLog(@"%@", error);
                                         failure(error);
                                     }];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 返回是ture or false => favorite
- (void)doActionWithTopicId:(unsigned long)topicId
                 actionType:(RCTopicActionType)actionType
             success:(void(^)())success
             failure:(void(^)(NSError *error))failure
{
    // 参考：http://stackoverflow.com/questions/9562459/afnetworking-posting-malformed-json-single-quotes-and-object-refs
    if (topicId > 0) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [self relativePathWithTopicId:topicId actionType:actionType];
        NSError *error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:path
                                                          parameters:nil];
        NSMutableData *body = [NSMutableData data];
        [body appendData:jsonData];
        [request setHTTPBody:body];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* resultString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", resultString);
            if ([resultString isEqualToString:@"true"]) {
                success();
            }
            else {
                failure(nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure(nil);
        }];
        [operation start];
    }
}
@end
