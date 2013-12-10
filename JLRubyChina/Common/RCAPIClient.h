//
//  RCAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AFHTTPClient.h"
#import "JLAFHTTPClient.h"

@interface RCAPIClient : JLAFHTTPClient

+ (RCAPIClient*)sharedClient;

//================================================================================
// search
//================================================================================
// 搜索用户
+ (NSString*)relativePathForTopicsWithPageCounter:(NSInteger)pageCounter
                                     perpageCount:(NSInteger)perpageCount;

@end

NSString *const kAPIBaseURLString;