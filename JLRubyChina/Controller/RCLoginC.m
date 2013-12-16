//
//  RCLoginC.m
//  JLRubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCLoginC.h"
#import "RCLoginModel.h"
#import "RCUserFullEntity.h"

#define USERNAME_INDEX 0
#define PASSWORD_INDEX 1

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface RCLoginC ()

@property (nonatomic, readwrite, retain) NITextInputFormElement* usernameTextInput;
@property (nonatomic, readwrite, retain) NITextInputFormElement* passwordTextInput;
@property (nonatomic, readwrite, retain) UITextField* usernameTextField;
@property (nonatomic, readwrite, retain) UITextField* passwordTextField;
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) NICellFactory* cellFactory;
@property (nonatomic, readwrite, retain) RCLoginModel* userModel;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCLoginC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
        NSString* username = nil;
        NSString* password = nil;
#ifdef DEBUG
        username = @"jimneylee@gmail.com";
        password = @"";
#endif
        self.usernameTextInput = [NITextInputFormElement textInputElementWithID:0
                                                                placeholderText:@"用户名" value:username];
        self.passwordTextInput = [NITextInputFormElement passwordInputElementWithID:0
                                                                    placeholderText:@"密码" value:password];
        
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        NSArray* tableContents =
        [NSArray arrayWithObjects:
         self.usernameTextInput,
         self.passwordTextInput,
         @"",
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"登录"]
                         tapSelector:@selector(loginAction)],
         nil];
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                         delegate:(id)[NICellFactory class]];
        _userModel = [[RCLoginModel alloc] init];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Model

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginAction
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if (self.usernameTextInput.value.length && self.passwordTextInput.value.length) {
        [self loginWithUsername:self.usernameTextInput.value password:self.passwordTextInput.value];
    }
    else {
        __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户名或密码为空";
        [hud hide:YES afterDelay:1.5f];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginWithUsername:(NSString*)username password:(NSString *)password
{    
    __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录...";
    [self.userModel loginWithUsername:username
                              password:password
                                 block:^(RCAccountEntity* user, NSError* error) {
        if (user) {
            NSLog(@"login success");
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"登录成功，欢迎来到ruby china！";
            [hud hide:YES afterDelay:1.5f];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_LOGIN_NOTIFICATION
                                                                object:nil userInfo:nil];
        }
        else {
            NSLog(@"login failed");
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"登录失败，用户名或密码有错！";
            [hud hide:YES afterDelay:1.5f];
        }
    }];
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
    if ([cell isKindOfClass:[NITextInputFormElementCell class]]) {
        NITextInputFormElementCell* textInputCell = (NITextInputFormElementCell *)cell;
        textInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (USERNAME_INDEX == indexPath.row) {
            self.usernameTextField = textInputCell.textField;
            self.usernameTextField.clearsOnBeginEditing = NO;
            self.usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
        }
        else if(PASSWORD_INDEX == indexPath.row) {
            self.passwordTextField = textInputCell.textField;
            self.passwordTextField.clearsOnBeginEditing = NO;
            self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
        }
    }
    else if ([cell isKindOfClass:[NITextCell class]]) {
        NITextCell* textCell = (NITextCell *)cell;
        textCell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
