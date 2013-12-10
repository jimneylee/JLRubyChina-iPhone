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
    // TODO: set type
    return [RCAPIClient relativePathForTopicsWithPageCounter:self.pageCounter
                                                perpageCount:self.perpageCount];
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
