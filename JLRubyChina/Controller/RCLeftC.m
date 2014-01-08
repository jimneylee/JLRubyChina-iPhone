//
//  LeftViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "RCLeftC.h"
#import "NIAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "RCForumTopicsC.h"
#import "RCForumNodesC.h"
#import "RCCoolSitesC.h"
#import "RCTopMembersC.h"
#import "RCWikiC.h"
#import "RCUserHomepageC.h"
#import "RCMoreC.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface FELeftCell : UITableViewCell
@property (nonatomic, retain) UIImageView* lineImageView;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FELeftCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineImageView.bottom = self.height;
}

- (UIImageView*)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"setting_line.png"]];
        [self addSubview:_lineImageView];
    }
    return _lineImageView;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface RCLeftC ()
@property (strong, nonatomic) UITableView* tableView;
@property (nonatomic) LeftMenuType currentMenuType;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCLeftC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_THEME_COLOR;
    self.tableView.frame = CGRectMake(0.f, 0.f,
                                      self.view.width * LEFT_GAP_PERCENTAGE,
                                      self.view.height);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = APP_THEME_COLOR;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [self createTableHeaderView];
    self.tableView.tableFooterView = [self createTableFooterView];
    
    [self setSelectedMenuType:LeftMenuType_Home];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelectedMenuType:(LeftMenuType)type
{
    self.currentMenuType = type;
    // 默认刚开始选中
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentMenuType
                                                            inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (UIView*)createTableHeaderView
{
    CGFloat tableHeaderHeight = IOS_IS_AT_LEAST_7
    ? NIStatusBarHeight() + NIToolbarHeightForOrientation(self.interfaceOrientation)
    : NIToolbarHeightForOrientation(self.interfaceOrientation);
    
    // copy from nimbus CustomTextAttributedLabelViewController
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, tableHeaderHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    NSString* string = APP_NAME;//@"Ruby China"
    NSArray* words = [APP_NAME componentsSeparatedByString:@" "];
    NSRange rangeOfRuby = NSMakeRange(0, 0);
    NSRange rangeOfChina = NSMakeRange(0, 0);
    if (words.count >= 2) {
        rangeOfRuby = [string rangeOfString:words[0]];//@"Ruby"
        rangeOfChina = [string rangeOfString:words[1]];//@"China"
    }

    // We must create a mutable attributed string in order to set the CoreText properties.
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string];
    
    // See http://iosfonts.com/ for a list of all fonts supported out of the box on iOS.
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:26];
    [text setFont:font range:rangeOfRuby];
    [text setFont:font range:rangeOfChina];
    [text setTextColor:APP_NAME_RED_COLOR range:rangeOfRuby];
    [text setTextColor:APP_NAME_WHITE_COLOR range:rangeOfChina];
    NIAttributedLabel* label = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = text;
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.shadowColor = APP_NAME_RED_COLOR;
    label.backgroundColor = [UIColor clearColor];
    if (IOS_IS_AT_LEAST_7) {
        label.frame = CGRectInset(self.view.bounds, 10.f, 5.f + NIStatusBarHeight());
    }
    else {
        label.frame = CGRectInset(self.view.bounds, 10.f, 5.f);
    }

    [view addSubview:label];
    
    return view;
}

- (UIView*)createTableFooterView
{
    CGFloat tableHeaderHeight = 66.f;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, tableHeaderHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ruby-logo.png"]];
    logoImageView.center = CGPointMake(view.width / 2, view.height / 2);
    [view addSubview:logoImageView];
    return view;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return LeftMenuType_End;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftViewCell";
    FELeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FELeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSString* title = nil;
    switch (indexPath.row) {
        case LeftMenuType_Home:
            title = @"热门讨论";
            break;
            
        case LeftMenuType_ForumNodes:
            title = @"节点分类";
            break;
            
        case LeftMenuType_CoolSites:
            title = @"酷站导航";
            break;
            
        case LeftMenuType_TopMembers:
            title = @"活跃会员";
            break;
            
        case LeftMenuType_MyHomePage:
            title = @"我的主页";
            break;
            
        case LeftMenuType_Wiki:
            title = @"RCWiki";
            break;
            
        case LeftMenuType_More:
            title = @"更多设置";
            break;
            
        default:
            break;
    }
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    UIColor* bgColor = RGBACOLOR(71.f, 139.f, 201.f, 0.2f);
    UIView* bgView = [[UIView alloc] init];
    bgView.backgroundColor = bgColor;
    cell.selectedBackgroundView = bgView;
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != self.currentMenuType) {
        switch (indexPath.row) {
            case LeftMenuType_Home:
            {
                RCForumTopicsC *c = [[RCForumTopicsC alloc] initWithTopicsType:RCForumTopicsType_LatestActivity];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                nav.navigationBar.translucent = NO;
                self.sidePanelController.centerPanel = nav;
            }
                break;
                
            case LeftMenuType_ForumNodes:
            {
                RCForumNodesC* c = [[RCForumNodesC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                nav.navigationBar.translucent = NO;
                self.sidePanelController.centerPanel = nav;
            }
                break;
                
            case LeftMenuType_CoolSites:
            {
                RCCoolSitesC* c = [[RCCoolSitesC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                nav.navigationBar.translucent = NO;
                self.sidePanelController.centerPanel = nav;
            }
                break;
                
            case LeftMenuType_TopMembers:
            {
                RCTopMembersC* c = [[RCTopMembersC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                nav.navigationBar.translucent = NO;
                self.sidePanelController.centerPanel = nav;
            }
                break;
                
            case LeftMenuType_MyHomePage:
            {
                RCUserHomepageC *c = [[RCUserHomepageC alloc] initWithMyLoginId:[RCGlobalConfig myLoginId]];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                nav.navigationBar.translucent = NO;
                self.sidePanelController.centerPanel = nav;
            }
                break;
                
            case LeftMenuType_Wiki:
            {
                RCWikiC* c = [[RCWikiC alloc] initWithURL:[NSURL URLWithString:HOST_WIKI_URL]];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                nav.navigationBar.translucent = NO;
                self.sidePanelController.centerPanel = nav;
            }
                break;
                
            case LeftMenuType_More:
            {
                RCMoreC* c = [[RCMoreC alloc] initWithStyle:UITableViewStyleGrouped];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                nav.navigationBar.translucent = NO;
                self.sidePanelController.centerPanel = nav;
            }
                break;
        }
        self.currentMenuType = indexPath.row;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGFloat tableHeaderHeight = IOS_IS_AT_LEAST_7
//    ? NIStatusBarHeight() + NIToolbarHeightForOrientation(self.interfaceOrientation)
//    : NIToolbarHeightForOrientation(self.interfaceOrientation);
//    
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableHeaderHeight)];
//    view.backgroundColor = [UIColor clearColor];
//    
//    UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ruby-logo.png"]];
//    logoImageView.center = CGPointMake(view.width / 2, view.height / 2);
//    [view addSubview:logoImageView];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat tableHeaderHeight = IOS_IS_AT_LEAST_7
//    ? NIStatusBarHeight() + NIToolbarHeightForOrientation(self.interfaceOrientation)
//    : NIToolbarHeightForOrientation(self.interfaceOrientation);
//    return tableHeaderHeight;
//}

@end
