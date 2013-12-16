//
//  RCTopicActionModel.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RCTopicActionType) {
    RCTopicActionType_Follow,
    RCTopicActionType_Unfollow,
    RCTopicActionType_Favorite
};

@interface RCTopicActionModel : NSObject

- (void)followTopicId:(unsigned long)topicId
              success:(void(^)())success
              failure:(void(^)(NSError *error))failure;

- (void)unfollowTopicId:(unsigned long)topicId
                success:(void(^)())success
                failure:(void(^)(NSError *error))failure;

- (void)favoriteTopicId:(unsigned long)topicId
                success:(void(^)())success
                failure:(void(^)(NSError *error))failure;

@end
