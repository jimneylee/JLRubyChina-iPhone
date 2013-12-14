//
//  RCQuickReplyC.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/12/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "RCQuickReplyC.h"
#import "RCReplyModel.h"

#define BTN_TITLE_REPLY @"回复"
#define BTN_TITLE_CANCEL @"取消"

@interface RCQuickReplyC ()
@property (nonatomic, assign) unsigned long topicId;
@property(nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton* sendBtn;
@end

@implementation RCQuickReplyC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTopicId:(unsigned long)topicId
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.topicId = topicId;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat kViewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kViewHeight = 44.f;
    self.view.frame = CGRectMake(0, 0, kViewWidth, kViewHeight);
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    CGFloat kTextViewWidth = 240.f;
    CGFloat kTextViewMaxHeight = [UIScreen mainScreen].bounds.size.height
                                - TTKeyboardHeightForOrientation(self.interfaceOrientation)
                                - NIStatusBarHeight() - NIToolbarHeightForOrientation(self.interfaceOrientation) * 2;
	self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(CELL_PADDING_6, CELL_PADDING_4,
                                                                        kTextViewWidth, kViewHeight)];
    self.textView.isScrollable = YES;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	self.textView.minNumberOfLines = 1;
    self.textView.maxHeight = kTextViewMaxHeight;
	self.textView.returnKeyType = UIReturnKeyDefault;
	self.textView.font = [UIFont systemFontOfSize:17.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholder = @"我也说几句...";
    [self.view addSubview:self.containerView];
	
    UIImage* textViewBgSourceImage = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage* textViewBgImage = [textViewBgSourceImage stretchableImageWithLeftCapWidth:textViewBgSourceImage.size.width / 2
                                                                    topCapHeight:textViewBgSourceImage.size.height / 2];
    UIImageView* textViewImageView = [[UIImageView alloc] initWithImage:textViewBgImage];
    CGFloat kTextViewBgImageViewWidth = 248.f;
    textViewImageView.frame = CGRectMake(5, 0, kTextViewBgImageViewWidth, kViewHeight);
    textViewImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    UIImage* mainBgSourceImage = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage* mainBgImage = [mainBgSourceImage stretchableImageWithLeftCapWidth:mainBgSourceImage.size.width / 2
                                                                 topCapHeight:mainBgSourceImage.size.height / 2];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:mainBgImage];
    imageView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [self.containerView addSubview:imageView];
    [self.containerView addSubview:self.textView];
    [self.containerView addSubview:textViewImageView];
    
    UIImage* sendBtnBgSourceImage = [UIImage imageNamed:@"MessageEntrySendButton.png"];
    UIImage* sendBtnBgImage = [sendBtnBgSourceImage stretchableImageWithLeftCapWidth:sendBtnBgSourceImage.size.width / 2
                                                                        topCapHeight:0];
    CGFloat kSendbtnWidth = 63.f;
    CGFloat kSendBtnHeight = 27.f;
    
	UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	sendBtn.frame = CGRectMake(self.containerView.frame.size.width - kSendbtnWidth - CELL_PADDING_6,
                               CELL_PADDING_8, kSendbtnWidth, kSendBtnHeight);
    sendBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[sendBtn setTitle:BTN_TITLE_CANCEL forState:UIControlStateNormal];
    [sendBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    sendBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[sendBtn addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundImage:sendBtnBgImage forState:UIControlStateNormal];
    self.sendBtn = sendBtn;
    
	[self.containerView addSubview:sendBtn];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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
-(void)replyAction
{
    if (self.textView.text.length) {
        RCReplyModel* replyModel = [[RCReplyModel alloc] init];
        [replyModel replyTopicId:self.topicId
                            body:self.textView.text
                         success:^{
                             self.textView.text = @"";
                             [self.textView resignFirstResponder];
                             MBProgressHUD* hud = [RCGlobalConfig HUDShowMessage:@"回复成功!" addedToView:self.view];
                             hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                             hud.mode = MBProgressHUDModeCustomView;
                             if ([self.replyDelegate respondsToSelector:@selector(didReplySuccess)]) {
                                 [self.replyDelegate didReplySuccess];
                             }
                             // 是否需要刷新后，自动滑动到底部，有待考虑，有时需要一次回复多个人，后面看大家使用反馈
                         } failure:^(NSError *error) {
                             [RCGlobalConfig HUDShowMessage:@"回复失败!" addedToView:self.view];
                             if ([self.replyDelegate respondsToSelector:@selector(didReplyFailure)]) {
                                 [self.replyDelegate didReplyFailure];
                             }
                         }];
    }
    else {
        [self.textView resignFirstResponder];
        if ([self.replyDelegate respondsToSelector:@selector(didReplyCancel)]) {
            [self.replyDelegate didReplyCancel];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)appendString:(NSString*)string
{
    if (self.textView.text.length) {
        self.textView.text = [NSString stringWithFormat:@"%@ %@", self.textView.text, string];
    }
    else {
        self.textView.text = string;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - HPGrowingTextViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (0 == growingTextView.text.length) {
        [self.sendBtn setTitle:BTN_TITLE_CANCEL forState:UIControlStateNormal];
    }
    else {
        [self.sendBtn setTitle:BTN_TITLE_REPLY forState:UIControlStateNormal];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.containerView.frame = r;
}

@end
