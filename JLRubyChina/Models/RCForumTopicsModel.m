//
//  RCForumTopicsModel.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCForumTopicsModel.h"
#import "RCAPIClient.h"
#import "RCTopicCell.h"
#import "RCTopicEntity.h"

@interface RCForumTopicsModel()

@end

@implementation RCForumTopicsModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path = nil;
    switch (self.topicsType) {
        case RCForumTopicsType_LatestActivity:
            path = [RCAPIClient relativePathForTopicsWithPageCounter:self.pageCounter
                                                        perpageCount:self.perpageCount];
            break;
        case RCForumTopicsType_NodeList:
            path = [RCAPIClient relativePathForTopicsWithNodeId:self.nodeId
                                                    PageCounter:self.pageCounter
                                                   perpageCount:self.perpageCount];
            break;
            
        case RCForumTopicsType_UserPosted:
            path = [RCAPIClient relativePathForTopicsWithUserLoginId:self.loginId
                                                         pageCounter:self.pageCounter
                                                        perpageCount:self.perpageCount];
            break;
            
        default:
            break;
    }
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [RCTopicEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [RCTopicCell class];
}

@end
