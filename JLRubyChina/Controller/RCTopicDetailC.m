//
//  RCTopicDetailC.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicDetailC.h"
#import "RCTopicDetailModel.h"
#import "RCReplyEntity.h"
#import "RCTopicBodyView.h"
#import "RCReplyModel.h"
#import "RCQuickReplyC.h"

#define SCROLL_DIRECTION_BOTTOM_TAG 1000
#define SCROLL_DIRECTION_UP_TAG 1001

@interface RCTopicDetailC ()<RCQuickReplyDelegate>
@property (nonatomic, strong) RCTopicDetailEntity* topicDetailEntity;
@property (nonatomic, strong) RCTopicBodyView* topicBodyView;
@property (nonatomic, strong) RCQuickReplyC* quickReplyC;
@property (nonatomic, strong) UIButton* scrollBtn;
@end

@implementation RCTopicDetailC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTopicId:(unsigned long)topicId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        ((RCTopicDetailModel*)self.model).topicId = topicId;
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"浏览帖子";
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:
         [RCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                       action:@selector(autoPullDownRefreshActionAnimation)],
         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                       target:self action:@selector(replyTopicAction)],
         nil];
        // cell not selectable, also cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.actions attachToClass:[self.model objectClass] tapBlock:nil/*self.tapAction*/];
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
    
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    self.scrollBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    self.scrollBtn.backgroundColor = RGBACOLOR(0, 0, 0, 0.6f);
    self.scrollBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30.f];
    self.scrollBtn.titleLabel.textColor = [UIColor whiteColor];
    self.scrollBtn.centerX = keyWindow.width / 2;
    self.scrollBtn.bottom = keyWindow.height - CELL_PADDING_8;
    [self.scrollBtn addTarget:self action:@selector(scrollToBottomOrTopAction)
             forControlEvents:UIControlEventTouchUpInside];
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
    if ([self.quickReplyC.textView isFirstResponder]) {
        [self.quickReplyC.textView resignFirstResponder];
    }
    if (self.quickReplyC.view.superview) {
        [self.quickReplyC.view removeFromSuperview];
    }
    if (self.scrollBtn.superview) {
        [self.scrollBtn removeFromSuperview];
    }
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)replyTopicAction
{
    if ([RCGlobalConfig myToken]) {
        [self showReplyAsInputAccessoryView];
        if (!self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    else {
        [RCGlobalConfig showLoginControllerFromNavigationController:self.navigationController];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showReplyAsInputAccessoryView
{
    if (![self.quickReplyC.textView.internalTextView isFirstResponder]) {
        // each time addSubview to keyWidow, otherwise keyborad is not showed, sorry, so dirty!
        [[UIApplication sharedApplication].keyWindow addSubview:_quickReplyC.view];
        self.quickReplyC.textView.internalTextView.inputAccessoryView = self.quickReplyC.view;
        
        // call becomeFirstResponder twice, I donot know why, feel so bad!
        // maybe because textview is in superview(self.quickReplyC.view)
        [self.quickReplyC.textView.internalTextView becomeFirstResponder];
        [self.quickReplyC.textView.internalTextView becomeFirstResponder];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (RCQuickReplyC*)quickReplyC
{
    if (!_quickReplyC) {
        _quickReplyC = [[RCQuickReplyC alloc] initWithTopicId:((RCTopicDetailModel*)self.model).topicId];
        _quickReplyC.replyDelegate = self;
        // setting the first responder view of the table but we don't know its type (cell/header/footer)
        // [self.view addSubview:_quickReplyC.view];
        // so mush show it in keywindow, same to keyborad :)
        [[UIApplication sharedApplication].keyWindow addSubview:_quickReplyC.view];
    }
    return _quickReplyC;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToBottomOrTopAction
{
    if (SCROLL_DIRECTION_BOTTOM_TAG == self.scrollBtn.tag) {
        [self scrollToBottomAnimated:YES];
    }
    else if (SCROLL_DIRECTION_UP_TAG == self.scrollBtn.tag) {
        [self scrollToTopAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToBottomNotAnimated
{
    [self.tableView scrollRectToVisible:CGRectMake(0.f, self.tableView.contentSize.height - self.view.height,
                                                   self.tableView.width, self.tableView.height) animated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToBottomAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:CGRectMake(0.f, self.tableView.contentSize.height - self.view.height,
                                                   self.tableView.width, self.tableView.height) animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToTopAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:CGRectMake(0.f, 0.f,
                                                   self.tableView.width, self.tableView.height) animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)replyTopicWithFloorAtSomeone:(NSString*)floorAtsomeoneString
{
    if ([RCGlobalConfig myToken]) {
        [self replyTopicAction];
        [self.quickReplyC appendString:floorAtsomeoneString];
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
    return [RCTopicDetailModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[RCReplyEntity class]]) {
                //RCReplyEntity* topic = (RCReplyEntity*)object;
                //nothing to do!
                //[RCGlobalConfig HUDShowMessage:@"TODO:回复该贴/赞该贴" addedToView:self.view];
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
#pragma mark - RCQuickReplyDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplySuccessWithMyReply:(RCReplyEntity*)replyEntity
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 回复成功后，直接插入到tablview底部
    NSArray* indexPaths = [self.model addObject:replyEntity];
    if (indexPaths.count) {
        NSIndexPath* indexPath = indexPaths[0];
        replyEntity.floorNumber = indexPath.row+1;
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        // 感觉没必要滑到底部
        //[self scrollToBottomAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplyFailure
{
    // nothing to do
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplyCancel
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
// 显示跳到底部和顶部
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat minOffset = 200.f;
    
    if (scrollView.contentOffset.y > minOffset
        && scrollView.contentOffset.y < scrollView.contentSize.height - self.view.height - minOffset) {
        if (velocity.y > 0.f) {
            [self.scrollBtn setTitle:@"↓" forState:UIControlStateNormal];
            self.scrollBtn.tag = SCROLL_DIRECTION_BOTTOM_TAG;
        }
        else {
            [self.scrollBtn setTitle:@"↑" forState:UIControlStateNormal];
            self.scrollBtn.tag = SCROLL_DIRECTION_UP_TAG;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.scrollBtn];
        [self.scrollBtn performSelector:@selector(removeFromSuperview) withObject:Nil afterDelay:2.0f];
    }
}

@end
