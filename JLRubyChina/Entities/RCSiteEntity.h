//
//  RCSiteEntity.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface RCSiteEntity : JLNimbusEntity
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* iconUrl;
@property (nonatomic, copy) NSString* description;
@end
