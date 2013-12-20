//
//  RCNodeCell.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCSiteCell.h"
#import "RCSiteEntity.h"

#define TITLE_FONT_SIZE [UIFont boldSystemFontOfSize:17.f]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:15.f]

@interface RCSiteCell()
@end
@implementation RCSiteCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    CGFloat height = 0.f;
    CGFloat contentViewMarin = CELL_PADDING_6;
    
    height = height + contentViewMarin;
    height = height + TITLE_FONT_SIZE.lineHeight;
    
    height = height + CELL_PADDING_2;
    
    RCSiteEntity* o = (RCSiteEntity*)object;
    CGFloat kContentLength =  tableView.width - contentViewMarin * 2;
#if 1
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:o.description
                                    attributes:@{NSFontAttributeName:SUBTITLE_FONT_SIZE}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){kContentLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
#else
    CGSize size = [o.description sizeWithFont:SUBTITLE_FONT_SIZE
                                        constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping];
#endif
    height = height + size.height;
    height = height + contentViewMarin;
    
    return height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.font = TITLE_FONT_SIZE;
        self.detailTextLabel.font = SUBTITLE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.numberOfLines = 0;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentViewMarin = CELL_PADDING_6;
    CGFloat kContentLength = self.contentView.width - contentViewMarin * 2;
    self.textLabel.frame = CGRectMake(contentViewMarin, contentViewMarin,
                                      kContentLength / 2, self.textLabel.font.lineHeight);
#if 1
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.detailTextLabel.text
                                    attributes:@{NSFontAttributeName:SUBTITLE_FONT_SIZE}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){kContentLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
#else
    CGSize size = [self.detailTextLabel.text sizeWithFont:SUBTITLE_FONT_SIZE
                                         constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                             lineBreakMode:NSLineBreakByWordWrapping];
#endif
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom + CELL_PADDING_2,
                                            kContentLength, size.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[RCSiteEntity class]]) {
        RCSiteEntity* o = (RCSiteEntity*)object;
        self.textLabel.text = o.name;
        self.detailTextLabel.text = o.description;
    }
    return YES;
}

@end
