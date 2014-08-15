//
//  NSDate+RubyChina.h
//  JLRubyChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RubyChina)

+ (NSDate*)dateFromSourceDateString:(NSString*)dateString;

+ (NSDate *)formatDateWith_T_FromString:(NSString *)dateString;

@end
