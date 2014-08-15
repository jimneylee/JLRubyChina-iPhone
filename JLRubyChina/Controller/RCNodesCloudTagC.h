//
//  RCForumNodesCloudTagC.h
//  JLRubyChina
//
//  Created by jimneylee on 13-12-13.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCNodeEntity.h"

@protocol RCNodesCloudTagDelegate;
@interface RCNodesCloudTagC : UIViewController
@property (nonatomic, assign) id<RCNodesCloudTagDelegate>delegate;
@end

@protocol RCNodesCloudTagDelegate <NSObject>

@optional
- (void)didSelectANode:(RCNodeEntity*)nodeEntity;

@end