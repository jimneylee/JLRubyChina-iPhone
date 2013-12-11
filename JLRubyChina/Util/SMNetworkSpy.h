//
//  TLGlobalConfig.h
//  SinaMBlog
//
//  Created by jimney Lee on 7/25/12.
//  Copyright (c) 2012 jimneylee. All rights reserved.
//

#import "Reachability.h"
/**
 * 网络连接状态的侦听者
 * 负责侦听当前网络是否连接，识别当前连接方式：2G/3G/Wifi
 */
@interface SMNetworkSpy : NSObject
{
    Reachability* _reachability;
    BOOL _isReachableViaWiFi;
    BOOL _isReachableViaWWAN;
    BOOL _isReachable;
}

+ (id)sharedNetworkSpy;
+ (BOOL)checkNetworkConnected;

@property (nonatomic, retain) Reachability* reachability;
@property (nonatomic) BOOL isReachableViaWiFi;
@property (nonatomic) BOOL isReachableViaWWAN;

- (void)spyNetwork;
@end
