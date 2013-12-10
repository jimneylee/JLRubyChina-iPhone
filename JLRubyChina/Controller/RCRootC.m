//
//  MainViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "RCRootC.h"
#import "MLNavigationController.h"
#import "RCForumTopicsC.h"
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
        _forumTopics = [[RCForumTopicsC alloc] initWithStyle:UITableViewStylePlain];
    }
    if ([self.navigationController isKindOfClass:[MLNavigationController class]]) {
        [(MLNavigationController*)(self.navigationController) pushViewController:self.forumTopics animated:NO addScreenshot:NO];
    }
    else {
        [self.navigationController pushViewController:self.forumTopics animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showUserCenterView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
//    DZUserCenterC* c = [[DZUserCenterC alloc] initWithStyle:UITableViewStyleGrouped];
//    if ([self.navigationController isKindOfClass:[MLNavigationController class]]) {
//        [(MLNavigationController*)(self.navigationController) pushViewController:c animated:NO addScreenshot:NO];
//    }
//    else {
//        [self.navigationController pushViewController:c animated:YES];
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMoreView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
//    DZMoreC* c = [[DZMoreC alloc] initWithStyle:UITableViewStyleGrouped];
//    if ([self.navigationController isKindOfClass:[MLNavigationController class]]) {
//        [(MLNavigationController*)(self.navigationController) pushViewController:c animated:NO addScreenshot:NO];
//    }
//    else {
//        [self.navigationController pushViewController:c animated:YES];
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showAboutUsView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
//    DZAboutC* c = [[DZAboutC alloc] init];
//    if ([self.navigationController isKindOfClass:[MLNavigationController class]]) {
//        [(MLNavigationController*)(self.navigationController) pushViewController:c animated:NO addScreenshot:NO];
//    }
//    else {
//        [self.navigationController pushViewController:c animated:YES];
//    }
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
