//
//  RCTopicDetailHeaderView.m
//  JLRubyChina
//
//  Created by jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCTopicBodyView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewAdditions.h"
#import "NIAttributedLabel.h"
#import "NIWebController.h"
#import "UIView+findViewController.h"
#import "MTStatusBarOverlay.h"
#import "RCUserHomepageC.h"
#import "RCContentPhotoBrowerC.h"
#import "RCKeywordEntity.h"
#import "RCTopicActionModel.h"

// 字体 行高 文本色设置
#define TITLE_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]
#define NAME_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define DATE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:18.f]
#define BUTTON_FONT_SIZE [UIFont boldSystemFontOfSize:15.f]

#define CONTENT_LINE_HEIGHT 23.f
#define HEAD_IAMGE_HEIGHT 34
#define BUTTON_SIZE CGSizeMake(104.f, 30.f)
#define CONTENT_IMAGE_HEIGHT 160

@interface RCTopicBodyView()<NIAttributedLabelDelegate>
@property (nonatomic, strong) RCTopicDetailEntity* topicDetailEntity;
@property (nonatomic, strong) RCTopicActionModel* actionModel;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) NINetworkImageView* headView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) NIAttributedLabel* bodyLabel;
@property (nonatomic, strong) UIButton* followBtn;
@property (nonatomic, strong) UIButton* unfollowBtn;
@property (nonatomic, strong) UIButton* favoriteBtn;
@property (nonatomic, strong) NINetworkImageView* contentImageView;
@property (nonatomic, strong) UIImageView* moreImageView;
@end

@implementation RCTopicBodyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // content
        UIView* contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        // topic title
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.numberOfLines = 0;
        titleLabel.font = TITLE_FONT_SIZE;
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // head
        NINetworkImageView* headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT, HEAD_IAMGE_HEIGHT)];
        [self.contentView addSubview:headView];
        self.headView = headView;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(visitUserHomepage)];
        self.headView.userInteractionEnabled = YES;
        [self.headView addGestureRecognizer:tap];
        
        // name
        UILabel* nameLabel = [[UILabel alloc] init];
        nameLabel.font = NAME_FONT_SIZE;
        nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // date
        UILabel* dateLabel = [[UILabel alloc] init];
        dateLabel.font = DATE_FONT_SIZE;
        dateLabel.textColor = [UIColor grayColor];
        [contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        // content image
        self.contentImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                                     CONTENT_IMAGE_HEIGHT,
                                                                                     CONTENT_IMAGE_HEIGHT)];
        [self.contentView addSubview:self.contentImageView];
        self.contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapMoreGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(showMoreImages)];
        [self.contentImageView addGestureRecognizer:tapMoreGesture];
        
        // more images
        self.moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 56.f, 34.f)];
        self.moreImageView.image = [UIImage nimbusImageNamed:@"more_photo.png"];
        self.moreImageView.bottom = self.contentImageView.height;
        [self.contentImageView addSubview:self.moreImageView];
        
        // body
        NIAttributedLabel* bodyLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        bodyLabel.numberOfLines = 0;
        bodyLabel.textColor = [UIColor blackColor];
        bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        bodyLabel.autoDetectLinks = YES;
        bodyLabel.delegate = self;
        bodyLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        bodyLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [contentView addSubview:bodyLabel];
        self.bodyLabel = bodyLabel;
        
        // layer border if inneed
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        // backgroud
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = CELL_CONTENT_VIEW_BG_COLOR;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.bodyLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellMargin = CELL_PADDING_4;
    CGFloat contentViewMarin = CELL_PADDING_6;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    
    // top margin
    CGFloat height = sideMargin;
    
    // title
    self.titleLabel.text = self.topicDetailEntity.topicTitle;
    CGFloat kTitleLength = self.width - sideMargin * 2;
#if 1
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.topicDetailEntity.topicTitle
                                    attributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){kTitleLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize titleSize = rect.size;
#else
    CGSize titleSize = [self.topicDetailEntity.topicTitle sizeWithFont:TITLE_FONT_SIZE
                                                constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)
                                                    lineBreakMode:NSLineBreakByCharWrapping];
