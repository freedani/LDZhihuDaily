//
//  NewsDetailBottomBarView.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/3/10.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "NewsDetailBottomBarView.h"

@implementation NewsDetailBottomBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
    [self addSubview:backButton];
    self.backButton = backButton;
    
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
    [self addSubview:nextButton];
    self.nextButton = nextButton;
    
    UIButton *likeButton = [[UIButton alloc] init];
    [likeButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
    [self addSubview:likeButton];
    self.likeButton = likeButton;
    
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
    [self addSubview:shareButton];
    self.shareButton = shareButton;
    
    UIButton *commentButton = [[UIButton alloc] init];
    [commentButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
    [self addSubview:commentButton];
    self.commentButton = commentButton;
    
    [backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [likeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [shareButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [commentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backButton]-[nextButton(==backButton)]-[likeButton(==backButton)]-[shareButton(==backButton)]-[commentButton(==backButton)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton, nextButton, likeButton, shareButton, commentButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[nextButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nextButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[likeButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(likeButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(shareButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[commentButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(commentButton)]];
    
    
}

@end
