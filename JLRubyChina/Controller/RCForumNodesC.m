//
//  RCForumNodesC.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCForumNodesC.h"
#import "RCForumNodesModel.h"
#import "RCNodeEntity.h"
#import "RCForumTopicsC.h"
#import "RCNodeSectionEntity.h"
#import "SDSegmentedControl.h"


@interface RCForumNodesC ()

@property (nonatomic, strong) RCForumNodesModel* model;
@property (nonatomic, strong) NICellFactory* cellFactory;
@property (nonatomic, strong) NITableViewActions* actions;
@property (nonatomic, strong) SDSegmentedControl *segmentedControl;

@end

@implementation RCForumNodesC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"分类导航";
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


- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;

    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];

    [self.model loadNodesWithBlock:^(NSArray *nodeSectionsArray, NSError *error) {
    [self updateSegmentedControl];
    [self reloadTableViewDataWithIndex:0];
    }];

}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadTableViewDataWithIndex:(int)index
{
    // TODO: set this method in model, better
    if (self.model.nodeSectionsArray.count > index) {
        if (self.model.sections.count > 0) {
            [self.model removeSectionAtIndex:0];
        }
        NSArray* indexPaths = nil;
        if (self.model.nodeSectionsArray.count) {
            RCNodeSectionEntity* sectionEntity = self.model.nodeSectionsArray[index];
            indexPaths = sectionEntity.nodesArray;
            if (indexPaths.count) {
                [self.model addObjectsFromArray:indexPaths];
            }
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
    for (RCNodeSectionEntity* s in self.model.nodeSectionsArray) {
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
    return [RCForumNodesModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[RCNodeEntity class]]) {
                RCNodeEntity* entity = (RCNodeEntity*)object;
                RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithNodeName:entity.nodeName
                                                                      nodeId:entity.nodeId];
                [self.navigationController pushViewController:c animated:YES];
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

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
