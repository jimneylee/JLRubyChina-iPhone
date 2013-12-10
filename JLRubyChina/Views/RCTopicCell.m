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
#import "RCTopicEntity.h"

#define TITLE_FONT_SIZE [UIFont systemFontOfSize:18.f]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define CONTENT_FONT_SIZE [UIFont systemFontOfSize:18.f]
#define HEAD_IAMGE_HEIGHT 34
#define SUBTITLE_
@interface RCTopicCell()
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) NINetworkImageView* headView;
@end
@implementation RCTopicCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[RCTopicEntity class]]) {
        CGFloat cellMargin = CELL_PADDING_6;
        CGFloat contentViewMarin = CELL_PADDING_8;
        CGFloat sideMargin = cellMargin + contentViewMarin;

        CGFloat height = sideMargin;
        
        // head image
//        height = height + HEAD_IAMGE_HEIGHT;
//        height = height + CELL_PADDING_10;
        
        RCTopicEntity* o = (RCTopicEntity*)object;
        
        CGFloat kTitleLength = tableView.width - HEAD_IAMGE_HEIGHT - CELL_PADDING_10 -  sideMargin * 2;
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
        
        //height = height + CELL_PADDING_10;
        height = height + SUBTITLE_FONT_SIZE.lineHeight;
        
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
        self.textLabel.numberOfLines = NO;
        self.textLabel.font = TITLE_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        // source from & date
        self.detailTextLabel.font = SUBTITLE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // status content
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = CONTENT_FONT_SIZE;
        self.contentLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.contentLabel];
        
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
    self.contentLabel.backgroundColor = [UIColor clearColor];

    // layout
    CGFloat cellMargin = CELL_PADDING_6;
    CGFloat contentViewMarin = CELL_PADDING_8;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);
    // head image
    self.headView.left = contentViewMarin;
    self.headView.top = (self.height - self.headView.height) / 2;
    
    // name
    CGFloat kTitleLength = self.contentView.width - contentViewMarin * 2 - (self.headView.right + CELL_PADDING_10);
    CGSize titleSize = [self.textLabel.text sizeWithFont:TITLE_FONT_SIZE
                                constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)];
    self.textLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, contentViewMarin,
                                      kTitleLength,
                                      titleSize.height);
    
    // source from & date
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom,
                                            self.width - sideMargin * 2 - self.textLabel.left,
                                            self.detailTextLabel.font.lineHeight);
    
    // status content
//    CGFloat kContentLength = self.contentView.width - contentViewMarin * 2;
//    CGSize contentSize = [self.contentLabel.text sizeWithFont:CONTENT_FONT_SIZE
//                                            constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)];
//    self.contentLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_10,
//                                        kContentLength, contentSize.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[RCTopicEntity class]]) {
        RCTopicEntity* o = (RCTopicEntity*)object;
        if (o.user.avatarUrl.length) {
            [self.headView setPathToNetworkImage:o.user.avatarUrl];
        }
        else {
            [self.headView setPathToNetworkImage:nil];
        }
        self.textLabel.text = o.topicTitle;
        NSLog(@"%@", self.detailTextLabel);
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@•%@•创建于%@",
                                     o.nodeName, o.user.username, [o.repliedAtDate formatRelativeTime]];// dynamic calculate relative time
        //self.contentLabel.text = o.text;
    }
    return YES;
}

@end
