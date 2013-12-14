//
//  SMPublicTimelineModel.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopMembersModel.h"
#import "RCUserEntity.h"
#import "RCUserCell.h"

@implementation RCTopMembersModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        // TODO:数据一次性获取过来，没有分页，后面建议后台做分页
        self.perpageCount = NSIntegerMax;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [RCAPIClient relativePathForTopMembersWithPageCounter:self.pageCounter
                                                    perpageCount:self.perpageCount];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [RCUserEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [RCUserCell class];
}

@end
