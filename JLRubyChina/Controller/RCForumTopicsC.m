//
//  RCForumTopicsC.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCForumTopicsC.h"
#import "RCForumTopicsModel.h"
#import "RCTopicEntity.h"
#import "RCTopicDetailC.h"

@interface RCForumTopicsC ()
@end

@implementation RCForumTopicsC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTopicsType:(RCForumTopicsType)topicsType
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = [self stringForTopicsType:topicsType];
        ((RCForumTopicsModel*)self.model).topicsType = topicsType;
        self.navigationItem.leftBarButtonItem = [RCGlobalConfig createMenuBarButtonItemWithTarget:self
                                                                                           action:@selector(showLeft:)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNodeName:(NSString*)nodeName nodeId:(NSUInteger)nodeId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = nodeName;
        ((RCForumTopicsModel*)self.model).nodeId = nodeId;
        ((RCForumTopicsModel*)self.model).topicsType = RCForumTopicsType_NodeList;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 添加手势 TODO:这边还需要斟酌
    if (RCForumTopicsType_NodeList != ((RCForumTopicsModel*)self.model).topicsType) {
        [self.revealSideViewController updateViewWhichHandleGestures];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringForTopicsType:(RCForumTopicsType)topicsType
{
    NSString* topicsTypeName = nil;
    switch (topicsType) {
        case RCForumTopicsType_LatestActivity:
            topicsTypeName = @"热门讨论";
            break;
        case RCForumTopicsType_HighQuality:
            topicsTypeName = @"优质帖子";
            break;
        case RCForumTopicsType_NeverReviewed:
            topicsTypeName = @"无人问津";
            break;
        case RCForumTopicsType_LatestCreate:
            topicsTypeName = @"最新创建";
            break;
        default:
            topicsTypeName = @"暂无分类";
            break;
    }
    return topicsTypeName;
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
    return [RCForumTopicsModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[RCTopicEntity class]]) {
                RCTopicEntity* topic = (RCTopicEntity*)object;
                if (topic.topicId > 0) {
                    RCTopicDetailC* c = [[RCTopicDetailC alloc] initWithTopicId:topic.topicId];
                    [self.navigationController pushViewController:c animated:YES];
                }
                else {
                    [RCGlobalConfig showHUDMessage:@"帖子不存在或已被删除！" addedToView:self.view];
                }
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForEmpty
{
    NSString* msg = @"信息为空";
    [RCGlobalConfig showHUDMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForError
{
    NSString* msg = @"抱歉，无法获取信息，请稍后再试！";
    [RCGlobalConfig showHUDMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMssageForLastPage
{
    NSString* msg = @"已是最后一页";
    [RCGlobalConfig showHUDMessage:msg addedToView:self.view];
}

@end
