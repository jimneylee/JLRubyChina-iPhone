//
//  RCReplyModel.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCPostModel.h"
#import "RCAPIClient.h"
#import "AFHTTPRequestOperation.h"

@implementation RCPostModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)old_postNewTopicWithTitle:(NSString*)title
                             body:(NSString*)body
                           nodeId:(NSUInteger)nodeId
                          success:(void(^)())success
                          failure:(void(^)(NSError *error))failure
{
    // 不知道这么为什么不行，下面替代方法临时实现，比较丑陋
    if (title.length && body.length && nodeId > 0) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:title forKey:@"title"];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[NSNumber numberWithUnsignedInt:nodeId] forKey:@"node_id"];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [RCAPIClient relativePathForPostNewTopic];
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postNewTopicWithTitle:(NSString*)title
                         body:(NSString*)body
                       nodeId:(NSUInteger)nodeId
                      success:(void(^)())success
                      failure:(void(^)(NSError *error))failure
{
    // 参考：http://stackoverflow.com/questions/9562459/afnetworking-posting-malformed-json-single-quotes-and-object-refs
    if (title.length && body.length && nodeId > 0) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:title forKey:@"title"];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[NSNumber numberWithUnsignedInt:nodeId] forKey:@"node_id"];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [RCAPIClient relativePathForPostNewTopic];
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
