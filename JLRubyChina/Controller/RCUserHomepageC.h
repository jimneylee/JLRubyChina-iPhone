//
//  RCTopicDetailC.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "JLNimbusTableViewController.h"

@interface RCUserHomepageC : JLNimbusTableViewController

// only me in left side, my home homepage
- (id)initWithMyLoginId:(NSString*)loginId;

// for anyone include me, can back to privious controller
- (id)initWithUserLoginId:(NSString*)loginId;

@end
