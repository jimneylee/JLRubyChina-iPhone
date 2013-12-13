//
//  RCForumNodesCloudTagC.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-13.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCForumNodesCloudTagC.h"
#import "RCForumNodesModel.h"
#import "RCNodeEntity.h"
#import "RTagCloudView.h"

@interface RCForumNodesCloudTagC ()<RTagCloudViewDelegate,RTagCloudViewDatasource>
@property (nonatomic, strong) RTagCloudView* tagCloudView;
@property (nonatomic, strong) RCForumNodesModel* model;
@property (nonatomic, strong) NSArray* nodesArray;
@end

@implementation RCForumNodesCloudTagC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.model = [[RCForumNodesModel alloc] init];
        self.title = @"请选择分类";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.model loadDataWithBlock:^(NSArray *items, NSError *error) {
        self.nodesArray = self.model.nodesArray;
        self.tagCloudView = self.tagCloudView;
    } more:NO refresh:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.model.isLoading) {
        [self.model cancelRequstOperation];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (RTagCloudView*)tagCloudView
{
    if (!_tagCloudView) {
        _tagCloudView = [[RTagCloudView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _tagCloudView.backgroundColor = [UIColor blackColor];
        _tagCloudView.center = CGPointMake(self.view.width /2, self.view.height / 2);
        _tagCloudView.dataSource = self;
        _tagCloudView.delegate = self;
        [self.view addSubview:_tagCloudView];
    }
    return _tagCloudView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RTagCloudViewDatasource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfTags:(RTagCloudView *)tagCloud
{
    return self.nodesArray.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)RTagCloudView:(RTagCloudView *)tagCloud
            tagNameOfIndex:(NSInteger)index
{
    if (index < self.nodesArray.count) {
        RCNodeEntity* node = self.nodesArray[index];
        return node.nodeName;
    }
    return @"未知分类";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)RTagCloudView:(RTagCloudView *)tagCloud
          tagFontOfIndex:(NSInteger)index
{
    CGFloat fontSize = 14.f;
    if (index < self.nodesArray.count) {
        RCNodeEntity* node = self.nodesArray[index];
        if (node.topicsCount > 2500) {
            fontSize = 30.f;
        }
        else if (node.topicsCount > 2000) {
            fontSize = 28.f;
        }
        else if (node.topicsCount > 1500) {
            fontSize = 26.f;
        }
        else if (node.topicsCount > 1000) {
            fontSize = 24.f;
        }
        else if (node.topicsCount > 500) {
            fontSize = 22.f;
        }
        else if (node.topicsCount > 200) {
            fontSize = 20.f;
        }
        else if (node.topicsCount > 100) {
            fontSize = 18.f;
        }
        else if (node.topicsCount > 50) {
            fontSize = 16.f;
        }
        else {
            fontSize = 14.f;
        }
    }
    return [UIFont systemFontOfSize:fontSize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)RTagCloudView:(RTagCloudView *)tagCloud tagColorOfIndex:(NSInteger)index
{
    UIColor *colors[] = {
        [UIColor redColor],
        [UIColor yellowColor],
        [UIColor blueColor],
        [UIColor orangeColor],
        [UIColor blackColor],
        [UIColor purpleColor],
        [UIColor greenColor]
    };
    return colors[index%7];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RTagCloudViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)RTagCloudView:(RTagCloudView*)tagCloud didTapOnTagOfIndex:(NSInteger)index
{
    if (index < self.nodesArray.count) {
        RCNodeEntity* node = self.nodesArray[index];
        self.title = [NSString stringWithFormat:@"已选择 %@", node.nodeName];
        if ([self.delegate respondsToSelector:@selector(didSelectANode:)]) {
            [self.delegate didSelectANode:node];
        }
    }
}

@end
