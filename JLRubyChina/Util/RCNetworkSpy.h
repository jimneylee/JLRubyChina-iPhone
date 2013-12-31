//
//  TLGlobalConfig.h
//  SinaMBlog
//
//  Created by jimney Lee on 7/25/12.
//  Copyright (c) 2012 jimneylee. All rights reserved.
//

#import "Reachability.h"

@protocol RCNetworkSpyDelegate;
@interface RCNetworkSpy : NSObject

+ (RCNetworkSpy*)sharedNetworkSpy;

@property (nonatomic, assign) id<RCNetworkSpyDelegate> spyDelegate;

- (void)spyNetwork;
- (BOOL)checkNetworkReachable;

@end

@protocol RCNetworkSpyDelegate <NSObject>

- (void)didNetworkChangedReachable:(BOOL)reachable viaWifi:(BOOL)viaWifi;

@end