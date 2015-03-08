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

#define CREATE_DEFAULT_IMAGE 0

@interface RCAboutAppC ()<NIAttributedLabelDelegate>
@property (nonatomic, assign) BOOL toCreateLauchImage;
@end

@implementation RCAboutAppC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (instancetype)initWithCreateLauchImage:(BOOL)toCreateLauchImage
{
    self = [super initWithNibName:NSStringFromClass([RCAboutAppC class])
                           bundle:nil];
    if (self) {
        self.toCreateLauchImage = toCreateLauchImage;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于APP";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNameLabel];
    [self setupSiteUrlLabel];
    [self setupSiteIntroduceTextView];
    [self setupDevIntroduceLabel];
    
    self.versionLabel.text = [NSString stringWithFormat:@"version: %@", APP_VERSION];
    self.versionLabel.hidden = self.toCreateLauchImage;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.toCreateLauchImage) {
        // for screenshot create default image, donot laught at me! :)
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
        else {
            // iOS 6
            [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                    withAnimation:UIStatusBarAnimationSlide];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupNameLabel
{
    // copy from nimbus CustomTextAttributedLabelViewController
    self.nameLabel.text = APP_NAME;
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

    self.nameLabel.attributedText = text;
    self.nameLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.nameLabel.shadowColor = APP_NAME_RED_COLOR;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupSiteUrlLabel
{
    self.siteUrlLabel.text = HOST_URL;
    self.siteUrlLabel.delegate = self;
    self.siteUrlLabel.autoDetectLinks = YES;
    self.siteUrlLabel.linksHaveUnderlines = YES;
    self.siteUrlLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupSiteIntroduceTextView
{
    self.siteIntroduceTextView.text = HOST_INTRO;
    self.siteIntroduceTextView.scrollEnabled = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupDevIntroduceLabel
{
    self.devIntroduceLabel.delegate = self;
    self.devIntroduceLabel.autoDetectLinks = YES;
    self.devIntroduceLabel.linksHaveUnderlines = YES;
    self.devIntroduceLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)prefersStatusBarHidden {
    if (self.toCreateLauchImage) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
