//
//  RCNodeEntity.h
//  JLRubyChina
//
//  Created by jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
//{
//    "id": 1,
//    "name": "Ruby",
//    "topics_count": 1288,
//    "summary": "Ruby 鏄竴闂ㄤ紭缇庣殑璇█",
//    "section_id": 1,
//    "sort": 0,
//    "section_name": "Ruby"
//},
@interface RCNodeEntity : JLNimbusEntity
@property (nonatomic, assign) NSUInteger nodeId;
@property (nonatomic, copy) NSString* nodeName;
@property (nonatomic, copy) NSString* summary;
@property (nonatomic, assign) unsigned long topicsCount;
@property (nonatomic, assign) NSUInteger sectionId;
@property (nonatomic, copy) NSString* sectionName;
@end
