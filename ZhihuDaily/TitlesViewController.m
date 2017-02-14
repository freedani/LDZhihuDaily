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
#import "SectionView.h"
#import "NavigationBar.h"
#import <AFNetworking/AFNetworking.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TitlesViewController () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) HomepageModel *homepageModel;
@property (readwrite, nonatomic, strong) NSArray *topTitles;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *titleTableView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NavigationBar *navigationBar;
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
    
    [self.baseView setUserInteractionEnabled:YES];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton = leftButton;
    [leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_baseView addSubview:leftButton];
    [_baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[leftButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftButton)]];
    [_baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[leftButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftButton)]];
    [leftButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"Home_Icon_Highlight"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNeedsStatusBarAppearanceUpdate];

}

- (void)hideMenuViewController {
    
}

- (void)initData{
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

- (void)initTableView {
    self.titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, kScreenWidth,kScreenHeight - 20.0f) style:UITableViewStylePlain];
    
    self.navigationBar = [NavigationBar new];
    
    [self.baseView addSubview:_titleTableView];
    [self.baseView addSubview:_navigationBar];
    
    [_navigationBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_navigationBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navigationBar)]];
    [self.baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_navigationBar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navigationBar)]];
    
    [self.baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleTableView)]];
    [self.baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_titleTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleTableView)]];
    
    self.titleTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.titleTableView.bounds), topImageHeight)];
    self.titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.titleTableView.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.titleTableView.frame.size.width, 100.0f)];
    [self.titleTableView.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    
#warning refreshControl needs to update
    
    [self.titleTableView.tableHeaderView addSubview:self.titleTableView.refreshControl];
    
    self.titleTableView.rowHeight = 90.0f;
    self.titleTableView.delegate = self;
    self.titleTableView.dataSource = self;
    self.titleTableView.showsVerticalScrollIndicator = FALSE;
    
    [self reload:nil];
}

-(void) initCircleView {
    self.circleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.0f, -20.0f, kScreenWidth, topImageHeight) delegate:self placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    [self.titleTableView addSubview:_circleView];
    [self.titleTableView setClipsToBounds:NO];
    
}

- (void)reload:(__unused id)sender {
    
#warning needs to update the circle view
    
    self.navigationItem.rightBarButtonItem.enabled = NO;

    NSURLSessionTask __unused *task = [self.homepageModel getLatestStoriesWithBlock:^(HomepageModel *model, NSError *error) {
        if (!error) {
            self.homepageModel.topStoriesArray = model.topStoriesArray;
            self.homepageModel.storiesArray = model.storiesArray;
            self.homepageModel.currentDate = model.currentDate;
#warning needs to add cache with homepageModel
//不能这么直接就把model.storiesArray赋值给self.homepageModel.storiesArray，否则在下拉刷新之后会把历史新闻给删掉，在添加缓存之后再考虑重复刷新复制的事
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
    /*
     由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化。
     首先根据标识去缓存池取，
     如果缓存池没有到则重新创建并放到缓存池中。
     */
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    SectionView *sectionView = [[SectionView alloc] init];
    [sectionView setViewWithDateString:self.homepageModel.storiesArray[section].date];
    
    return sectionView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Titles *selectTitle = self.homepageModel.storiesArray[indexPath.section].dailyNewsList[(NSUInteger)indexPath.row];
    [cell.imageView sd_setImageWithURL:selectTitle.imageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        [_navigationBar.backgroundHeightConstraint setConstant:20];
        [_navigationBar setTitleHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        [_navigationBar.backgroundHeightConstraint setConstant:54];
        [_navigationBar setTitleHidden:NO];
    }
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    
    if (contentYoffset > 0) {
        CGFloat alpha = MIN(1, 1 - ((210 - contentYoffset) / 210));
        [_navigationBar setBackgroundColorAlpha:alpha];
    } else {
        [_navigationBar setBackgroundColorAlpha:0];
    }
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset - 90.0f;
    
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
