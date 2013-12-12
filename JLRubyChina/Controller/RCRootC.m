//
//  MainViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "RCRootC.h"
#import "RCForumTopicsC.h"
#import "RCForumNodesC.h"
#import "RCCoolSitesC.h"
//#import "DZUserCenterC.h"
//#import "DZAboutC.h"
//#import "DZMoreC.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface RCRootC ()<UIActionSheetDelegate>

@property(strong, nonatomic) RCLeftC* LeftSideC;
@property(strong, nonatomic) RCForumTopicsC* forumTopics;
//@property(strong, nonatomic) DZUserCenterC* userCenterC;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCRootC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.LeftSideC = [[RCLeftC alloc] initWithStyle:UITableViewStylePlain];
    self.LeftSideC.delegate = self;
    
    [self.revealSideViewController preloadViewController:self.LeftSideC
                                                 forSide:PPRevealSideDirectionLeft
                                              withOffset:SIDE_DIRECTION_LEFT_OFFSET];
    [self showHomeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Side View Controller

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLeft:(id)sender
{
    // used to push a new controller, but we preloaded it !
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft
                                                         withOffset:SIDE_DIRECTION_LEFT_OFFSET
                                                           animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showHomeView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    if (!_forumTopics) {
        _forumTopics = [[RCForumTopicsC alloc] initWithTopicsType:RCForumTopicsType_LatestActivity];
    }
    [self.navigationController pushViewController:self.forumTopics animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showForumNodesView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    RCForumNodesC* c = [[RCForumNodesC alloc] init];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showCoolSitesView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    RCCoolSitesC* c = [[RCCoolSitesC alloc] init];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showUserCenterView
{
    [self.navigationController popToRootViewControllerAnimated:NO];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMoreView
{
    [self.navigationController popToRootViewControllerAnimated:NO];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showAboutUsView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark LeftMenuDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectLeftMenuType:(LeftMenuType)type
{
    switch (type) {
        case LeftMenuType_Home:
            [self showLeft:nil];
            [self showHomeView];
            break;
            
        case LeftMenuType_ForumNodes:
            [self showLeft:nil];
            [self showForumNodesView];
            break;
            
        case LeftMenuType_CoolSites:
            [self showLeft:nil];
            [self showCoolSitesView];
            break;
            
        case LeftMenuType_UserCenter:
            [self showLeft:nil];
            [self showUserCenterView];
            break;
            
        case LeftMenuType_More:
            [self showLeft:nil];
            [self showMoreView];
            break;
            
        case LeftMenuType_AboutUs:
            [self showLeft:nil];
            [self showAboutUsView];
            break;
            
        default:
            break;
    }
}

@end
