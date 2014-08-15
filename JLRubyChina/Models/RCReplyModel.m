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
- (void)replyTopicId:(unsigned long)topicId
            body:(NSString*)body
             success:(void(^)(RCReplyEntity* replyEntity))success
             failure:(void(^)(NSError *error))failure
{
    if (body.length) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:body forKey:@"body"];
        [parameters setObject:[RCGlobalConfig myToken] forKey:@"token"];
        
        NSString* path = [RCAPIClient relativePathForReplyTopicId:topicId];
        [[RCAPIClient sharedClient] POST:path parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         BOOL successFlag = NO;
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             RCReplyEntity* replyEntity = [RCReplyEntity entityWithDictionary:responseObject];
                                             if (replyEntity) {
                                                 success(replyEntity);
                                                 successFlag = YES;
                                             }
                                         }
                                         
                                         if (!successFlag) {
                                             failure(nil);
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         failure(error);
                                     }];
    }
}

@end
