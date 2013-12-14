//
//  RCUserEntity.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCUserEntity.h"

@interface RCUserFullEntity : RCUserEntity
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* location;
@property (nonatomic, copy) NSString* company;
@property (nonatomic, copy) NSString* twitter;
@property (nonatomic, copy) NSString* website;
@property (nonatomic, copy) NSString* introduce;
@property (nonatomic, copy) NSString* tagline;
@property (nonatomic, copy) NSString* githubUrl;
@property (nonatomic, copy) NSString* email;
@end
