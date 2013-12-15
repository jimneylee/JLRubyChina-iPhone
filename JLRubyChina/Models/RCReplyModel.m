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

- (void)old_replyTopicId:(unsigned long)topicId
            body:(NSString*)body
             success:(void(^)())success
             failure:(void(^)(NSError *error))failure
{
    // 不知道这么为什么不行，下面替代方法临时实现，比较丑陋
    if (body.length) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[RCGlobalConfig myLoginId] forKey:@"token"];
        
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
}

- (void)replyTopicId:(unsigned long)topicId
            body:(NSString*)body
             success:(void(^)())success
             failure:(void(^)(NSError *error))failure
{
    // 参考：http://stackoverflow.com/questions/9562459/afnetworking-posting-malformed-json-single-quotes-and-object-refs
    if (body.length) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[RCGlobalConfig myLoginId] forKey:@"token"];
        
        NSString* path = [RCAPIClient relativePathForReplyTopicId:topicId];
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
