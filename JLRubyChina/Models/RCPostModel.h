//
//  RCReplyModel.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCPostModel : NSObject
- (void)postNewTopicWithTitle:(NSString*)title
                         body:(NSString*)body
                      success:(void(^)())success
                      failure:(void(^)(NSError *error))failure;
@end
