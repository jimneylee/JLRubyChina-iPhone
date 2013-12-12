//
//  RCReplyEntity.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCReplyEntity.h"
#import "NSDate+RubyChina.h"
#import "SCRegularParser.h"
#import "NSString+Emojize.h"

@implementation RCReplyEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.body = dic[JSON_BODY];
        self.createdAtDate = [NSDate dateFromSourceDateString:dic[JSON_CREATEED_AT]];
        self.updatedAtDate = [NSDate dateFromSourceDateString:dic[JSON_UPDATEED_AT]];
        self.user = [RCUserEntity entityWithDictionary:dic[JSON_USER]];
        
        [self parseAllKeywords];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCReplyEntity* entity = [[RCReplyEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 识别出 表情 at某人 share话题 标签
- (void)parseAllKeywords
{
    if (self.body.length) {
        if (!self.atPersonRanges) {
            self.atPersonRanges = [SCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
        if (!self.sharpFloorRanges) {
            self.sharpFloorRanges = [SCRegularParser keywordRangesOfSharpFloorInString:self.body];
        }
        // TODO: emotion
        self.body = [self.body emojizedString];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)floorNumberString
{
    if (!_floorNumberString.length) {
        NSString* louString = nil;
        switch (_floorNumber) {
            case 1:
                louString = @"沙发";
                break;
            case 2:
                louString = @"板凳";
                break;
            case 3:
                louString = @"地板";
                break;
            default:
                louString = [NSString stringWithFormat:@"%u楼", _floorNumber];
        }
        _floorNumberString = [louString copy];
    }
    return _floorNumberString;
}

@end
