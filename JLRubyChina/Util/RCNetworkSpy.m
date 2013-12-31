//
//  TLGlobalConfig.m
//  SinaMBlog
//
//  Created by jimney Lee on 7/25/12.
//  Copyright (c) 2012 jimneylee. All rights reserved.
//

#import "RCNetworkSpy.h"
#include <arpa/inet.h>

@interface RCNetworkSpy()
@property (nonatomic, strong) Reachability* reachability;
@property (nonatomic) BOOL isReachableViaWiFi;
@property (nonatomic) BOOL isReachableViaWWAN;
@property (nonatomic) BOOL isReachable;
@end

@implementation RCNetworkSpy

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Static

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (RCNetworkSpy*)sharedNetworkSpy
{
    static RCNetworkSpy* _sharedNetworkSpy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNetworkSpy = [[RCNetworkSpy alloc] init];
    });
    
    return _sharedNetworkSpy;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(networkChanged:) 
													 name:kReachabilityChangedNotification
												   object:nil];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) spyNetwork
{
	if (!self.reachability) {
        self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        
        _isReachableViaWiFi = [self.reachability isReachableViaWiFi];
		_isReachableViaWWAN = [self.reachability isReachableViaWWAN];
		_isReachable = [self.reachability isReachable];
        
		[self.reachability startNotifier];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Notification

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)networkChanged:(NSNotification*)noti
{
	Reachability* reac = (Reachability*)noti.object;
    
    _isReachableViaWiFi = [reac isReachableViaWiFi];
    _isReachableViaWWAN = [reac isReachableViaWWAN];
    _isReachable = [reac isReachable];

    if ([self.spyDelegate respondsToSelector:@selector(didNetworkChangedReachable:viaWifi:)]) {
        [self.spyDelegate didNetworkChangedReachable:_isReachable viaWifi:_isReachableViaWiFi];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)checkNetworkReachable
{
    if (!self.reachability) {
        self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
		_isReachable = [self.reachability isReachable];
        if (!_isReachable) {
            return NO;
        }
	}
    return YES;
}

@end
