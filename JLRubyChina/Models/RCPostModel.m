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
- (void)postNewTopicWithTitle:(NSString*)title
                             body:(NSString*)body
                           nodeId:(NSUInteger)nodeId
                          success:(void(^)(RCTopicEntity* topicEntity))success
                          failure:(void(^)(NSError *error))failure
{
    if (title.length && body.length && nodeId > 0) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:title forKey:@"title"];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[NSNumber numberWithUnsignedInt:nodeId] forKey:@"node_id"];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [RCAPIClient relativePathForPostNewTopic];
        [[RCAPIClient sharedClient] POST:path parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                         BOOL successFlag = NO;
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             RCTopicEntity* topicEntity = [RCTopicEntity entityWithDictionary:responseObject];
                                             if (topicEntity) {
                                                 success(topicEntity);
                                                 successFlag = YES;
                                             }
                                         }
                                         
                                         if (!successFlag) {
                                             failure(nil);
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                         failure(error);
                                     }];
    }
}

@end
