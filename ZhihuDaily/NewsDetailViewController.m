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
}

-(void)initData{
    NSString *articleID = [NSString stringWithFormat:@"%ld",(long)self.storyID];
    NSString *modelString = [[SQLiteManager sharedInstance] newsDetailModelFromSqliteWithID:articleID];
    if (modelString) {
        NSData *data =[modelString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"cache exist!");
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
    
    
}

#pragma mark - SwitchNewsDelegate Method

- (void)switchToPreviousNews{
    [self switchToPreviousStoryWithCurrentSection:self.section storyID:self.storyID];
}

- (void)switchToNextNews{
    
}

- (void)handleWebViewClickedWithURL:(NSURL *)url{
    
}

@end
