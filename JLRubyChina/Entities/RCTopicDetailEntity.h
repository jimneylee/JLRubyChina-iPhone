//
//  RCTopicDetailEntity.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicEntity.h"

@interface RCTopicDetailEntity : RCTopicEntity
@property (nonatomic, assign) unsigned long hitsCount;
@property (nonatomic, copy) NSString* body;
@end
