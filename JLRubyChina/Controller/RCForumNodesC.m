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
        self.title = @"分类导航";
        self.navigationItem.leftBarButtonItem = [RCGlobalConfig createMenuBarButtonItemWithTarget:self
                                                                                           action:@selector(showLeft:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    self.tableView.separatorColor = [UIColor lightGrayColor];
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
#pragma mark Side View Controller

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLeft:(id)sender
{
    // used to push a new controller, but we preloaded it !
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft
                                                         withOffset:SIDE_DIRECTION_LEFT_OFFSET
                                                           animated:YES];
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
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
        if (!self.editing) {
            if ([object isKindOfClass:[RCNodeEntity class]]) {
                RCNodeEntity* entity = (RCNodeEntity*)object;
                RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithNodeName:entity.nodeName
                                                                      nodeId:entity.nodeId];
                [self.navigationController pushViewController:c animated:YES];
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

@end
