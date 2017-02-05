//
//  newsDetailViewController.m
//  ZhihuDaily
//
//  Created by 李达 on 16/9/22.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsDetailView.h"
#import "NewsDetailModel.h"
#import "HomepageModel.h"
#import "AFAppDotNetAPIClient.h"
#import "SQLiteManager.h"

@interface NewsDetailViewController () <SwitchNewsDelegate>

@property (nonatomic, strong) NewsDetailView *newsDetailView;
@property (nonatomic, weak, readonly) HomepageModel *homePageModel;
@property (nonatomic, strong) UIButton *previousButton;

@end

@implementation NewsDetailViewController

- (HomepageModel *)homePageModel{
    return [HomepageModel sharedInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self initUI];
    [self initData];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setAlpha:0.0f];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.newsDetailView = [[NewsDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _newsDetailView.delegate = self;
    [self.view addSubview:_newsDetailView];
    
    UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectNull];
    [previousButton addTarget:self action:@selector(switchToPreviousNews) forControlEvents:UIControlEventTouchUpInside];
    self.previousButton = previousButton;
    [self.newsDetailView.bottomBarView addSubview:self.previousButton];
    [previousButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.newsDetailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[previousButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousButton)]];
    [self.newsDetailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[previousButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousButton)]];
//    [self.previousButton setBackgroundColor:[UIColor blueColor]];

//    [self.newsDetailView.previousButton addTarget:self action:@selector(switchToPreviousNews) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initData{
    NSString *articleID = [NSString stringWithFormat:@"%ld",(long)self.storyID];
    NSString *modelString = [[SQLiteManager sharedInstance] newsDetailModelFromSqliteWithID:articleID];
    if (modelString) {
        NSData *data =[modelString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NewsDetailModel *newsDetailModel = [MTLJSONAdapter modelOfClass:[NewsDetailModel class] fromJSONDictionary:dic error:nil];;
        [_newsDetailView updateNewsWithModel:newsDetailModel];
    } else {
        NSString *appendString = [NSString stringWithFormat:@"news/%ld",(long)self.storyID];
        [[AFAppDotNetAPIClient sharedClient] GET:appendString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id JSON){
            NSError *err = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&err];
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[SQLiteManager sharedInstance] saveNewsDetailModel:jsonStr withID:articleID];
            NewsDetailModel *newsDetailModel = [MTLJSONAdapter modelOfClass:[NewsDetailModel class] fromJSONDictionary:JSON error:nil];
            [_newsDetailView updateNewsWithModel:newsDetailModel];
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            ;
        }];
    }
}

#pragma mark - Previous/Next News Switch Method

- (void)switchToNextStoryWithCurrentSection:(NSInteger)section storyID:(NSInteger)storyID {
    
}

- (void)switchToPreviousStoryWithCurrentSection:(NSInteger)section storyID:(NSInteger)storyID {
    NSLog(@"old section:%ld,old storyID:%ld",section,storyID);
    if([self.homePageModel getPreviousNewsWithSection:&section currentID:&storyID]) {
        self.storyID = storyID;
        self.section = section;
        NSLog(@"new section:%ld,new storyID:%ld",section,storyID);
        [self initData];
    } else {
        NSLog(@"return false");
    }
}

#pragma mark - SwitchNewsDelegate Method

- (void)switchToPreviousNews {
//    NSLog(@"switchToPreviousNews");
    [self switchToPreviousStoryWithCurrentSection:self.section storyID:self.storyID];
}

- (void)switchToNextNews{
    
}

- (void)handleWebViewClickedWithURL:(NSURL *)url{
    
}

@end
