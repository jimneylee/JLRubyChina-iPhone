//
//  RCReplyModel.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCReplyEntity.h"

@interface RCReplyModel : NSObject
- (void)replyTopicId:(unsigned long)topicId
            body:(NSString*)body
             success:(void(^)(RCReplyEntity* replyEntity))success
             failure:(void(^)(NSError *error))failure;
@end
