//
//  SMStatusCell.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NimbusNetworkImage.h"
#import "NIAttributedLabel.h"
#import "NIWebController.h"
#import "UIView+findViewController.h"
#import "UIImage+nimbusImageNamed.h"
#import "RCTopicEntity.h"
#import "RCForumTopicsC.h"
#import "RCUserHomepageC.h"

#define NAME_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define DATE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define TITLE_FONT_SIZE [UIFont systemFontOfSize:18.f]
#define LAST_REPLIED_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define REPLIES_COUNT_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]
#define HEAD_IAMGE_HEIGHT 34

@interface RCTopicCell()<NIAttributedLabelDelegate>
@property (nonatomic, strong) RCTopicEntity* topicEntity;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) UILabel* topicTitleLabel;
@property (nonatomic, strong) UILabel* repliesCountLabel;
@property (nonatomic, strong) NIAttributedLabel* lastRepliedLabel;// todo use niattributelabel
@property (nonatomic, strong) NINetworkImageView* headView;
@end

@implementation RCTopicCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[RCTopicEntity class]]) {
        CGFloat cellMargin = CELL_PADDING_4;
        CGFloat contentViewMarin = CELL_PADDING_6;
        CGFloat sideMargin = cellMargin + contentViewMarin;

        CGFloat height = sideMargin;
        
        // head image
        height = height + HEAD_IAMGE_HEIGHT;
        height = height + CELL_PADDING_4;
        
        RCTopicEntity* o = (RCTopicEntity*)object;
        
        CGFloat kTitleLength = tableView.width -  sideMargin * 2;
#if 1
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:o.topicTitle
                                        attributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){kTitleLength, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize titleSize = rect.size;
#else
        CGSize titleSize = [o.topicTitle sizeWithFont:TITLE_FONT_SIZE
                                    constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)];
#endif
        height = height + titleSize.height;

        height = height + CELL_PADDING_4;
        height = height + LAST_REPLIED_FONT_SIZE.lineHeight;
        
        height = height + sideMargin;
        
        return height;
    }
    
    return 0.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // head image
        self.headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT,
                                                                                   HEAD_IAMGE_HEIGHT)];
        self.headView.initialImage = [UIImage nimbusImageNamed:@"head_s.png"];
        [self.contentView addSubview:self.headView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(visitUserHomepage)];
        self.headView.userInteractionEnabled = YES;
        [self.headView addGestureRecognizer:tap];
        
        // name
        self.textLabel.font = NAME_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        // date
        self.detailTextLabel.font = DATE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // topic title
        self.topicTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.topicTitleLabel.numberOfLines = 0;
        self.topicTitleLabel.font = TITLE_FONT_SIZE;
        self.topicTitleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.topicTitleLabel];
        
        // replies count
        self.repliesCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.repliesCountLabel.font = REPLIES_COUNT_FONT_SIZE;
        self.repliesCountLabel.textColor = [UIColor whiteColor];
        self.repliesCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.repliesCountLabel];
        
        // topic title
        self.lastRepliedLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        self.lastRepliedLabel.font = NAME_FONT_SIZE;
        self.lastRepliedLabel.textColor = [UIColor grayColor];
        self.lastRepliedLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.lastRepliedLabel.autoDetectLinks = YES;
        self.lastRepliedLabel.delegate = self;
        self.lastRepliedLabel.attributesForLinks =
        @{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        self.lastRepliedLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [self.contentView addSubview:self.lastRepliedLabel];
        
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        // bg color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = CELL_CONTENT_VIEW_BG_COLOR;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.repliesCountLabel.backgroundColor = RGBCOLOR(27, 128, 219);//[UIColor clearColor];
        self.topicTitleLabel.backgroundColor = [UIColor clearColor];
        self.lastRepliedLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.headView.image = [UIImage nimbusImageNamed:@"head_s.png"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IOS_IS_AT_LEAST_7 && ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
    }
    else {
        // set here compatible with ios6.x
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    // layout
    CGFloat cellMargin = CELL_PADDING_4;
    CGFloat contentViewMarin = CELL_PADDING_6;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);
    // head image
    self.headView.left = contentViewMarin;
    self.headView.top = contentViewMarin;
    
    // name
    CGFloat kTextLength = self.contentView.width - contentViewMarin * 2 - (self.headView.right + CELL_PADDING_6);
    self.textLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_6, contentViewMarin,
                                      kTextLength / 2,
                                      self.textLabel.font.lineHeight);
    
    // source from & date
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom + CELL_PADDING_2,
                                            kTextLength, self.detailTextLabel.font.lineHeight);
    // replies count
    CGSize repliesCountSize = CGSizeZero;
    if (IOS_IS_AT_LEAST_7 && ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
        repliesCountSize = [self.repliesCountLabel.text sizeWithAttributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
    }
    else {
        repliesCountSize = [self.repliesCountLabel.text sizeWithFont:TITLE_FONT_SIZE];
    }
    self.repliesCountLabel.frame = CGRectMake(0.f, self.textLabel.top,
                                              repliesCountSize.width + CELL_PADDING_6,
                                              self.repliesCountLabel.font.lineHeight);
    self.repliesCountLabel.right = self.contentView.width - sideMargin;
    
    // title
    CGFloat kTitleLength = self.contentView.width - contentViewMarin * 2;
#if 1
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.topicTitleLabel.text
                                    attributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){kTitleLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize titleSize = rect.size;
#else
    CGSize titleSize = [self.topicTitleLabel.text sizeWithFont:TITLE_FONT_SIZE
                                            constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)];
