//
//  RCForumTopicsC.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusTableViewController.h"

@interface RCForumTopicsC : JLNimbusTableViewController
- (id)initWithTopicsType:(RCForumTopicsType)topicsType;
- (id)initWithNodeName:(NSString*)nodeName nodeId:(NSUInteger)nodeId;
@end
