//
//  RCSiteEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCSiteEntity.h"

@implementation RCSiteEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.name = dic[JSON_NAME];
        self.url = dic[JSON_URL];
        self.iconUrl = dic[JSON_FAV_ICON];
        self.description = dic[JSON_DESCRIPTION];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCSiteEntity* entity = [[RCSiteEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
