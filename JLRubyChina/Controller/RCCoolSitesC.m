//
//  RCCoolSitesC.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCCoolSitesC.h"
#import "NIWebController.h"
#import "SDSegmentedControl.h"
#import "RCCoolSitesModel.h"
#import "RCSiteSectionEntity.h"
#import "RCSiteEntity.h"

@interface RCCoolSitesC ()
@property (nonatomic, assign) NITableViewActionBlock tapAction;
@property (nonatomic, strong) RCCoolSitesModel* model;
@property (nonatomic, strong) NITableViewActions* actions;
@property (nonatomic, strong) NICellFactory* cellFactory;
@property (nonatomic, strong) SDSegmentedControl *segmentedControl;
@end

@implementation RCCoolSitesC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"外链酷站";
//        self.navigationItem.leftBarButtonItem = [RCGlobalConfig createMenuBarButtonItemWithTarget:self
//                                                                                           action:@selector(showLeft:)];
        self.navigationItem.rightBarButtonItem = [RCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(refreshCoolSites)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cellFactory = [[NICellFactory alloc] init];
        _model = [[[self tableModelClass] alloc] initWithDelegate:_cellFactory];
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        [self.actions attachToClass:[self.model objectClass] tapBlock:self.tapAction];
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
    
    [self refreshCoolSites];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.revealSideViewController updateViewWhichHandleGestures];
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

- (void)refreshCoolSites
{
    [self.model loadCoolSitesWithBlock:^(NSArray *siteSectionsArray, NSError *error) {
        [self updateSegmentedControl];
        [self reloadTableViewDataWithIndex:0];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadTableViewDataWithIndex:(int)index
{
    // TODO: set this method in model, better
    if (self.model.siteSectionsArray.count > index) {
        if (self.model.sections.count > 0) {
            [self.model removeSectionAtIndex:0];
        }
        NSArray* indexPaths = nil;
        if (self.model.siteSectionsArray.count) {
            RCSiteSectionEntity* sectionEntity = self.model.siteSectionsArray[index];
            indexPaths = sectionEntity.sitesArray;
            if (indexPaths.count) {
                [self.model addObjectsFromArray:indexPaths];
            }
        }
        else {
            // just set empty array, show empty data but no error
            indexPaths = [NSArray array];
        }
        [self.tableView reloadData];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateSegmentedControl
{
    if (!_segmentedControl) {
        // TODO: pull request to author fix this bug: initWithFrame can not call [self commonInit]
        _segmentedControl = [[SDSegmentedControl alloc] init];
        _segmentedControl.frame = CGRectMake(0.f, 0.f, self.view.width, _segmentedControl.height);
        _segmentedControl.interItemSpace = 0.f;
        [_segmentedControl addTarget:self action:@selector(segmentedDidChange)
                    forControlEvents:UIControlEventValueChanged];
    }
    if (self.segmentedControl.numberOfSegments > 0) {
        [self.segmentedControl removeAllSegments];
    }
    for (RCSiteSectionEntity* s in self.model.siteSectionsArray) {
        [self.segmentedControl insertSegmentWithTitle:s.name
                                              atIndex:self.segmentedControl.numberOfSegments
                                             animated:NO];
        self.segmentedControl.selectedSegmentIndex = 0;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)segmentedDidChange
{
    [self reloadTableViewDataWithIndex:self.segmentedControl.selectedSegmentIndex];
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if ([object isKindOfClass:[RCSiteEntity class]]) {
            RCSiteEntity* o = (RCSiteEntity*)object;
            if (o.url.length) {
                NIWebController* webC = [[NIWebController alloc] initWithURL:[NSURL URLWithString:o.url]];
                [self.navigationController pushViewController:webC animated:YES];
            }
        }
        return YES;
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableModelClass
{
    return [RCCoolSitesModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.model];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segmentedControl;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat kDefaultSegemetedControlHeight = 43.f;// see: SDSegmentedControl commonInit
    return kDefaultSegemetedControlHeight;
}

@end
