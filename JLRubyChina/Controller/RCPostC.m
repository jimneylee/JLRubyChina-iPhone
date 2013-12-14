//
//  SNPostC.h
//  SkyNet
//
//  Created by jimneylee on 13-9-9.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCPostC.h"
#import "MBProgressHUD.h"
#import "RCPostModel.h"
#import "RCNodesCloudTagC.h"
#import "RCNodeEntity.h"

#define NODE_SELECT_PRIFIX_TITLE @"发布到："
#define TITLE_TEXT_MIN_COUNT 10
#define BODY_TEXT_MIN_COUNT 20

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface RCPostC ()<UITextViewDelegate, UITextFieldDelegate, RCNodesCloudTagDelegate>

@property (nonatomic, strong) UILabel* nodeNameLabel;
@property (nonatomic, strong) UITextField* titleTextField;
@property (nonatomic, strong) UITextView* bodyTextView;

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, strong) id delegate;
@property (nonatomic, copy) NSString* selectedNodeName;
@property (nonatomic, strong) RCPostModel* postModel;
@property (nonatomic, strong) RCNodeEntity* nodeEntity;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCPostC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发布新帖";
        self.navigationItem.rightBarButtonItem = [RCGlobalConfig createBarButtonItemWithTitle:@"发送"
                                                                                       Target:self
                                                                                       action:@selector(postAction)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
    
    // 这边本来放在init中，但是由于莫名的代码执行顺序混乱，故都在viewDidLoad执行 :(
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NSMutableArray* tableContents = [self generateTableContents];
    _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                     delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];
    
    self.tableView.tableFooterView = self.bodyTextView;
    
    // When including text editing cells in table views you should provide a means for the user to
    // stop editing the control. To do this we add a gesture recognizer to the table view.
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didTapTableView)];
    
    // We still want the table view to be able to process touch events when we tap.
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITextView*)bodyTextView
{
    if (!_bodyTextView) {
        CGFloat kViewHeight = [UIScreen mainScreen].bounds.size.height
                            - TTKeyboardHeightForOrientation(self.interfaceOrientation)
                            - NIStatusBarHeight() - NIToolbarHeightForOrientation(self.interfaceOrientation);
        CGFloat kTextViewWidth = self.view.width;
        _bodyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                kTextViewWidth, kViewHeight)];
        _bodyTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _bodyTextView.returnKeyType = UIReturnKeyDefault;
        _bodyTextView.font = [UIFont systemFontOfSize:18.0f];
        _bodyTextView.delegate = self;
        _bodyTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        _bodyTextView.backgroundColor = [UIColor whiteColor];
    }
    return _bodyTextView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*)generateTableContents
{
    NSMutableArray* tableContents = [NSMutableArray arrayWithCapacity:2];
    
    self.selectedNodeName = NODE_SELECT_PRIFIX_TITLE;
    [tableContents addObject:
     [_actions attachToObject:[NITitleCellObject objectWithTitle:self.selectedNodeName]
                  tapSelector:@selector(selectNodeAction)]];
    
    NITextInputFormElement* inputElement = nil;
    inputElement = [NITextInputFormElement textInputElementWithID:0
                                                  placeholderText:@"标题"
                                                            value:nil];
    inputElement.delegate = self;
    [tableContents addObject:inputElement];
    
    return tableContents;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)selectNodeAction
{
    // show node like tag cloud, so great idea :)
    RCNodesCloudTagC* c = [[RCNodesCloudTagC alloc] init];
    c.delegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

- (BOOL)checkPostBtnEnable
{
    if (self.nodeEntity.nodeName.length > 0
        && self.titleTextField.text.length >= TITLE_TEXT_MIN_COUNT
        && self.bodyTextView.text.length >= BODY_TEXT_MIN_COUNT) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return self.navigationItem.rightBarButtonItem.enabled;
}

- (BOOL)showMessageWithCheckAllValid
{
    NSString* nodeName = self.nodeEntity.nodeName;
    NSString* title = self.titleTextField.text;
    NSString* body = self.bodyTextView.text;
    BOOL checkAllValid = YES;

    if (!nodeName.length) {
        [RCGlobalConfig HUDShowMessage:@"还没选择分类" addedToView:self.view];
        checkAllValid = NO;
    }
    else if (title.length < TITLE_TEXT_MIN_COUNT) {
        [RCGlobalConfig HUDShowMessage:[NSString stringWithFormat:@"标题字数不少于%d", TITLE_TEXT_MIN_COUNT] addedToView:self.view];
        checkAllValid = NO;
    }
    else if (body.length < BODY_TEXT_MIN_COUNT) {
        [RCGlobalConfig HUDShowMessage:[NSString stringWithFormat:@"正文字数不少于%d", BODY_TEXT_MIN_COUNT] addedToView:self.view];
        checkAllValid = NO;
    }
    
    return checkAllValid;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postAction
{
    NSString* title = self.titleTextField.text;
    NSString* body = self.bodyTextView.text;
    BOOL checkAllValid = [self showMessageWithCheckAllValid];
    
    if (checkAllValid) {
        if (!self.postModel) {
            self.postModel = [[RCPostModel alloc] init];
        }
        
        __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"正在发布...";
        
#if 0//debug simulator post success than back to refresh new
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"发布成功";
        [hud hide:YES afterDelay:1.5f];
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.postDelegate respondsToSelector:@selector(didPostNewTopic)]) {
            [self.postDelegate didPostNewTopic];
        }
#else
        [self.postModel postNewTopicWithTitle:title
                                         body:body
                                       nodeId:self.nodeEntity.nodeId
                                      success:^{
                                          hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                          hud.mode = MBProgressHUDModeCustomView;
                                          hud.labelText = @"发布成功";
                                          [hud hide:YES afterDelay:1.5f];
                                          
                                          // delegate to refresh
                                          [self.navigationController popViewControllerAnimated:YES];
                                          if ([self.postDelegate respondsToSelector:@selector(didPostNewTopic)]) {
                                              [self.postDelegate didPostNewTopic];
                                          }
                                      } failure:^(NSError *error) {
                                          hud.labelText = @"发布失败，请重试！";
                                          [hud hide:YES afterDelay:1.5f];
                                      }];
#endif
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gesture Recognizers

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didTapTableView {
    [self.view endEditing:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[NITextInputFormElementCell class]]) {
        if (!self.titleTextField) {
            NITextInputFormElementCell* textInputCell = (NITextInputFormElementCell *)cell;
            self.titleTextField = textInputCell.textField;
            [self.titleTextField addTarget:self
                                    action:@selector(textFieldDidChangeValue)
                          forControlEvents:UIControlEventAllEditingEvents];
        }
    }
    else if ([cell isKindOfClass:[NITextCell class]]) {
        if (!self.nodeNameLabel) {
            NITextCell* textCell = (NITextCell*)cell;
            self.nodeNameLabel = textCell.textLabel;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidChangeValue {
    [self checkPostBtnEnable];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RCNodesCloudTagDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectANode:(RCNodeEntity*)nodeEntity
{
    self.nodeEntity = nodeEntity;
    self.nodeNameLabel.text = [NSString stringWithFormat:@"%@%@",
                               NODE_SELECT_PRIFIX_TITLE, nodeEntity.nodeName];
    [self checkPostBtnEnable];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChange:(UITextView *)textView
{
    [self checkPostBtnEnable];
}

@end
