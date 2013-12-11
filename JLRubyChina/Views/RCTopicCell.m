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
#import "RCTopicEntity.h"
#import "RCForumTopicsC.h"

#define NAME_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define DATE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define TITLE_FONT_SIZE [UIFont systemFontOfSize:16.f]
#define LAST_REPLIED_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define HEAD_IAMGE_HEIGHT 34

@interface RCTopicCell()<NIAttributedLabelDelegate>
@property (nonatomic, strong) RCTopicEntity* topicEntity;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) UILabel* topicTitleLabel;
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
//        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:o.topicTitle];
//        NSRange range = NSMakeRange(0, attrStr.length);
//        NSDictionary* dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
//        CGFloat kTitleLength = tableView.width - sideMargin * 2;
//        CGRect titleRect = [o.topicTitle boundingRectWithSize:CGSizeMake(kTitleLength, FLT_MAX)
//                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                   attributes:dic context:nil];
        CGSize titleSize = [o.topicTitle sizeWithFont:TITLE_FONT_SIZE
                                    constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)];
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
        [self.contentView addSubview:self.headView];

        // name
        self.textLabel.font = NAME_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        // source from & date
        self.detailTextLabel.font = DATE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // topic title
        self.topicTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.topicTitleLabel.numberOfLines = 0;
        self.topicTitleLabel.font = TITLE_FONT_SIZE;
        self.topicTitleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.topicTitleLabel];
        
        // topic title
        self.lastRepliedLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        self.lastRepliedLabel.font = NAME_FONT_SIZE;
        self.lastRepliedLabel.textColor = [UIColor grayColor];
        self.lastRepliedLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.lastRepliedLabel.autoDetectLinks = YES;
        self.lastRepliedLabel.delegate = self;
        self.lastRepliedLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        self.lastRepliedLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [self.contentView addSubview:self.lastRepliedLabel];
        
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    if (self.headView.image) {
        self.headView.image = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // bg color
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = CELL_CONTENT_VIEW_BG_COLOR;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.topicTitleLabel.backgroundColor = [UIColor clearColor];
    self.lastRepliedLabel.backgroundColor = [UIColor clearColor];
    
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
    // will - nodeNameButton
    self.textLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_6, contentViewMarin,
                                      self.contentView.width - contentViewMarin * 2 - (self.headView.right + CELL_PADDING_6),
                                      self.textLabel.font.lineHeight);
    
    // source from & date
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom + CELL_PADDING_2,
                                            self.textLabel.width, self.detailTextLabel.font.lineHeight);
    
    // status content
    CGFloat kTitleLength = self.contentView.width - contentViewMarin * 2;
    CGSize titleSize = [self.topicTitleLabel.text sizeWithFont:TITLE_FONT_SIZE
                                            constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)];
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
            [self.headView setPathToNetworkImage:nil];
        }
        self.textLabel.text = o.user.username;
        self.detailTextLabel.text = [o.createdAtDate formatRelativeTime];
        self.topicTitleLabel.text = o.topicTitle;
        if (o.lastRepliedUser.username) {
            self.lastRepliedLabel.text = [NSString stringWithFormat:@"%@•最后由%@于%@回复",
                                          o.nodeName, o.lastRepliedUser.username, [o.repliedAtDate formatRelativeTime]];
            NSString* atSomeoneUrl = [NSString stringWithFormat:@"%@%@",
                                      PROTOCOL_AT_SOMEONE, [o.lastRepliedUser.username urlEncoded]];
            [self.lastRepliedLabel addLink:[NSURL URLWithString:atSomeoneUrl]
                                     range:NSMakeRange(o.nodeName.length + 4, o.lastRepliedUser.username.length)];
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
            someone = [someone stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [RCGlobalConfig showHUDMessage:someone
                               addedToView:[UIApplication sharedApplication].keyWindow];
            // TODO: show someone homepage
        }
        else if ([url.absoluteString hasPrefix:PROTOCOL_NODE]) {
            NSString* somenode = [url.absoluteString substringFromIndex:PROTOCOL_NODE.length];
            somenode = [somenode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [RCGlobalConfig showHUDMessage:somenode
                               addedToView:[UIApplication sharedApplication].keyWindow];
            if (self.viewController) {
                RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithNodeName:self.topicEntity.nodeName
                                                                      nodeId:self.topicEntity.nodeId];
                [self.viewController.navigationController pushViewController:c animated:YES];
            }
        }
        else {
            if (self.viewController) {
                NIWebController* c = [[NIWebController alloc] initWithURL:url];
                [self.viewController.navigationController pushViewController:c animated:YES];
            }
        }
    }
    else {
        [RCGlobalConfig showHUDMessage:@"抱歉，这是无效的链接" addedToView:self.viewController.view];
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
