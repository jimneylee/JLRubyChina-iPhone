//
//  RCForumNodesC.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCForumNodesC.h"
#import "RCForumNodesModel.h"
#import "RCNodeEntity.h"
#import "RCForumTopicsC.h"

@interface RCForumNodesC ()

@end

@implementation RCForumNodesC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [RCForumNodesModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[RCNodeEntity class]]) {
                RCNodeEntity* entity = (RCNodeEntity*)object;
                RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithNodeName:entity.nodeName
                                                                      nodeId:entity.nodeId];
                [self.navigationController pushViewController:c animated:YES];
//                if ([self.trendsDelegate respondsToSelector:@selector(didSelectATrend:)]) {
//                    [self.trendsDelegate didSelectATrend:[entity getNameWithSharp]];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

@end
