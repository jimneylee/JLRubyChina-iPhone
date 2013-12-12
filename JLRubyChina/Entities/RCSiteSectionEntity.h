//
//  RCSiteSectionEntity.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface RCSiteSectionEntity : JLNimbusEntity
@property (nonatomic, assign) NSUInteger sectionId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSArray* sitesArray;
@end
