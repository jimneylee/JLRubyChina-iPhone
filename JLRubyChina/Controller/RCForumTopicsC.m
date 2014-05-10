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
#import "RCPostC.h"

@interface RCForumTopicsC ()<RCPostDelegate>
@property (nonatomic, assign) RCForumTopicsType topicsType;
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
        self.topicsType = topicsType;
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:
         [RCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                       action:@selector(autoPullDownRefreshActionAnimation)],
         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                       target:self action:@selector(postNewTopicAction)],
                                nil];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNodeName:(NSString*)nodeName nodeId:(NSUInteger)nodeId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = nodeName;
        self.topicsType = RCForumTopicsType_NodeList;
        ((RCForumTopicsModel*)self.model).nodeId = nodeId;
        ((RCForumTopicsModel*)self.model).topicsType = self.topicsType;
        self.navigationItem.rightBarButtonItem = [RCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(autoPullDownRefreshActionAnimation)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUserLoginId:(NSString*)loginId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = loginId;
        self.topicsType = RCForumTopicsType_UserPosted;
        ((RCForumTopicsModel*)self.model).loginId = loginId;
        ((RCForumTopicsModel*)self.model).topicsType = self.topicsType;
        self.navigationItem.rightBarButtonItem = [RCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(autoPullDownRefreshActionAnimation)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initForFavoritedWithUserLoginId:(NSString*)loginId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = loginId;
        self.topicsType = RCForumTopicsType_UserFavorited;
        ((RCForumTopicsModel*)self.model).loginId = loginId;
        ((RCForumTopicsModel*)self.model).topicsType = self.topicsType;
        self.navigationItem.rightBarButtonItem = [RCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(autoPullDownRefreshActionAnimation)];
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
- (void)postNewTopicAction
{
    if ([RCGlobalConfig myToken].length) {
        RCPostC* postC = [[RCPostC alloc] initWithStyle:UITableViewStyleGrouped];
        postC.postDelegate = self;
        [self.navigationController pushViewController:postC animated:YES];
    }
    else {
        [RCGlobalConfig showLoginControllerFromNavigationController:self.navigationController];
    }
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
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
        if ([object isKindOfClass:[RCTopicEntity class]]) {
            RCTopicEntity* topic = (RCTopicEntity*)object;
            if (topic.topicId > 0) {
                RCTopicDetailC* c = [[RCTopicDetailC alloc] initWithTopicId:topic.topicId];
                [self.navigationController pushViewController:c animated:YES];
            }
            else {
                [RCGlobalConfig HUDShowMessage:@"帖子不存在或已被删除！" addedToView:self.view];
            }
        }
        return YES;
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForEmpty
{
    NSString* msg = @"信息为空";
    [RCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForError
{
    NSString* msg = @"抱歉，无法获取信息！";
    [RCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMssageForLastPage
{
    NSString* msg = @"已是最后一页";
    [RCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SNPostCDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPostNewTopic
{
    if (RCForumTopicsType_LatestActivity == self.topicsType) {
        [self autoPullDownRefreshActionAnimation];
    }
}

@end
