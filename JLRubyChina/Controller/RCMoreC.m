//
//  RCMoreC.m
//  RubyChina
//
//  Created by Lee jimney on 10/7/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCMoreC.h"
#import "LTUpdate.h"
#import "RCAccountEntity.h"
#import "RCAboutAppC.h"
#import "RCAPIClient.h"
#define ACTION_SHEET_TAG_LOGOUT 1000
#define ACTION_SHEET_TAG_CLEAR_CACHE 1001
#define ACTION_SHEET_TAG_RATE_APP 1002

#define LOGOUT_TITLE @"注销登录"
#define LOGIN_TITLE @"登录"

@interface RCMoreC ()<UIActionSheetDelegate>
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) NICellFactory* cellFactory;
@property (nonatomic, readwrite, retain) NITextCell* logoutLoginCell;
@end

@implementation RCMoreC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"更多设置";
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        NITableViewActionBlock tapClearCacheAction = ^BOOL(id object, UIViewController *controller) {
            [self showClearCaceActionSheet];
            return YES;
        };
        NITableViewActionBlock tapLogoutLoginAction = ^BOOL(id object, UIViewController *controller) {
            if ([RCGlobalConfig myToken]) {
                [self showLogoutActionSheet];
            }
            else {
                [RCGlobalConfig showLoginControllerFromNavigationController:self.navigationController];
            }
            return YES;
        };
        NITableViewActionBlock tapCheckLatestVersionAction = ^BOOL(id object, UIViewController *controller) {
            [[LTUpdate shared] update:LTUpdateDaily
                             complete:^(BOOL isNewVersionAvailable, LTUpdateVersionDetails *versionDetails) {
                                 if (!isNewVersionAvailable) {
                                     [RCGlobalConfig HUDShowMessage:@"已是最新版本，谢谢使用!" addedToView:self.view];
                                 }
                             }];
            return YES;
        };
        NITableViewActionBlock tapRateAction = ^BOOL(id object, UIViewController *controller) {
            [self showRateAppActionSheet];
            return YES;
        };
        NITableViewActionBlock tapAboutAction = ^BOOL(id object, UIViewController *controller) {
            [self showAboutView];
            return YES;
        };
        NSString* logoutLoginCellTitle = [RCGlobalConfig myToken].length ? LOGOUT_TITLE : LOGIN_TITLE;
        NSArray* tableContents =
        [NSArray arrayWithObjects:
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"清除缓存"]
                         tapBlock:tapClearCacheAction],
         @"",
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"更新检测"]
                         tapBlock:tapCheckLatestVersionAction],
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"给我评分"]
                         tapBlock:tapRateAction],
         @"",
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"关于APP"]
                         tapBlock:tapAboutAction],
         @"",
         [_actions attachToObject:[NITitleCellObject objectWithTitle:logoutLoginCellTitle]
                         tapBlock:tapLogoutLoginAction],
         nil];
        
        _cellFactory = [[NICellFactory alloc] init];
        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                         delegate:_cellFactory];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginNotification)
                                                     name:DID_LOGIN_NOTIFICATION object:nil];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
    
    self.navigationItem.leftBarButtonItem = [RCGlobalConfig createMenuBarButtonItemWithTarget:self
                                                                                       action:@selector(showLeft:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showAboutView
{
    RCAboutAppC* c = [[RCAboutAppC alloc] initWithNibName:NSStringFromClass([RCAboutAppC class])
                                                   bundle:nil];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showClearCaceActionSheet
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"清空所有缓存"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"清空"
                                           otherButtonTitles:nil];
    as.tag = ACTION_SHEET_TAG_CLEAR_CACHE;
    [as showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLogoutActionSheet
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"注销当前登录"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"注销"
                                           otherButtonTitles:nil];
    as.tag = ACTION_SHEET_TAG_LOGOUT;
    [as showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showRateAppActionSheet
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"您的评分就是我们的动力"
                                                    delegate:self
                                           cancelButtonTitle:@"暂不评分"
                                      destructiveButtonTitle:@"现在评分"
                                           otherButtonTitles:nil];
    as.tag = ACTION_SHEET_TAG_RATE_APP;
    [as showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)logout
{
    if ([RCGlobalConfig myToken]) {
        [RCAccountEntity deleteLoginedUserDiskData];
        [RCGlobalConfig setMyLoginId:nil];
        [RCGlobalConfig setMyToken:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_LOGOUT_NOTIFICATION object:nil];
        [RCGlobalConfig HUDShowMessage:@"注销成功" addedToView:self.view];
        self.logoutLoginCell.textLabel.text = LOGIN_TITLE;
        self.logoutLoginCell.backgroundColor = APP_THEME_COLOR;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [RCGlobalConfig HUDShowMessage:@"清除完成" addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)rateApp
{
    if (APP_ID > 1) {
        NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%ld", APP_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
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
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - DID_LOGIN_NOTIFICATION

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didLoginNotification
{
    self.logoutLoginCell.textLabel.text = LOGOUT_TITLE;
    self.logoutLoginCell.backgroundColor = RUBY_RED_COLOR;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIActionSheetDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if (ACTION_SHEET_TAG_RATE_APP == actionSheet.tag) {
                [self rateApp];
            }
            else if (ACTION_SHEET_TAG_LOGOUT == actionSheet.tag) {
                [self logout];
            }
            else if (ACTION_SHEET_TAG_CLEAR_CACHE == actionSheet.tag) {
                [self clearCache];
            }
        }
            break;

        default:
            break;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Customize the presentation of certain types of cells.
    if ([cell isKindOfClass:[NITextCell class]]) {
        NITextCell* textCell = (NITextCell *)cell;
        if ([textCell.textLabel.text isEqualToString:LOGOUT_TITLE]
            || [textCell.textLabel.text isEqualToString:LOGIN_TITLE]) {
            textCell.textLabel.textAlignment = NSTextAlignmentCenter;
            textCell.textLabel.font = [UIFont boldSystemFontOfSize:20.f];
            textCell.textLabel.textColor = [UIColor whiteColor];
            self.logoutLoginCell = textCell;
            
            if ([textCell.textLabel.text isEqualToString:LOGOUT_TITLE]) {
                textCell.backgroundColor = RUBY_RED_COLOR;
            }
            else if ([textCell.textLabel.text isEqualToString:LOGIN_TITLE]) {
                textCell.backgroundColor = APP_THEME_COLOR;
            }
        }
    }
}

@end
