//
//  newsDetailView.m
//  ZhihuDaily
//
//  Created by 李达 on 16/9/22.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "NewsDetailView.h"
#import "NewsDetailHeaderView.h"
#import "NewsDetailViewController.h"


@interface NewsDetailView () <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NewsDetailHeaderView *headerView;
@property (nonatomic, strong) NewsDetailModel *newsModel;

/*
 Need to define what is next and what is previous.
 Next means the downside/older news.
 Previous means the upside/newer news.
*/

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
    
    UIView *bottomBarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BottomBar"]];
    bottomBarView.userInteractionEnabled = YES;
    
    [self addSubview:webView];
    [self addSubview:bottomBarView];
    
    [bottomBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView]-0-[bottomBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView,bottomBarView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomBarView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    
    self.webView = webView;
    self.bottomBarView = bottomBarView;
    
    NewsDetailHeaderView *headerView = [[NewsDetailHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,topImageHeight)];
    [_webView.scrollView addSubview:headerView];
    self.headerView = headerView;
    
    UIButton *previousButtonAtBottom = [[UIButton alloc] initWithFrame:CGRectNull];
    
    /*
     Here is some question with addTarget:action: .
     In the MVC design pattern, where should I put at this fuction? V or C?
     */
    [previousButtonAtBottom addTarget:self.delegate action:@selector(switchToNextNews) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomBarView addSubview:previousButtonAtBottom];
    [previousButtonAtBottom setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[previousButtonAtBottom]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousButtonAtBottom)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[previousButtonAtBottom]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousButtonAtBottom)]];

    
    UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 50, -20 - 50, 100, 30)];
    previousButton.enabled = false;
    [previousButton setTitle:@" 载入上一篇" forState:UIControlStateNormal];
    [previousButton setImage:[UIImage imageNamed:@"ZHAnswerViewBack"] forState:UIControlStateNormal];
    [previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.previousButton = previousButton;
    [self.webView.scrollView addSubview:previousButton];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    nextButton.center = CGPointMake(kScreenWidth/2, kScreenHeight + 20);
    nextButton.enabled = false;
    [nextButton setTitle:@" 载入下一篇" forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"ZHAnswerViewPrevIcon"] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.nextButton = nextButton;
    [self.webView.scrollView addSubview:nextButton];
}

- (void)switchToPreviousNews {
    NSLog(@"view switchToPreviousNews");
}


#pragma mark - DataSource Method
- (void)updateNewsWithModel:(NewsDetailModel *)model{
    if ([model isEqual:_newsModel] || !model) {
        return;
    }
    
    self.newsModel = model;
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",[model.css firstObject],model.body] baseURL:nil];
    [_headerView updateNewsWithModel:model];
}

- (void)setContentOffset:(CGPoint)point animated:(BOOL)animated {
    [_webView.scrollView setContentOffset:point animated:animated];
}

#pragma mark - Scrollview Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        CGRect f = _headerView.frame;
        f.origin.y = yOffset;
        f.size.height = topImageHeight - yOffset;
        _headerView.frame = f;
        
        if (yOffset <= -70) {
            [UIView animateWithDuration:.3 animations:^{
                _previousButton.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
                
            }];
            
            if (yOffset < -100) {
                [scrollView setContentOffset:CGPointMake(0, -100) animated:NO];
            }
        } else {
            [UIView animateWithDuration:.3 animations:^{
                _previousButton.imageView.transform = CGAffineTransformIdentity;
                
            }];
        }
        
    } else {
        if (scrollView.contentSize.height + 20 > self.nextButton.center.y) {
            self.nextButton.center = CGPointMake(self.nextButton.center.x, scrollView.contentSize.height + 20);
        }
        if (yOffset > scrollView.contentSize.height - kScreenHeight + 100) {
            [UIView animateWithDuration:.3 animations:^{
                _nextButton.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
            }];
            
        } else{
            [UIView animateWithDuration:.3 animations:^{
                _nextButton.imageView.transform = CGAffineTransformIdentity;
                
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset <= -70) {
        if ([self.delegate respondsToSelector:@selector(switchToPreviousNews)]) {
            [self.delegate switchToPreviousNews];
        }
    }
    if (yOffset > scrollView.contentSize.height - kScreenHeight + 100) {
        if ([self.delegate respondsToSelector:@selector(switchToNextNews)]) {
            [self.delegate switchToNextNews];
        }
    }
    
}

#pragma mark - UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

@end
