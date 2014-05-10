//
//  RCReplyModel.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCReplyModel.h"
#import "RCAPIClient.h"
#import "AFHTTPRequestOperation.h"

@implementation RCReplyModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)old_replyTopicId:(unsigned long)topicId
            body:(NSString*)body
             success:(void(^)())success
             failure:(void(^)(NSError *error))failure
{
#if 0
    // 不知道这么为什么不行，下面替代方法临时实现，比较丑陋
    if (body.length) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [RCAPIClient relativePathForReplyTopicId:topicId];
        [[RCAPIClient sharedClient] postPath:path parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"%@", responseObject);
                                         success();
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                         failure(error);
                                     }];
    }
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)replyTopicId:(unsigned long)topicId
            body:(NSString*)body
             success:(void(^)(RCReplyEntity* replyEntity))success
             failure:(void(^)(NSError* error))failure
{
#warning "to use af2.0"
#if 0
    // 参考：http://stackoverflow.com/questions/9562459/afnetworking-posting-malformed-json-single-quotes-and-object-refs
    if (body.length) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [RCAPIClient relativePathForReplyTopicId:topicId];
        NSError *error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HOST_API_URL]];
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
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

            NSLog(@"Response: %@", responseString);
            NSError *error = nil;
            id responseJSON  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            if ([responseJSON isKindOfClass:[NSDictionary class]]) {
                RCReplyEntity* replyEntity = [RCReplyEntity entityWithDictionary:responseJSON];
                if (replyEntity) {
                    success(replyEntity);
                    return;
                }
                else {
                    NSLog(@"error:%@", error);
                }
            }
            failure(nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //{NSLocalizedRecoverySuggestion={"error":["回复内容 请勿回复无意义的内容，如你想收藏或赞这篇帖子，请用帖子后面的功能。"]},
            //TODO:准确返回发送失败提示
            failure(nil);
        }];
        [operation start];
    }
#endif
}
@end
