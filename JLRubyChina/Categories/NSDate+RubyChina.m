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
+ (NSDate *)formatDateWith_T_FromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+08:00'"];
    return [dateFormatter dateFromString:string];
}

@end
