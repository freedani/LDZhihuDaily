//
//  ViewController.m
//  ZhihuDaily
//
//  Created by 李达 on 16/9/7.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "TitlesViewController.h"
#import "Titles.h"
#import "CircleViewModel.h"
#import "TableViewCell.h"
#import "newsDetailViewController.h"
#import "HomepageModel.h"
#import "DailyNewsList.h"
#import <AFNetworking/AFNetworking.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface TitlesViewController () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) HomepageModel *homepageModel;
@property (readwrite, nonatomic, strong) NSArray *topTitles;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *titleTableView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) SDCycleScrollView *circleView;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@end

@implementation TitlesViewController

#pragma mark - Getter Method

-(HomepageModel*)homepageModel {
    if (!_homepageModel) {
        self.homepageModel = [HomepageModel new];
        return self.homepageModel;
    }
    return _homepageModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar setAlpha:0.0f];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initUI {
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth,kScreenHeight)];
    [self.view addSubview:_baseView];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self initData];
    [self initTableView];
    [self initCircleView];
    
    [self setNeedsStatusBarAppearanceUpdate];

}

-(void) initData{
    NSURLSessionTask __unused *task = [self.homepageModel getLatestStoriesWithBlock:^(HomepageModel *model, NSError *error) {
        if (!error) {
            self.homepageModel.topStoriesArray = [NSArray arrayWithArray:model.topStoriesArray];
            self.homepageModel.storiesArray = [NSMutableArray arrayWithArray:model.storiesArray];
            if (self.homepageModel.currentDate == nil) {
                self.homepageModel.currentDate = model.currentDate;
            }
            self.topTitles = model.topStoriesArray;
            NSMutableArray *mutableTopTitlesURL = [NSMutableArray arrayWithCapacity:[_topTitles count]];
            NSMutableArray *mutableTopTitlesStrings = [NSMutableArray arrayWithCapacity:[_topTitles count]];
            for (CircleViewModel *attributes in _topTitles) {
                [mutableTopTitlesURL addObject:attributes.imageURL];
                [mutableTopTitlesStrings addObject:attributes.text];
            }
            NSArray *imagesURLStrings = mutableTopTitlesURL;
            _circleView.imageURLStringsGroup = imagesURLStrings;
            NSArray *titlesStrings = mutableTopTitlesStrings;
            _circleView.titlesGroup =titlesStrings;
            _circleView.autoScrollTimeInterval = 5.0f;
            [self.titleTableView reloadData];
        }
    }];
    [task resume];
}

-(void) initCircleView {
    self.circleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth,210.0f) delegate:self placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    [self.titleTableView addSubview:_circleView];
    
}

-(void) initTableView {
    self.titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
    [self.baseView addSubview:_titleTableView];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleTableView)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_titleTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleTableView)]];
    
    self.titleTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.titleTableView.bounds), 210.0f)];
    self.titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.titleTableView.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.titleTableView.frame.size.width, 100.0f)];
    [self.titleTableView.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.titleTableView.tableHeaderView addSubview:self.titleTableView.refreshControl];
    
    self.titleTableView.rowHeight = 70.0f;
    self.titleTableView.delegate = self;
    self.titleTableView.dataSource = self;
    
    [self reload:nil];
}

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;

    NSURLSessionTask __unused *task = [self.homepageModel getLatestStoriesWithBlock:^(HomepageModel *model, NSError *error) {
        if (!error) {
            self.homepageModel.topStoriesArray = model.topStoriesArray;
            self.homepageModel.storiesArray = model.storiesArray;
            self.homepageModel.currentDate = model.currentDate;
            //不能这么直接就把model.storiesArray赋值给self.homepageModel.storiesArray，否则在下拉刷新之后会把历史新闻给删掉，再添加缓存之后再考虑重复刷新复制的事
//            if (self.homepageModel == nil) {
//                self.homepageModel.currentDate = model.currentDate;
//            }
            NSMutableArray *mutableTopTitlesURL = [NSMutableArray arrayWithCapacity:[_topTitles count]];
            NSMutableArray *mutableTopTitlesStrings = [NSMutableArray arrayWithCapacity:[_topTitles count]];
            for (CircleViewModel *attributes in _topTitles) {
                [mutableTopTitlesURL addObject:attributes.imageURL];
                [mutableTopTitlesStrings addObject:attributes.text];
            }
            NSArray *imagesURLStrings = mutableTopTitlesURL;
            _circleView.imageURLStringsGroup = imagesURLStrings;
            NSArray *titlesStrings = mutableTopTitlesStrings;
            _circleView.titlesGroup =titlesStrings;
            _circleView.autoScrollTimeInterval = 5.0f;
            [self.titleTableView reloadData];
        }
    }];
    
    [self.titleTableView.refreshControl setRefreshingWithStateOfTask:task];
    [task resume];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.homepageModel.storiesArray.count;
}

- (NSInteger)tableView:(__unused UITableView *)tableView
 numberOfRowsInSection:(__unused NSInteger)section
{
    return (NSInteger)[self.homepageModel.storiesArray[section].dailyNewsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.title = self.homepageModel.storiesArray[indexPath.section].dailyNewsList[(NSUInteger)indexPath.row];
    return cell;
}
 

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(__unused UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TableViewCell heightForCellWithTitle:self.homepageModel.storiesArray[indexPath.section].dailyNewsList[(NSUInteger)indexPath.row]];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Titles *selectTitle = self.homepageModel.storiesArray[indexPath.section].dailyNewsList[(NSUInteger)indexPath.row];
    [self transitionToDetailVC:selectTitle.titleID section:indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 34;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if (distanceFromBottom < height) {
        
        [self.homepageModel getPreviousStoriesWithBlock:^(DailyNewsList *model,NSError *error) {
            if (!error) {
                [self.homepageModel.storiesArray insertObject:model atIndex:self.homepageModel.storiesArray.count];
                self.homepageModel.currentDate = model.date;
                NSInteger section = [self.homepageModel.storiesArray count];
                [_titleTableView insertSections:[NSIndexSet indexSetWithIndex:section - 1] withRowAnimation:UITableViewRowAnimationFade];
                [self.titleTableView reloadData];
            }
        }
                                           andDate:self.homepageModel.currentDate];
    }
}

#pragma mark - SDCycleViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    Titles *selectTitle = self.topTitles[index];
    [self transitionToDetailVC:selectTitle.titleID section:0];
}

#pragma mark - Controller Transition

- (void)transitionToDetailVC:(NSInteger)storyID section:(NSInteger)section {
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] init];
    newsDetailVC.storyID = storyID;
    newsDetailVC.section = section;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

#pragma mark - Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count > 1) {
        return YES;
    }
    return NO;
}
@end
