//
//  RCReplyCell.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCHomepageHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+nimbusImageNamed.h"
#import "UIView+findViewController.h"
#import "RCUserHomepageC.h"
#import "RCForumTopicsC.h"
#import "RCUserFullEntity.h"

#define NAME_FONT_SIZE [UIFont boldSystemFontOfSize:22.f]
#define LOGIN_ID_FONT_SIZE [UIFont systemFontOfSize:16.f]
#define TAG_LINE_ID_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define BUTTON_FONT_SIZE [UIFont boldSystemFontOfSize:15.f]

#define HEAD_IAMGE_HEIGHT 60
#define BUTTON_SIZE CGSizeMake(104.f, 40.f)

@interface RCHomepageHeaderView()
@property (nonatomic, strong) RCUserFullEntity* user;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* loginIdLabel;
@property (nonatomic, strong) UILabel* tagLineLabel;
@property (nonatomic, strong) NINetworkImageView* headView;

@property (nonatomic, strong) UIButton* detailBtn;
@property (nonatomic, strong) UIButton* postedTopicsBtn;
@property (nonatomic, strong) UIButton* favoritedTopicsBtn;
@end

@implementation RCHomepageHeaderView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // content
        UIView* contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        self.contentView = contentView;

        // head
        self.headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT,
                                                                                    HEAD_IAMGE_HEIGHT)];
        self.headView.initialImage = [UIImage nimbusImageNamed:@"head_s.png"];
        [self.contentView addSubview:self.headView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(visitUserHomepage)];
        self.headView.userInteractionEnabled = YES;
        [self.headView addGestureRecognizer:tap];
        
        // username
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = NAME_FONT_SIZE;
        nameLabel.textColor = [UIColor blackColor];
        [contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // login id
        UILabel* loginIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loginIdLabel.font = LOGIN_ID_FONT_SIZE;
        loginIdLabel.textColor = [UIColor blackColor];
        [contentView addSubview:loginIdLabel];
        self.loginIdLabel = loginIdLabel;
        
        // introduce
        UILabel* tagLineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tagLineLabel.font = TAG_LINE_ID_FONT_SIZE;
        tagLineLabel.textColor = [UIColor blackColor];
        [contentView addSubview:tagLineLabel];
        self.tagLineLabel = tagLineLabel;
        
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];//CELL_CONTENT_VIEW_BG_COLOR;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.loginIdLabel.backgroundColor = [UIColor clearColor];
        self.tagLineLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellMargin = CELL_PADDING_4;
    CGFloat contentViewMarin = CELL_PADDING_10;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    CGFloat kContentMaxWidth = self.width - cellMargin * 2;
    
    CGFloat height = sideMargin;
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);
    
    self.headView.left = contentViewMarin;
    self.headView.top = contentViewMarin;
    
    // head image
    height = height + HEAD_IAMGE_HEIGHT;
    
    // name
    CGFloat topWidth = self.contentView.width - contentViewMarin * 2 - (self.headView.right + CELL_PADDING_10);
    self.nameLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, self.headView.top,
                                      topWidth, self.nameLabel.font.lineHeight);
    
    // login id
    self.loginIdLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + CELL_PADDING_4,
                                            topWidth, self.loginIdLabel.font.lineHeight);
    
    // introduce
    self.tagLineLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                         kContentMaxWidth, self.tagLineLabel.font.lineHeight);
    height = height + self.tagLineLabel.height + CELL_PADDING_4;
    
    // bottom margin
    height = height + sideMargin;
    
    // botton height
    height = height + BUTTON_SIZE.height;
    
    // content view
    self.contentView.frame = CGRectMake(cellMargin, cellMargin, kContentMaxWidth, height - cellMargin * 2);
    
    // self height
    self.height = height;
    
    // button
    self.detailBtn.left = 0.f;
    self.detailBtn.bottom = self.contentView.height;
    self.postedTopicsBtn.left = self.detailBtn.right;
    self.postedTopicsBtn.bottom = self.detailBtn.bottom;
    self.favoritedTopicsBtn.left = self.postedTopicsBtn.right;
    self.favoritedTopicsBtn.bottom = self.postedTopicsBtn.bottom;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewWithHomepageUser:(RCUserFullEntity*)user
{
    if (user) {
        self.user = user;
        if (user.avatarUrl.length) {
            [self.headView setPathToNetworkImage:user.avatarUrl];
        }
        else {
            [self.headView setPathToNetworkImage:nil];
        }
        self.nameLabel.text = user.name.length ? user.name : user.loginId;// if no name, just set loginId
        self.loginIdLabel.text = user.loginId;
        self.tagLineLabel.text = [NSString stringWithFormat:@"签名：%@", user.tagline.length ? user.tagline : @"暂无"];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)visitUserHomepage
{
    UIViewController* superviewC = self.viewController;
    [RCGlobalConfig HUDShowMessage:self.user.loginId
                       addedToView:[UIApplication sharedApplication].keyWindow];
    if (superviewC) {
        RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithUserLoginId:self.user.loginId];
        [superviewC.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIButton Action

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showUserDetailAction
{
    // TODO:
    [RCGlobalConfig HUDShowMessage:@"to do it!"
                       addedToView:[UIApplication sharedApplication].keyWindow];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showPostedTopicsAction
{
    UIViewController* superviewC = self.viewController;
    if (superviewC) {
        RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithUserLoginId:self.user.loginId];
        [superviewC.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showFavoritedTopicsAction
{
    UIViewController* superviewC = self.viewController;
    if (superviewC) {
        RCForumTopicsC* c = [[RCForumTopicsC alloc] initForFavoritedWithUserLoginId:self.user.loginId];
        [superviewC.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View init

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)detailBtn
{
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_detailBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_detailBtn setTitle:@"资料" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_detailBtn addTarget:self action:@selector(showUserDetailAction)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailBtn];
        _detailBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _detailBtn.layer.borderWidth = 1.0f;
    }
    return _detailBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)postedTopicsBtn
{
    if (!_postedTopicsBtn) {
        _postedTopicsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                      BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_postedTopicsBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_postedTopicsBtn setTitle:@"帖子" forState:UIControlStateNormal];
        [_postedTopicsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_postedTopicsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_postedTopicsBtn addTarget:self action:@selector(showPostedTopicsAction)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_postedTopicsBtn];
        _postedTopicsBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _postedTopicsBtn.layer.borderWidth = 1.0f;
    }
    return _postedTopicsBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)favoritedTopicsBtn
{
    if (!_favoritedTopicsBtn) {
        _favoritedTopicsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                         BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_favoritedTopicsBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_favoritedTopicsBtn.titleLabel setTextColor:[UIColor grayColor]];
        [_favoritedTopicsBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_favoritedTopicsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_favoritedTopicsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_favoritedTopicsBtn addTarget:self action:@selector(showFavoritedTopicsAction)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_favoritedTopicsBtn];
        _favoritedTopicsBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _favoritedTopicsBtn.layer.borderWidth = 1.0f;
    }
    return _favoritedTopicsBtn;
}

@end