#endif
    self.topicTitleLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                        kTitleLength, titleSize.height);
    
    self.lastRepliedLabel.frame = CGRectMake(self.topicTitleLabel.left, self.topicTitleLabel.bottom + CELL_PADDING_4,
                                             self.topicTitleLabel.width, 0.f);
    [self.lastRepliedLabel sizeToFit];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[RCTopicEntity class]]) {
        RCTopicEntity* o = (RCTopicEntity*)object;
        self.topicEntity = o;
        if (o.user.avatarUrl.length) {
            [self.headView setPathToNetworkImage:o.user.avatarUrl];
        }
        else {
            self.headView.image = [UIImage nimbusImageNamed:@"head_s.png"];
        }
        self.textLabel.text = o.user.loginId;
        self.detailTextLabel.text = [o.createdAtDate formatRelativeTime];
        self.repliesCountLabel.text = [NSString stringWithFormat:@"%lu", o.repliesCount];
        self.topicTitleLabel.text = o.topicTitle;
        if (o.lastRepliedUser.loginId) {
            self.lastRepliedLabel.text = [NSString stringWithFormat:@"%@•最后由%@于%@回复",
                                          o.nodeName, o.lastRepliedUser.loginId, [o.repliedAtDate formatRelativeTime]];
            NSString* atSomeoneUrl = [NSString stringWithFormat:@"%@%@",
                                      PROTOCOL_AT_SOMEONE, [o.lastRepliedUser.loginId urlEncoded]];
            [self.lastRepliedLabel addLink:[NSURL URLWithString:atSomeoneUrl]
                                     range:NSMakeRange(o.nodeName.length + 4, o.lastRepliedUser.loginId.length)];
        }
        else {
            self.lastRepliedLabel.text = [NSString stringWithFormat:@"%@•还没有回复，快进去讨论吧！", o.nodeName];
        }
        NSString* nodeUrl = [NSString stringWithFormat:@"%@%@", PROTOCOL_NODE, [o.nodeName urlEncoded]];
        [self.lastRepliedLabel addLink:[NSURL URLWithString:nodeUrl]
                                 range:NSMakeRange(0, o.nodeName.length)];
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)visitUserHomepage
{
    UIViewController* superviewC = self.viewController;
    [RCGlobalConfig HUDShowMessage:self.topicEntity.user.loginId
                       addedToView:[UIApplication sharedApplication].keyWindow];
    if (superviewC) {
        RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithUserLoginId:self.topicEntity.user.loginId];
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
        UIViewController* superviewC = self.viewController;
        if ([url.absoluteString hasPrefix:PROTOCOL_AT_SOMEONE]) {
            NSString* someone = [url.absoluteString substringFromIndex:PROTOCOL_AT_SOMEONE.length];
            someone = [someone stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [RCGlobalConfig HUDShowMessage:someone
                               addedToView:[UIApplication sharedApplication].keyWindow];
            if (superviewC) {
                RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithUserLoginId:self.topicEntity.lastRepliedUser.loginId];
                [superviewC.navigationController pushViewController:c animated:YES];
            }
        }
        else if ([url.absoluteString hasPrefix:PROTOCOL_NODE]) {
            NSString* somenode = [url.absoluteString substringFromIndex:PROTOCOL_NODE.length];
            somenode = [somenode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            if (superviewC) {
                if ([superviewC.title isEqualToString:somenode]) {
                    [RCGlobalConfig HUDShowMessage:[NSString stringWithFormat:@"Already in %@", somenode]
                                       addedToView:[UIApplication sharedApplication].keyWindow];
                }
                else {
                    [RCGlobalConfig HUDShowMessage:[NSString stringWithFormat:@"Go to %@", somenode]
                                       addedToView:[UIApplication sharedApplication].keyWindow];
                    RCForumTopicsC* topicsC = [[RCForumTopicsC alloc] initWithNodeName:self.topicEntity.nodeName
                                                                          nodeId:self.topicEntity.nodeId];
                    [superviewC.navigationController pushViewController:topicsC animated:YES];
                }
            }
        }
        else {
            if (superviewC) {
                NIWebController* webC = [[NIWebController alloc] initWithURL:url];
                [superviewC.navigationController pushViewController:webC animated:YES];
            }
        }
    }
    else {
        [RCGlobalConfig HUDShowMessage:@"抱歉，这是无效的链接" addedToView:self.viewController.view];
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
