//
//  RCTopicDetailHeaderView.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCTopicBodyView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewAdditions.h"
#import "NIAttributedLabel.h"
#import "NIWebController.h"
#import "UIView+findViewController.h"
#import "RCKeywordEntity.h"

// 字体 行高 文本色设置
#define TITLE_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]
#define NAME_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define DATE_FONT_SIZE [UIFont systemFontOfSize:12.f]
// 冬青字体：http://tadaland.com/ios-better-experience-font-hiragino.html
#define CONTENT_FONT_SIZE [UIFont fontWithName:@"Hiragino Sans GB" size:17.f]
#define CONTENT_LINE_HEIGHT 21.f
#define HEAD_IAMGE_HEIGHT 34

@interface RCTopicBodyView()<NIAttributedLabelDelegate>
@property (nonatomic, strong) RCTopicDetailEntity* topicDetailEntity;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) NINetworkImageView* headView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) NIAttributedLabel* bodyLabel;
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
        [contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // head
        NINetworkImageView* headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT, HEAD_IAMGE_HEIGHT)];
        [contentView addSubview:headView];
        self.headView = headView;
        
        // name
        UILabel* nameLabel = [[UILabel alloc] init];
        nameLabel.font = NAME_FONT_SIZE;
        nameLabel.textColor = [UIColor blackColor];
        [contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // date
        UILabel* dateLabel = [[UILabel alloc] init];
        dateLabel.font = DATE_FONT_SIZE;
        dateLabel.textColor = [UIColor grayColor];
        [contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        NIAttributedLabel* bodyLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        bodyLabel.numberOfLines = 0;
        bodyLabel.font = CONTENT_FONT_SIZE;
        bodyLabel.lineHeight = CONTENT_LINE_HEIGHT;
        bodyLabel.textColor = [UIColor blackColor];
        bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        bodyLabel.autoDetectLinks = YES;
        bodyLabel.delegate = self;
        bodyLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        bodyLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [contentView addSubview:bodyLabel];
        self.bodyLabel = bodyLabel;
        
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
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
    
    CGFloat height = sideMargin;
    
    // title
    self.titleLabel.text = self.topicDetailEntity.topicTitle;
    CGFloat titleWidth = self.width - sideMargin * 2;
    CGSize titleSize = [self.topicDetailEntity.topicTitle sizeWithFont:self.titleLabel.font
                                                constrainedToSize:CGSizeMake(titleWidth, FLT_MAX)
                                                    lineBreakMode:NSLineBreakByCharWrapping];
    self.titleLabel.frame = CGRectMake(contentViewMarin, contentViewMarin, titleWidth, titleSize.height);
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
    
    // status content
    CGFloat kContentLength = self.contentView.width - contentViewMarin * 2;

#if 0// sizeWithFont
    CGSize contentSize = [o.body sizeWithFont:CONTENT_FONT_SIZE constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)];
    self.bodyLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                      kContentLength, contentSize.height);
#else// sizeToFit
    self.bodyLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                      kContentLength, 0.f);
    [self.bodyLabel sizeToFit];
#endif
    
    height = height + self.bodyLabel.height;
    height = height + sideMargin;
    
    // content view
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        height - cellMargin * 2);
    // self height
    self.height = height;
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
    self.nameLabel.text = topicDetailEntity.user.username;
    self.dateLabel.text = [NSString stringWithFormat:@"%@发布", [topicDetailEntity.createdAtDate formatRelativeTime]];
    self.bodyLabel.text = topicDetailEntity.body;
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
    // TODO: check emotion
}

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
            [RCGlobalConfig hudShowMessage:someone
                               addedToView:[UIApplication sharedApplication].keyWindow];
        }
        else if ([url.absoluteString hasPrefix:PROTOCOL_SHARP_FLOOR]) {
            NSString* sometrend = [url.absoluteString substringFromIndex:PROTOCOL_SHARP_FLOOR.length];
            // TODO: show some floor about this trend
            sometrend = [sometrend stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [RCGlobalConfig hudShowMessage:sometrend
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
        [RCGlobalConfig hudShowMessage:@"无效的链接" addedToView:self.viewController.view];
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
