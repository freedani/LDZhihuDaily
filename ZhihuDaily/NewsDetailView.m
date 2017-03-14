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
#import "NewsDetailBottomBarView.h"
#import <WebKit/WebKit.h>
#import "LDImageBrowserView.h"


@interface NewsDetailView () <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NewsDetailHeaderView *headerView;
@property (nonatomic, strong) NewsDetailModel *newsModel;
@property (nonatomic, strong) LDImageBrowserView *imageBrowserView;

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
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:theConfiguration];
    wkWebView.scrollView.delegate = self;
    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
    [self addSubview:wkWebView];
    self.webView = wkWebView;
    
    NewsDetailBottomBarView *bottomBarView = [[NewsDetailBottomBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    bottomBarView.userInteractionEnabled = YES;
    
    bottomBarView.layer.shadowColor = [UIColor grayColor].CGColor;
    bottomBarView.layer.shadowOffset = CGSizeMake(0,-0.5);
    bottomBarView.layer.shadowOpacity = 0.2;
    bottomBarView.layer.shadowRadius = 0.5;
    
    [self addSubview:bottomBarView];
    
    [bottomBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [wkWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[wkWebView]-0-[bottomBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(wkWebView,bottomBarView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomBarView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[wkWebView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(wkWebView)]];
    
    self.bottomBarView = bottomBarView;
    
    NewsDetailHeaderView *headerView = [[NewsDetailHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,topImageHeight)];
    [wkWebView.scrollView addSubview:headerView];
    self.headerView = headerView;
    
    /*
     Here is some question with addTarget:action:.
     In the MVC design pattern, where should I put at this fuction? V or C?
     */
    [self.bottomBarView.backButton addTarget:self.delegate action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBarView.nextButton addTarget:self.delegate action:@selector(switchToNextNews) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBarView.likeButton addTarget:self.delegate action:@selector(likeNews) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBarView.shareButton addTarget:self.delegate action:@selector(shareNews) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBarView.commentButton addTarget:self.delegate action:@selector(commentNews) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    self.imageBrowserView = [[LDImageBrowserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.imageBrowserView.hidden = YES;
    [self addSubview:self.imageBrowserView];
}

#pragma mark - DataSource Method
- (void)updateNewsWithModel:(NewsDetailModel *)model{
    if ([model isEqual:_newsModel] || !model) {
        return;
    }
    
    self.newsModel = model;
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html><head><meta name='viewport' content='initial-scale=1.0,user-scalable=no' /><link type='text/css'  rel=\"stylesheet\" href=%@></head><body>%@</body></html>",[model.css firstObject],model.body] baseURL:nil];
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

#pragma mark - JavaScript

- (void)addJavaScript {
    NSString *clickImage =
    @"function setImage(){\
    var imgs = document.getElementsByTagName(\"img\");\
    for (var i=0;i<imgs.length;i++){\
    imgs[i].setAttribute(\"onclick\",\"imageClick(\"+i+\")\");\
    }\
    }\
    function imageClick(i){\
    var rect = getImageRect(i);\
    var url=\"clickimage::\"+i+\"::\"+rect;\
    document.location = url;\
    }\
    function getImageRect(i){\
    var imgs = document.getElementsByTagName(\"img\");\
    var rect;\
    rect = imgs[i].getBoundingClientRect().left+\"::\";\
    rect = rect+imgs[i].getBoundingClientRect().top+\"::\";\
    rect = rect+imgs[i].width+\"::\";\
    rect = rect+imgs[i].height;\
    return rect;\
    }\
    function getAllImageUrl(){\
    var imgs = document.getElementsByTagName(\"img\");\
    var urlArray = [];\
    for (var i=0;i<imgs.length;i++){\
    var src = imgs[i].src;\
    urlArray.push(src);\
    }\
    return urlArray.toString();\
    }\
    ";
    [_webView evaluateJavaScript:clickImage completionHandler:nil];
}

#pragma mark - WKNavigationDelegate Method

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self addJavaScript];
    [webView evaluateJavaScript:@"setImage();" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *requestString = [[navigationAction.request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@"::"];
    if ([components[0] isEqualToString:@"clickimage"]) {
        int imgIndex = [components[1] intValue];
        [_webView evaluateJavaScript:@"getAllImageUrl();" completionHandler:^(id urls, NSError *error){
            NSString *imageUrl = [[urls componentsSeparatedByString:@","] objectAtIndex:imgIndex];
            [self.imageBrowserView showImageBrowser:imageUrl];
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    return;
    
}

#pragma mark - WKUIDelegate Method

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}
@end
