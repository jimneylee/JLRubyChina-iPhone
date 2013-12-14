//
//  RCTopUsersC.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/14/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCTopMembersC.h"
#import "RCUserEntity.h"
#import "RCTopMembersModel.h"

@interface RCTopMembersC ()

@end

@implementation RCTopMembersC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"TOP活跃会员";
        self.navigationItem.leftBarButtonItem = [RCGlobalConfig createMenuBarButtonItemWithTarget:self
                                                                                           action:@selector(showLeft:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [RCTopMembersModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[RCUserEntity class]]) {
                RCUserEntity* o = (RCUserEntity*)object;
                [RCGlobalConfig hudShowMessage:o.username addedToView:self.view];
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForEmpty
{
    NSString* msg = @"信息为空";
    [RCGlobalConfig hudShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForError
{
    NSString* msg = @"抱歉，无法获取信息，请稍后再试！";
    [RCGlobalConfig hudShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMssageForLastPage
{
    //NSString* msg = @"已是最后一页";
    //[RCGlobalConfig hudShowMessage:msg addedToView:self.view];
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

@end
