//
//  RCTopicDetailEntity.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicDetailEntity.h"
#import "SCRegularParser.h"
#import "NSString+Emojize.h"
#import "NSAttributedStringMarkdownParser.h"
#import "MarkdownSyntaxGenerator.h"

@implementation RCTopicDetailEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.body = dic[JSON_BODY];
        self.hitsCount = [dic[JSON_HITS_COUNT] unsignedLongValue];
        [self parseAllKeywords];
        if (IOS_IS_AT_LEAST_7) {
            self.attributedBody = [self parseAttributedStringFromMarkdownString:self.body];
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCTopicDetailEntity* entity = [[RCTopicDetailEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 识别出 表情 at某人 share话题 标签
- (void)parseAllKeywords
{
    if (self.body.length) {
        // parse emotion first
        self.body = [self.body emojizedString];
        
        NSString* trimedString = self.body;
        self.imageUrlsArray = [SCRegularParser imageUrlsInString:self.body trimedString:&trimedString];
        self.body = trimedString;
        
        if (!self.atPersonRanges) {
            self.atPersonRanges = [SCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
        if (!self.sharpFloorRanges) {
            self.sharpFloorRanges = [SCRegularParser keywordRangesOfSharpFloorInString:self.body];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// idea from MarkdownSyntaxEditor/MarkdownTextView, not perfect but better than before
#define CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:18.f]
- (NSAttributedString*)parseAttributedStringFromMarkdownString:(NSString*)markdownString
{
    if (markdownString.length) {
        MarkdownSyntaxGenerator* parser = [[MarkdownSyntaxGenerator alloc] init];
        NSArray *models = [parser syntaxModelsForText:markdownString];
        // set default font
        NSDictionary* defaultAttributes = @{NSFontAttributeName : CONTENT_FONT_SIZE};
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.body
                                                                                             attributes:defaultAttributes];
        // set line height
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.minimumLineHeight = 21.f;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, attributedString.length)];
        for (MarkdownSyntaxModel *model in models) {
            [attributedString addAttributes:AttributesFromMarkdownSyntaxType(model.type) range:model.range];
        }
        return attributedString;
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// perform not well
- (NSAttributedString*)parseAttributedStringFromMarkdownString_:(NSString*)markdownString
{
    if (markdownString.length) {
        NSAttributedStringMarkdownParser* parser = [[NSAttributedStringMarkdownParser alloc] init];
        parser.paragraphFont = [UIFont systemFontOfSize:17.f];
        return [parser attributedStringFromMarkdownString:self.body];
    }
    return nil;
}

@end
