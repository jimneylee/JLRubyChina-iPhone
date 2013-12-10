//
//  NSDate+RubyChina.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "NSDate+RubyChina.h"

@implementation NSDate (RubyChina)

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate*)dateFromSourceDateString:(NSString*)dateString
{
    NSDate* date = nil;
    NSRange range = NSMakeRange(0, 0);
    if (dateString && [dateString isKindOfClass:[NSString class]] && dateString.length) {
        //2013-12-10T20:17:42.707+08:00
        range = [dateString rangeOfString:@"."];
        if (range.length) {
            dateString = [dateString substringToIndex:range.location];
        }
        date = [NSDate formatDateWith_T_FromString:dateString];
    }
    return date;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)formatDateWith_T_FromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+08:00'"];
    return [dateFormatter dateFromString:string];
}

@end