#endif
    self.titleLabel.frame = CGRectMake(contentViewMarin, contentViewMarin, kTitleLength, titleSize.height);
    height = height + self.titleLabel.height;
    height = height + CELL_PADDING_4;

    // head
    self.headView.left = contentViewMarin;
    self.headView.top = self.titleLabel.bottom + CELL_PADDING_4;
    height = height + self.headView.height;
    height = height + CELL_PADDING_4;
    
    // name
    CGFloat topWidth = self.contentView.width - contentViewMarin * 2 - (self.headView.right + CELL_PADDING_10);
    self.nameLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, self.headView.top,
                                      topWidth, self.nameLabel.font.lineHeight);
    
    // date
    self.dateLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom,
                                            topWidth, self.dateLabel.font.lineHeight);
    
    // content image
    NSString* firstImageUrl = nil;
    if (self.topicDetailEntity.imageUrlsArray.count) {
        firstImageUrl = self.topicDetailEntity.imageUrlsArray[0];
    }
    if (firstImageUrl.length) {
        self.contentImageView.left = (self.width - cellMargin * 2 - self.contentImageView.width) / 2;
        self.contentImageView.top = self.headView.bottom + CELL_PADDING_4;
        height = height + self.contentImageView.height;
        height = height + CELL_PADDING_4;
    }

    // status content
    CGFloat kContentLength = self.width - sideMargin * 2;
    self.bodyLabel.frame = CGRectMake(self.headView.left, height,
                                      kContentLength, 0.f);
    [self.bodyLabel sizeToFit];
    
    // body height
    height = height + self.bodyLabel.height;
    height = height + CELL_PADDING_4;

    // botton height
    height = height + BUTTON_SIZE.height;
    
    // bottom margin
    height = height + sideMargin;
    
    // content view
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        height - cellMargin * 2);
    // self height
    self.height = height;
    
    // button
    self.followBtn.left = 0.f;
    self.followBtn.bottom = self.contentView.height;
    self.unfollowBtn.left = self.followBtn.right;
    self.unfollowBtn.bottom = self.followBtn.bottom;
    self.favoriteBtn.left = self.unfollowBtn.right;
    self.favoriteBtn.bottom = self.unfollowBtn.bottom;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewWithTopicDetailEntity:(RCTopicDetailEntity*)topicDetailEntity
{
    self.topicDetailEntity = topicDetailEntity;
    if (topicDetailEntity.user.avatarUrl.length) {
        [self.headView setPathToNetworkImage:topicDetailEntity.user.avatarUrl];
    }
    else {
        [self.headView setPathToNetworkImage:nil];
    }
    self.nameLabel.text = topicDetailEntity.user.loginId;
    self.dateLabel.text = [NSString stringWithFormat:@"%@发布", [topicDetailEntity.createdAtDate formatRelativeTime]];
    self.bodyLabel.attributedText = topicDetailEntity.attributedBody;
    
    NSString* firstImageUrl = nil;
    if (self.topicDetailEntity.imageUrlsArray.count) {
        firstImageUrl = self.topicDetailEntity.imageUrlsArray[0];
    }
    if (firstImageUrl.length) {
        self.contentImageView.hidden = NO;
        [self.contentImageView setPathToNetworkImage:firstImageUrl contentMode:UIViewContentModeScaleAspectFill];
    }
    else {
        self.contentImageView.hidden = YES;
        [self.contentImageView setPathToNetworkImage:nil];
    }
    
    // if more than one image, show more image
    if (self.topicDetailEntity.imageUrlsArray.count > 1) {
        self.moreImageView.hidden = NO;
    }
    else {
        self.moreImageView.hidden = YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showAllKeywordsInContentLabel:(NIAttributedLabel*)contentLabel
                           withStatus:(RCTopicDetailEntity*)o
                         fromLocation:(NSInteger)location
{
    RCKeywordEntity* k = nil;
    NSString* url = nil;
    if (o.atPersonRanges.count) {
        for (int i = 0; i < o.atPersonRanges.count; i++) {
            k = (RCKeywordEntity*)o.atPersonRanges[i];
            url =[NSString stringWithFormat:@"%@%@", PROTOCOL_AT_SOMEONE, [k.keyword urlEncoded]];
            [contentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(k.range.location + location, k.range.length)];
            
        }
    }
    if (o.sharpFloorRanges.count) {
        for (int i = 0; i < o.sharpFloorRanges.count; i++) {
            k = (RCKeywordEntity*)o.sharpFloorRanges[i];
            url = [NSString stringWithFormat:@"%@%@", PROTOCOL_SHARP_FLOOR, [k.keyword urlEncoded]];
            [contentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(k.range.location + location, k.range.length)];
            
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIButton Action

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)followAction
{
    if ([RCGlobalConfig myToken]) {
        if (!_actionModel) {
            _actionModel = [[RCTopicActionModel alloc] init];
        }
        
        [[MTStatusBarOverlay sharedOverlay] postMessage:@"帖子关注中..."];
        [self.actionModel followTopicId:self.topicDetailEntity.topicId success:^{
            [[MTStatusBarOverlay sharedOverlay] postImmediateFinishMessage:@"帖子关注成功" duration:2.0f animated:YES];
        } failure:^(NSError *error) {
            [[MTStatusBarOverlay sharedOverlay] postImmediateErrorMessage:@"帖子关注失败" duration:2.0f animated:YES];
        }];
    }
    else {
        UIViewController* superviewC = self.viewController;
        if (superviewC) {
            [RCGlobalConfig showLoginControllerFromNavigationController:superviewC.navigationController];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unfollowAction
{
    if ([RCGlobalConfig myToken]) {
        if (!_actionModel) {
            _actionModel = [[RCTopicActionModel alloc] init];
        }
        
        [[MTStatusBarOverlay sharedOverlay] postMessage:@"帖子取消关注中..."];
        [self.actionModel unfollowTopicId:self.topicDetailEntity.topicId success:^{
            [[MTStatusBarOverlay sharedOverlay] postImmediateFinishMessage:@"取消关注成功" duration:2.0f animated:YES];
        } failure:^(NSError *error) {
            [[MTStatusBarOverlay sharedOverlay] postImmediateErrorMessage:@"取消关注失败" duration:2.0f animated:YES];
        }];
    }
    else {
        UIViewController* superviewC = self.viewController;
        if (superviewC) {
            [RCGlobalConfig showLoginControllerFromNavigationController:superviewC.navigationController];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)favoriteAction
{
    if ([RCGlobalConfig myToken]) {
        if (!_actionModel) {
            _actionModel = [[RCTopicActionModel alloc] init];
        }
        
        [[MTStatusBarOverlay sharedOverlay] postMessage:@"帖子收藏中..."];
        [self.actionModel favoriteTopicId:self.topicDetailEntity.topicId success:^{
            [[MTStatusBarOverlay sharedOverlay] postImmediateFinishMessage:@"帖子收藏成功" duration:2.0f animated:YES];
        } failure:^(NSError *error) {
            [[MTStatusBarOverlay sharedOverlay] postImmediateErrorMessage:@"帖子收藏失败" duration:2.0f animated:YES];
        }];
    }
    else {
        UIViewController* superviewC = self.viewController;
        if (superviewC) {
            [RCGlobalConfig showLoginControllerFromNavigationController:superviewC.navigationController];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMoreImages
{
    UIViewController* superviewC = self.viewController;
    if (superviewC) {
        RCContentPhotoBrowerC* c = [[RCContentPhotoBrowerC alloc] initWithPhotoUrls:self.topicDetailEntity.imageUrlsArray];
        [superviewC.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View init

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)followBtn
{
    if (!_followBtn) {
        _followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_followBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_followBtn addTarget:self action:@selector(followAction)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_followBtn];
        _followBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _followBtn.layer.borderWidth = 1.0f;
    }
    return _followBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)unfollowBtn
{
    if (!_unfollowBtn) {
        _unfollowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                      BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_unfollowBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_unfollowBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [_unfollowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_unfollowBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_unfollowBtn addTarget:self action:@selector(unfollowAction)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_unfollowBtn];
        _unfollowBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _unfollowBtn.layer.borderWidth = 1.0f;
    }
    return _unfollowBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)favoriteBtn
{
    if (!_favoriteBtn) {
        _favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                         BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_favoriteBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_favoriteBtn.titleLabel setTextColor:[UIColor grayColor]];
        [_favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_favoriteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_favoriteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_favoriteBtn addTarget:self action:@selector(favoriteAction)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_favoriteBtn];
        _favoriteBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _favoriteBtn.layer.borderWidth = 1.0f;
    }
    return _favoriteBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)visitUserHomepage
{
    UIViewController* superviewC = self.viewController;
    [RCGlobalConfig HUDShowMessage:self.topicDetailEntity.user.loginId
                       addedToView:[UIApplication sharedApplication].keyWindow];
    if (superviewC) {
        RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithUserLoginId:self.topicDetailEntity.user.loginId];
        [superviewC.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NIAttributedLabelDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)attributedLabel:(NIAttributedLabel*)attributedLabel
didSelectTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point {
    NSURL* url = nil;
    if (NSTextCheckingTypePhoneNumber == result.resultType) {
        url = [NSURL URLWithString:[@"tel://" stringByAppendingString:result.phoneNumber]];
        
    } else if (NSTextCheckingTypeLink == result.resultType) {
        url = result.URL;
    }
    
    if (nil != url) {
        if ([url.absoluteString hasPrefix:PROTOCOL_AT_SOMEONE]) {
            NSString* someone = [url.absoluteString substringFromIndex:PROTOCOL_AT_SOMEONE.length];
            // TODO: show someone homepage
            someone = [someone stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [RCGlobalConfig HUDShowMessage:someone
                               addedToView:[UIApplication sharedApplication].keyWindow];
        }
        else if ([url.absoluteString hasPrefix:PROTOCOL_SHARP_FLOOR]) {
            NSString* sometrend = [url.absoluteString substringFromIndex:PROTOCOL_SHARP_FLOOR.length];
            // TODO: show some floor about this trend
            sometrend = [sometrend stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [RCGlobalConfig HUDShowMessage:sometrend
                               addedToView:[UIApplication sharedApplication].keyWindow];
        }
        else
        {
            if (self.viewController) {
                NIWebController* c = [[NIWebController alloc] initWithURL:url];
                [self.viewController.navigationController pushViewController:c animated:YES];
            }
        }
    }
    else {
        [RCGlobalConfig HUDShowMessage:@"无效的链接" addedToView:self.viewController.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)attributedLabel:(NIAttributedLabel *)attributedLabel
shouldPresentActionSheet:(UIActionSheet *)actionSheet
 withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    return NO;
}

@end
