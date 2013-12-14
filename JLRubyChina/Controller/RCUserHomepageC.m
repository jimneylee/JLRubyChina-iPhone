//
//  RCTopicDetailC.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCUserHomepageC.h"
#import "RCUserEntity.h"
#import "RCHomepageHeaderView.h"
#import "RCUserHomepageModel.h"
#import "RCTopicEntity.h"
#import "RCTopicDetailC.h"
#import "RCForumTopicsC.h"

@interface RCUserHomepageC ()
@property (nonatomic, strong) RCHomepageHeaderView* homepageHeaderView;
@end

@implementation RCUserHomepageC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUserLoginId:(NSString*)loginId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        ((RCUserHomepageModel*)self.model).loginId = loginId;
        self.title = loginId;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [RCGlobalConfig createMenuBarButtonItemWithTarget:self
                                                                                           action:@selector(showLeft:)];
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTopicHeaderView
{
    if (!_homepageHeaderView) {
        _homepageHeaderView = [[RCHomepageHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 0.f)];
    }
    [self.homepageHeaderView updateViewWithHomepageUser:((RCUserHomepageModel*)self.model).userEntity];
    // call layoutSubviews at first to calculte view's height, dif from setNeedsLayout
    [self.homepageHeaderView layoutIfNeeded];
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = self.homepageHeaderView;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createViewMoreFooterView
{
    if (!self.tableView.tableFooterView) {
        UIButton* viewMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.f)];
        [viewMoreBtn setTitle:@"查看更多帖子" forState:UIControlStateNormal];
        [viewMoreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [viewMoreBtn addTarget:self action:@selector(viewMoreTopicsAction)
              forControlEvents:UIControlEventTouchUpInside];
        viewMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        viewMoreBtn.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = viewMoreBtn;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewMoreTopicsAction
{
    RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithUserLoginId:((RCUserHomepageModel*)self.model).userEntity.loginId];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [RCUserHomepageModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
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
- (void)didFinishLoadData
{
    [super didFinishLoadData];
    
    [self updateTopicHeaderView];
    [self createViewMoreFooterView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadData
{
    [super didFailLoadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForEmpty
{
    NSString* msg = @"还没有评论，赶快参与吧！";
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
    // no page
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

@end
