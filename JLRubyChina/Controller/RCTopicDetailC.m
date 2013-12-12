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
#import "RCReplyModel.h"
#import "RCQuickReplyC.h"

@interface RCTopicDetailC ()
@property (nonatomic, strong) RCTopicDetailEntity* topicDetailEntity;
@property (nonatomic, strong) RCTopicBodyView* topicBodyView;
@property (nonatomic, strong) RCQuickReplyC* quickReplyC;
@property (nonatomic, strong) UIButton* scrollBtn;
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
        self.title = @"浏览帖子";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                                               target:self action:@selector(replyTopicAction)];
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
    
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    self.scrollBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    self.scrollBtn.backgroundColor = RGBACOLOR(0, 0, 0, 0.6f);
    self.scrollBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30.f];
    self.scrollBtn.titleLabel.textColor = [UIColor whiteColor];
    self.scrollBtn.right = keyWindow.width - CELL_PADDING_8;
    self.scrollBtn.bottom = keyWindow.height - CELL_PADDING_8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.quickReplyC.textView resignFirstResponder];
    if (self.quickReplyC.view.superview) {
        [self.quickReplyC.view removeFromSuperview];
    }
    if (self.scrollBtn.superview) {
        [self.scrollBtn removeFromSuperview];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTopicHeaderView
{
    if (!_topicBodyView) {
        _topicBodyView = [[RCTopicBodyView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 0.f)];
    }
    [self.topicBodyView updateViewWithTopicDetailEntity:self.topicDetailEntity];
    // call layoutSubviews at first to calculte view's height, dif from setNeedsLayout
    [self.topicBodyView layoutIfNeeded];
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = self.topicBodyView;
    }
}

- (void)replyTopicAction
{
    // each time addSubview to keyWidow, otherwise keyborad is not showed, sorry, so dirty!
    [[UIApplication sharedApplication].keyWindow addSubview:_quickReplyC.view];
    self.quickReplyC.textView.internalTextView.inputAccessoryView = self.quickReplyC.view;

    // call becomeFirstResponder, I donot know why
    // maybe because textview is in superview(self.quickReplyC.view)
    [self.quickReplyC.textView.internalTextView becomeFirstResponder];
    [self.quickReplyC.textView.internalTextView becomeFirstResponder];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (RCQuickReplyC*)quickReplyC
{
    if (!_quickReplyC) {
        _quickReplyC = [[RCQuickReplyC alloc] initWithTopicId:((RCTopicDetailModel*)self.model).topicId];
        // setting the first responder view of the table but we don't know its type (cell/header/footer)
        // [self.view addSubview:_quickReplyC.view];
        // so mush show it in keywindow same to keyborad :)
        [[UIApplication sharedApplication].keyWindow addSubview:_quickReplyC.view];
    }
    return _quickReplyC;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)replyTopicWithFloorAtSomeone:(NSString*)floorAtsomeoneString
{
    [self.quickReplyC appendString:floorAtsomeoneString];
    [self replyTopicAction];
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
                [RCGlobalConfig hudShowMessage:@"TODO:回复该贴/赞该贴" addedToView:self.view];
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
    [RCGlobalConfig hudShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForError
{
    NSString* msg = @"抱歉，无法获取信息，请稍后再试！";
    [RCGlobalConfig hudShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMssageForLastPage
{
    // no page
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
// 显示跳到底部和顶部
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (!self.scrollBtn.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.scrollBtn];
        if (velocity.y > 0.f) {
            [self.scrollBtn setTitle:@"↓" forState:UIControlStateNormal];
        }
        else {
            [self.scrollBtn setTitle:@"↑" forState:UIControlStateNormal];
        }
        [self.scrollBtn performSelector:@selector(removeFromSuperview) withObject:Nil afterDelay:2.0f];
    }
}

@end
