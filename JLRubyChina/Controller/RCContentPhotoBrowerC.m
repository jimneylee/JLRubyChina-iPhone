//
//  SNPhotoBrowerC.m
//  SkyNet
//
//  Created by jimneylee on 13-10-21.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCContentPhotoBrowerC.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface SNContentPhotoView : NINetworkImageView <NIRecyclableView, NIPagingScrollViewPage>
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SNContentPhotoView
@synthesize pageIndex = _pageIndex;
@synthesize reuseIdentifier = _reuseIdentifier;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:CGRectZero])) {
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    
}

@end

#define PHOTO_BG_COLOR RGBCOLOR(224, 224, 224)
#define PAGECONTROL_HEIGHT 20

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface RCContentPhotoBrowerC()<NIPagingScrollViewDataSource, NIPagingScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NIPagingScrollView* pagingScrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) NSArray* photoUrls;

@end

@implementation RCContentPhotoBrowerC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPhotoUrls:(NSArray*)photoUrls
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.photoUrls = photoUrls;
        self.navigationItem.rightBarButtonItem = [RCGlobalConfig createBarButtonItemWithTitle:@"保存"
                                                                                       Target:self
                                                                                       action:@selector(saveThisPhoto)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pagingScrollView = [[NIPagingScrollView alloc] initWithFrame:self.view.bounds];
    _pagingScrollView.dataSource = self;
    _pagingScrollView.delegate = self;
    [self.view addSubview:_pagingScrollView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(showOrHideTopBar)];
    [_pagingScrollView addGestureRecognizer:tapGesture];
    
    CGFloat kHeight = 20.f;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, PAGECONTROL_HEIGHT,//self.view.height - PAGECONTROL_HEIGHT * 2,
                                                                   self.view.width, kHeight)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = APP_THEME_COLOR;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = self.photoUrls.count;
    [_pageControl addTarget:self action:@selector(didChangePageIndex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    [self.pagingScrollView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didChangePageIndex:(id)sender
{
    [self.pagingScrollView moveToPageAtIndex:self.pageControl.currentPage
                                    animated:YES];
}

- (void)showTopBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)hideTopBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)showOrHideTopBar
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden
                                             animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:!self.navigationController.navigationBarHidden
                                            withAnimation:UIStatusBarAnimationSlide];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveThisPhoto
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SNContentPhotoView* photoView = (SNContentPhotoView*)[_pagingScrollView.dataSource pagingScrollView:_pagingScrollView
                                                                                       pageViewForIndex:self.pagingScrollView.centerPageIndex];
    if (photoView.image) {
        UIImageWriteToSavedPhotosAlbum(photoView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"保存失败"
                                                     message:@"图片还未下载好，请稍后保存!" delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SavedPhotosAlbum CallBack

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL) {
        // Show error message…
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"保存失败"
                                                     message:@"请重新保存或查看是否有足够空间" delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
    }
    else { // No errors
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"保存成功";
        HUD.removeFromSuperViewOnHide = YES;
        [HUD show:YES];
        
        [HUD hide:YES afterDelay:1];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NIPagingScrollViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
    return self.photoUrls.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView
                                    pageViewForIndex:(NSInteger)pageIndex {
    NSString* reuseIdentifier = NSStringFromClass([SNContentPhotoView class]);
    SNContentPhotoView *page = (SNContentPhotoView *)[pagingScrollView
                                                          dequeueReusablePageWithIdentifier:reuseIdentifier];
    if (!page) {
        page = [[SNContentPhotoView alloc] initWithReuseIdentifier:reuseIdentifier];
        page.frame = CGRectMake(0.f, 0.f, self.view.width, self.pagingScrollView.height);
        page.contentMode = UIViewContentModeScaleAspectFit;
    }
    [page setPathToNetworkImage:[self.photoUrls objectAtIndex:pageIndex] contentMode:UIViewContentModeScaleAspectFit];
    return page;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NIPagingScrollViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pagingScrollViewDidChangePages:(NIPagingScrollView *)pagingScrollView
{
    self.pageControl.currentPage = pagingScrollView.centerPageIndex;
}

@end
