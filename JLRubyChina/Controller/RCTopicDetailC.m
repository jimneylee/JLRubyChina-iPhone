//
//  RCTopicDetailC.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicDetailC.h"
#import "NIAttributedLabel.h"
#import "RCTopicDetailModel.h"
#import "RCReplyEntity.h"
#import "RCTopicBodyView.h"

@interface RCTopicDetailC ()
@property (nonatomic, strong) RCTopicDetailEntity* topicDetailEntity;
@property (nonatomic, strong) RCTopicBodyView* topicBodyView;
@end

@implementation RCTopicDetailC

- (id)initWithTopicId:(unsigned long)topicId
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        ((RCTopicDetailModel*)self.model).topicId = topicId;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTopicHeaderView
{
//    if (!self.tableView.tableHeaderView) {
//        self.topicBodyView = [[RCTopicBodyView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 0.f)];
//        self.tableView.tableHeaderView = self.topicBodyView;
//    }
//    [self.topicBodyView updateViewWithTopicDetailEntity:self.topicDetailEntity];
//    [self.topicBodyView setNeedsLayout];
    
    self.topicBodyView = [[RCTopicBodyView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 0.f)];
    [self.topicBodyView updateViewWithTopicDetailEntity:self.topicDetailEntity];
    [self.topicBodyView layoutIfNeeded];
    self.tableView.tableHeaderView = self.topicBodyView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [RCTopicDetailModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[RCReplyEntity class]]) {
                RCReplyEntity* topic = (RCReplyEntity*)object;
                [RCGlobalConfig showHUDMessage:@"TODO:回复该贴/赞该贴" addedToView:self.view];
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoadData
{
    [super didFinishLoadData];
    self.topicDetailEntity = ((RCTopicDetailModel*)self.model).topicDetailEntity;
    [self updateTopicHeaderView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadData
{
    [super didFailLoadData];
    //[self showTitleHeaderView];
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
