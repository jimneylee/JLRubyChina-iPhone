//
//  LeftViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "RCLeftC.h"

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
        // Custom initialization
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
    
    //UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"left_side_bg.jpg"]];
    UIColor* bgColor = APP_THEME_COLOR;
    self.view.backgroundColor = bgColor;
    [self.tableView setFrame:CGRectMake(0.f, 0.f,
                                        self.view.width - SIDE_DIRECTION_LEFT_OFFSET,
                                        self.view.height)];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
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
    return LeftMenuType_AboutUs + 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftViewCell";
    FELeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FELeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSString* title = nil;
    switch (indexPath.row) {
        case LeftMenuType_Home:
            title = @"热门讨论";
            break;
            
        case LeftMenuType_ForumNodes:
            title = @"分类导航";
            break;
            
        case LeftMenuType_UserCenter:
            title = @"个人中心";
            break;
            
        case LeftMenuType_More:
            title = @"更多设置";
            break;
            
        case LeftMenuType_AboutUs:
            title = @"关于我们";
            break;
            
        default:
            break;
    }
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    UIColor* bgColor = RGBACOLOR(71.f, 139.f, 201.f, 0.2f);
    UIView* bgView = [[UIView alloc] init];
    bgView.backgroundColor = bgColor;
    [cell setSelectedBackgroundView:bgView];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != self.currentMenuType) {
        if ([self.delegate respondsToSelector:@selector(didSelectLeftMenuType:)]) {
            [self.delegate didSelectLeftMenuType:indexPath.row];
            self.currentMenuType = indexPath.row;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableHeaderHeight = IOS_IS_AT_LEAST_7
    ? NIStatusBarHeight() + NIToolbarHeightForOrientation(self.interfaceOrientation)
    : NIToolbarHeightForOrientation(self.interfaceOrientation);
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableHeaderHeight)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat tableHeaderHeight = IOS_IS_AT_LEAST_7
    ? NIStatusBarHeight() + NIToolbarHeightForOrientation(self.interfaceOrientation)
    : NIToolbarHeightForOrientation(self.interfaceOrientation);
    return tableHeaderHeight;
}

@end
