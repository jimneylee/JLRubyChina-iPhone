//
//  RCTopicDetailEntity.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopicDetailEntity.h"
#import "RCRegularParser.h"
#import "NSString+Emojize.h"

#define CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:18.f]

@implementation RCTopicDetailEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
            self.body = dic[JSON_BODY];
            
            // 需要注意的是第一行需要指明编码格式 否则的话 中文会显示乱码
            // http://hufeng825.github.io/2014/01/21/ios37/
            self.bodyHTML = [NSString stringWithFormat:@"<meta charset=\"UTF-8\">%@", dic[JSON_BODY_HTML]];
            self.hitsCount = [dic[JSON_HITS_COUNT] unsignedLongValue];
//            [self parseAllKeywords];
            
            if (IOS_IS_AT_LEAST_7) {
                // learn from here http://initwithfunk.com/blog/2013/09/29/easy-markdown-rendering-with-nsattributedstring-on-ios-7/
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
                
                NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc] initWithData:[self.bodyHTML dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:options documentAttributes:nil error:nil];
                // set line height
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                NSDictionary *defaultAttributes = @{NSFontAttributeName : CONTENT_FONT_SIZE};

                paragraphStyle.minimumLineHeight = 21.f;
                [mAttributedString addAttribute:NSParagraphStyleAttributeName
                                         value:paragraphStyle
                                         range:NSMakeRange(0, mAttributedString.length)];
                [mAttributedString addAttributes:defaultAttributes
                                           range:NSMakeRange(0, mAttributedString.length)];
                self.attributedBody = mAttributedString;
            }
            else {
                self.attributedBody = [[NSAttributedString alloc] initWithString:self.body];
            }
        }
        else {
            self.body = dic[JSON_CONTENT];
            self.attributedBody = [[NSAttributedString alloc] initWithString:self.body];
            [self parseAllKeywords];
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
        self.imageUrlsArray = [RCRegularParser imageUrlsInString:self.body trimedString:&trimedString];
        self.body = trimedString;
        
        if (!self.atPersonRanges) {
            self.atPersonRanges = [RCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
        if (!self.sharpFloorRanges) {
            self.sharpFloorRanges = [RCRegularParser keywordRangesOfSharpFloorInString:self.body];
        }
    }
}

@end
