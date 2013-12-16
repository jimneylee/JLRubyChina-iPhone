//
//  MainViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "RCRootC.h"
#import "NIWebController.h"
#import "RCForumTopicsC.h"
#import "RCForumNodesC.h"
#import "RCCoolSitesC.h"
#import "RCTopMembersC.h"
#import "RCWikiC.h"
#import "RCUserHomepageC.h"
#import "RCAboutAppC.h"

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
- (void)showTopMembersView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    RCTopMembersC* c = [[RCTopMembersC alloc] init];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showWikiView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    RCWikiC* c = [[RCWikiC alloc] initWithURL:[NSURL URLWithString:RC_WIKI_URL]];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMyHomepageView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithMyLoginId:[RCGlobalConfig myLoginId]];
    [self.navigationController pushViewController:c animated:YES];
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
    RCAboutAppC* c = [[RCAboutAppC alloc] init];
    [self.navigationController pushViewController:c animated:YES];
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
            
        case LeftMenuType_TopMembers:
            [self showLeft:nil];
            [self showTopMembersView];
            break;
            
        case LeftMenuType_Wiki:
            [self showLeft:nil];
            [self showWikiView];
            break;
            
        case LeftMenuType_MyHomePage:
            [self showLeft:nil];
            [self showMyHomepageView];
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
