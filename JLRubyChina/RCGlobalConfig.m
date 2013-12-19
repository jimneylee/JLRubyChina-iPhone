//
//  RCGlobalConfig.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCGlobalConfig.h"
#import "RCLoginC.h"

static NSString* myToken = nil;
static NSString* myLoginId = nil;
@implementation RCGlobalConfig

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global Data

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)myToken
{
    return myToken;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setMyToken:(NSString*)token
{
    myToken = [token copy];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)myLoginId
{
    return myLoginId;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setMyLoginId:(NSString*)loginId
{
    myLoginId = [loginId copy];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global UI

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view
{
    static MBProgressHUD* hud = nil;
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.hidden = NO;
    hud.alpha = 1.0f;
    [hud hide:YES afterDelay:1.0f];
    return hud;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle Target:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action
{
    //return [RCGlobalConfig createBarButtonItemWithTitle:@"菜单" Target:target action:action];
    return [[UIBarButtonItem alloc] initWithImage:[UIImage nimbusImageNamed:@"icon_menu.png"]
                                            style:UIBarButtonItemStylePlain
                                           target:target action:action];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                         target:target action:action];
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showLoginControllerFromNavigationController:(UINavigationController*)navigationController
{
    RCLoginC* loginC = [[RCLoginC alloc] initWithStyle:UITableViewStyleGrouped];
    [navigationController pushViewController:loginC animated:YES];
}

// emoji -> code
+ (NSDictionary *)emojiReverseAliases {
    static NSDictionary *_emojiReverseAliases;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emojiReverseAliases = @{
            @"\U0001F604" : @":smile:",
            @"\U0001F60A" : @":blush:",
            @"\U0001F603" : @":smiley:",
//            @"\u263A",
            @"\U0001F609" : @":wink:",
            @"\U0001F60D" : @":heart_eyes:",
            @"\U0001F618" : @":kissing_heart:",
            @"\U0001F61A" : @":kissing_closed_eyes:",
            @"\U0001F633" : @":flushed:",
            @"\U0001F60C" : @":relieved:",
            @"\U0001F601" : @":grin:",
            @"\U0001F61C" : @":stuck_out_tongue_winking_eye:",
            @"\U0001F61D" : @":stuck_out_tongue_closed_eyes:",
            @"\U0001F612" : @":unamused:",
            @"\U0001F60F" : @":smirk:",
            @"\U0001F613" : @":sweat:",
            @"\U0001F614" : @":pensive:",
            @"\U0001F61E" : @":disappointed:",
            @"\U0001F616" : @":confounded:",
            @"\U0001F625" : @":disappointed_relieved:",
            @"\U0001F630" : @":cold_sweat:",
            @"\U0001F628" : @":fearful:",
            @"\U0001F623" : @":persevere:",
            @"\U0001F622" : @":cry:",
            @"\U0001F62D" : @":sob:",
            @"\U0001F602" : @":joy:",
            @"\U0001F632" : @":astonished:",
            @"\U0001F631" : @":scream:",
        };
    });
    return _emojiReverseAliases;
}

@end
