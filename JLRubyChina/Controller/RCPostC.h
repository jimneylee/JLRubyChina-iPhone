//
//  SNPostC.h
//  SkyNet
//
//  Created by jimneylee on 13-9-9.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPostDelegate;
@interface RCPostC : UITableViewController

@property (nonatomic, assign) id<RCPostDelegate> postDelegate;

@end

@protocol RCPostDelegate <NSObject>

- (void)didPostNewTopic;

@end