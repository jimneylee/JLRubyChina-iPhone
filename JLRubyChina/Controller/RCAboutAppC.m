//
//  RCAboutAppC.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/14/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCAboutAppC.h"
#import "NIAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
#import "NIWebController.h"

@interface RCAboutAppC ()<NIAttributedLabelDelegate>

@end

@implementation RCAboutAppC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于APP";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNameLabel];
    [self setupSiteUrlLabel];
    [self setupDevIntroduceLabel];
    self.versionLabel.text = [NSString stringWithFormat:@"version: %@", APP_VERSION];

// for screenshot create default images, donot laught at me! :)
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
//    {
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
//    else
//    {
//        // iOS 6
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    }
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNameLabel
{
    // copy from nimbus CustomTextAttributedLabelViewController
    NSString* string = self.nameLabel.text;
    NSRange rangeOfRuby = [string rangeOfString:@"Ruby"];
    NSRange rangeOfChina = [string rangeOfString:@"China"];
    
    // We must create a mutable attributed string in order to set the CoreText properties.
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string];
    
    // See http://iosfonts.com/ for a list of all fonts supported out of the box on iOS.
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:26];
    [text setFont:font range:rangeOfRuby];
    [text setFont:font range:rangeOfChina];
    [text setTextColor:RUBY_RED_COLOR range:rangeOfRuby];
    [text setTextColor:RGBCOLOR(200, 200, 200) range:rangeOfChina];

    self.nameLabel.attributedText = text;
    self.nameLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.nameLabel.shadowColor = RUBY_RED_COLOR;
}

- (void)setupSiteUrlLabel
{
    self.siteUrlLabel.delegate = self;
    self.siteUrlLabel.autoDetectLinks = YES;
    self.siteUrlLabel.linksHaveUnderlines = YES;
    self.siteUrlLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
}

- (void)setupDevIntroduceLabel
{
    self.devIntroduceLabel.delegate = self;
    self.devIntroduceLabel.autoDetectLinks = YES;
    self.devIntroduceLabel.linksHaveUnderlines = YES;
    self.devIntroduceLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
}

#pragma mark - NIAttributedLabelDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)attributedLabel:(NIAttributedLabel*)attributedLabel
didSelectTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point {
    if (NSTextCheckingTypeLink == result.resultType) {
        NIWebController* webC = [[NIWebController alloc] initWithURL:result.URL];
        [self.navigationController pushViewController:webC animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)attributedLabel:(NIAttributedLabel *)attributedLabel
shouldPresentActionSheet:(UIActionSheet *)actionSheet
 withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    return NO;
}

@end
