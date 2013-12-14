//
//  RCAboutAppC.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/14/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIAttributedLabel;
@interface RCAboutAppC : UIViewController
@property (nonatomic, strong) IBOutlet NIAttributedLabel* nameLabel;
@property (nonatomic, strong) IBOutlet NIAttributedLabel* siteUrlLabel;
@property (nonatomic, strong) IBOutlet NIAttributedLabel* devIntroduceLabel;
@property (nonatomic, strong) IBOutlet NIAttributedLabel* versionLabel;
@end
