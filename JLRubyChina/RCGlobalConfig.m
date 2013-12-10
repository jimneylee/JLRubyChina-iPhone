//
//  RCGlobalConfig.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCGlobalConfig.h"

@implementation RCGlobalConfig

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global UI

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showHUDMessage:(NSString*)msg addedToView:(UIView*)view
{
    __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [hud hide:YES afterDelay:1.0f];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIColor *)mainThemeColor
{
    // dz 250 137 33
    NSDictionary* colors = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"APP_THEME_COLORS"];
    if (colors.allKeys.count >= 4) {
        NSString* r = [colors objectForKey:@"r"];
        NSString* g = [colors objectForKey:@"g"];
        NSString* b = [colors objectForKey:@"b"];
        NSString* a = [colors objectForKey:@"a"];
        if (r && g && b && a) {
            return RGBACOLOR([r intValue], [g intValue], [b intValue], [a floatValue]);
        }
    }
    // default theme color
    return [UIColor redColor];
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
    return [RCGlobalConfig createBarButtonItemWithTitle:@"菜单" Target:target action:action];
}

@end
