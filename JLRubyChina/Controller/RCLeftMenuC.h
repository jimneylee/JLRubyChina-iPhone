//
//  LeftViewController.h
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LeftMenuType_Home=0,
    LeftMenuType_ForumNodes,
    LeftMenuType_CoolSites,
    LeftMenuType_TopMembers,
    LeftMenuType_MyHomePage,
    LeftMenuType_Wiki,
    LeftMenuType_More
}LeftMenuType;

@protocol RCLeftMenuDelegate;
@interface RCLeftMenuC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<RCLeftMenuDelegate> delegate;

- (id)initWithStyle:(UITableViewStyle)style;
- (void)setSelectedMenuType:(LeftMenuType)type;

@end

@protocol RCLeftMenuDelegate <NSObject>

- (void)didSelectLeftMenuType:(LeftMenuType)type;

@end
