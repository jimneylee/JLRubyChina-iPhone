//
//  SMRegularParser.m
//  SinaMBlog
//
//  Created by Jiang Yu on 13-2-18.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SCRegularParser.h"
#import "NSStringAdditions.h"
#import "RCKeywordEntity.h"

static NSString *atRegular = @"@[^.,:;!?\\s#@。，；！？]+";
//static NSString *sharpRegular = @"#(.*?)#";
static NSString *sharpRegular = @"#(.*?)楼";//TODO:digit regular
static NSString *iconRegular = @"\\[([\u4e00-\u9fa5]+)\\]";

@implementation SCRegularParser

+ (NSArray *)keywordRangesOfAtPersonInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:atRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSMutableArray *rangesArray = [NSMutableArray array];
    __block NSString* keyword = nil;
    __block RCKeywordEntity* keywordEntity = nil;
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange resultRange = [result range];
                             // range & name
                             keyword = [regex replacementStringForResult:result
                                                                        inString:string
                                                                          offset:0
                                                                        template:@"$0"];
                             if (keyword.length) {
                                 // @someone
                                 keyword = [keyword substringWithRange:NSMakeRange(1, keyword.length-1)];
                                 keywordEntity = [[RCKeywordEntity alloc] init];
                                 keywordEntity.keyword = keyword;
                                 keywordEntity.range = resultRange;
                                 [rangesArray addObject:keywordEntity];
                             }
                         }];
    return rangesArray;
}

+ (NSArray *)keywordRangesOfSharpFloorInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:sharpRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSMutableArray *rangesArray = [NSMutableArray array];
    __block NSString* keyword = nil;
    __block RCKeywordEntity* keywordEntity = nil;
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange resultRange = [result range];
                             // range & trend
                             keyword = [regex replacementStringForResult:result
                                                                inString:string
                                                                  offset:0
                                                                template:@"$0"];
                             if (keyword.length) {
                                 // #sometrend#
                                 keyword = [keyword substringWithRange:NSMakeRange(1, keyword.length-2)];
                                 keywordEntity = [[RCKeywordEntity alloc] init];
                                 keywordEntity.keyword = keyword;
                                 keywordEntity.range = resultRange;
                                 [rangesArray addObject:keywordEntity];
                             }
                         }];
    return rangesArray;
}

+ (NSArray *)keywordRangesOfEmotionInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:iconRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSMutableArray *rangesArray = [NSMutableArray array];
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    __block NSString* keyword = nil;
    __block RCKeywordEntity* keywordEntity = nil;
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange resultRange = [result range];
                             resultRange.location += offset;
                             // range & emotion
                             keyword = [regex replacementStringForResult:result
                                                                inString:mutableString
                                                                  offset:offset
                                                                template:@"$0"];
                             keywordEntity = [[RCKeywordEntity alloc] init];
                             keywordEntity.keyword = keyword;
                             keywordEntity.range = resultRange;
                             [rangesArray addObject:keywordEntity];

                             [mutableString replaceCharactersInRange:resultRange withString:@""];
                             offset -= resultRange.length;
                         }];
      // 考虑去掉表情标签的字串如何返回
    return rangesArray;
}

@end
