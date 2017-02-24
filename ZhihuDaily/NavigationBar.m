//
//  NavigationBar.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/13.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "NavigationBar.h"
#import "RefreshCircle.h"

@interface NavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backgroundColorView;
@property (nonatomic, strong) RefreshCircle *refreshCircle;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation NavigationBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void) initUI {
    UIView *backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (statuBarHeight + tableViewHeaderHeight))];
    [backgroundColorView setBackgroundColor:[UIColor colorWithRed:24/255.0 green:144/255.0 blue:211/255.0 alpha:1]];
    _backgroundColorView = backgroundColorView;
    [backgroundColorView setAlpha:0];
    
    [self addSubview:backgroundColorView];
    [backgroundColorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundColorView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundColorView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundColorView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundColorView)]];
    
    self.backgroundHeightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:(statuBarHeight + tableViewHeaderHeight)];
    [self addConstraint:_backgroundHeightConstraint];
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, statuBarHeight, kScreenWidth, tableViewHeaderHeight)];
    [self addSubview:labelView];
    [labelView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[labelView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(labelView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[labelView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(labelView)]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [labelView addSubview:titleLabel];
    _titleLabel = titleLabel;
    _titleLabel.text = @"今日热闻";
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [labelView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [labelView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    RefreshCircle *refreshCircle = [RefreshCircle new];
    _refreshCircle = refreshCircle;
    _refreshCircle.frame = CGRectMake(_refreshCircle.frame.origin.x, _refreshCircle.frame.origin.y, 20, 20);
    [labelView addSubview:_refreshCircle];
    [_refreshCircle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [labelView addConstraint:[NSLayoutConstraint constraintWithItem:_refreshCircle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [labelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_refreshCircle]-0-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_refreshCircle, _titleLabel)]];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_refreshCircle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20];
    [_refreshCircle addConstraint:widthConstraint];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_refreshCircle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20];
    [_refreshCircle addConstraint:heightConstraint];
    
    _activityView = [UIActivityIndicatorView new];
    [labelView addSubview:_activityView];
    [_activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [labelView addConstraint:[NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [labelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_activityView]-0-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_activityView, _titleLabel)]];
    _activityView.hidden = YES;
    
    
}

- (void)setBackgroundColorAlpha:(CGFloat)alpha {
    [_backgroundColorView setAlpha:alpha];
}

- (void)setTitleHidden:(BOOL)isHidden {
    _titleLabel.hidden = isHidden;
}

- (void)setCircleWithProgress:(CGFloat)progress {
    [_refreshCircle setForegroundCircleViewWithProgress:progress];
}

- (void)setCircleHidden:(BOOL)isHidden {
    _refreshCircle.hidden = isHidden;
}

- (void)setActivityViewStart {
    _activityView.hidden = NO;
    _refreshCircle.hidden = YES;
    [_activityView startAnimating];
}

- (void)setActivityViewStop {
    _activityView.hidden = YES;
    [_activityView stopAnimating];
}

@end
