//
//  NSString+stringFromValue.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-14.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "NSString+stringFromValue.h"

@implementation NSString (stringFromValue)

+ (NSString*)stringFromValue:(id)value
{
	if (value) {
		if ([value isKindOfClass:[NSString class]]) {
			return value;
		}
		else if ([value isKindOfClass:[NSNumber class]]) {
			return [value stringValue];
		}
		else {
			return @"";
		}
	}
	else {
		return @"";
	}
}

@end
