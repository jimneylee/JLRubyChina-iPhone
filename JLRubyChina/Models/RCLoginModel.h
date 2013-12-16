//
//  RCSignModel.h
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCAccountEntity.h"

@interface RCLoginModel : NSObject

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(RCAccountEntity* user, NSError *error))block;

@end
