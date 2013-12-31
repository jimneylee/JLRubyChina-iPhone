//
//  SNPostC.h
//  JLRubyChina
//
//  Created by jimneylee on 13-9-9.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPostDelegate;

// TODO：当前采用tableview实现，除了键盘弹出好处理，其他太过复杂，后面考虑简单化
@interface RCPostC : UITableViewController

@property (nonatomic, assign) id<RCPostDelegate> postDelegate;

@end

@protocol RCPostDelegate <NSObject>

- (void)didPostNewTopic;

@end