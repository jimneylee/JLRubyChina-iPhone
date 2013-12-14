//
//  RCSiteSectionEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCSiteSectionEntity.h"
#import "RCSiteEntity.h"

@implementation RCSiteSectionEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.sectionId = [dic[JSON_SITE_SECTION_ID] unsignedIntegerValue];
        self.name = dic[JSON_NAME];
        NSArray* sourceSitesArray = dic[JSON_SITES_LIST];
        if (sourceSitesArray.count) {
            NSMutableArray* sitesArray = [NSMutableArray arrayWithCapacity:sourceSitesArray.count];
            RCSiteEntity* s = nil;
            for (NSDictionary* dic in sourceSitesArray) {
                s = [RCSiteEntity entityWithDictionary:dic];
                [sitesArray addObject:s];
            }
            self.sitesArray = sitesArray;
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCSiteSectionEntity* entity = [[RCSiteSectionEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
