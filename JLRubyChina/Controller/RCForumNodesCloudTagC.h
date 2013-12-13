//
//  RCForumNodesCloudTagC.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-13.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCNodeEntity.h"

@protocol RCForumNodesCloudTagDelegate;
@interface RCForumNodesCloudTagC : UIViewController
@property (nonatomic, assign) id<RCForumNodesCloudTagDelegate>delegate;
@end

@protocol RCForumNodesCloudTagDelegate <NSObject>

@optional
- (void)didSelectANode:(RCNodeEntity*)nodeEntity;

@end