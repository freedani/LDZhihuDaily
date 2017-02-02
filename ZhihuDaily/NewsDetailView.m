//
//  newsDetailView.m
//  ZhihuDaily
//
//  Created by 李达 on 16/9/22.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "NewsDetailView.h"
#import "NewsDetailHeaderView.h"


@interface NewsDetailView () <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) NewsDetailHeaderView *headerView;
@property (nonatomic, strong) NewsDetailModel *newsModel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;

@end

@implementation NewsDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

-(void)initUI{
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.delegate = self;
    webView.delegate = self;
    
    UIView *bottomBarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BottomBar"]];
    
    [self addSubview:webView];
    [self addSubview:bottomBarView];
    
    [bottomBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView]-0-[bottomBarView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView,bottomBarView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomBarView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    
    self.webView = webView;
    self.bottomBarView = bottomBarView;
    
    NewsDetailHeaderView *headerView = [[NewsDetailHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,210.0f)];
    [_webView.scrollView addSubview:headerView];
    self.headerView = headerView;
}

#pragma mark - DataSource Method
- (void)updateNewsWithModel:(NewsDetailModel *)model{
    if ([model isEqual:_newsModel] || !model) {
        return;
    }
    
    self.newsModel = model;
//    NSLog(@"Load HTML Start!");
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",[model.css firstObject],model.body] baseURL:nil];
//    NSLog(@"Load HTML Done!");
    [_headerView updateNewsWithModel:model];
}

- (void)setContentOffset:(CGPoint)point animated:(BOOL)animated {
    [_webView.scrollView setContentOffset:point animated:animated];
}

#pragma mark - Scrollview Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
}

#pragma mark - UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

@end
