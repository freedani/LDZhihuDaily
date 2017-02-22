//
//  NavigationBar.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/13.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "NavigationBar.h"

@interface NavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backgroundColorView;

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
}

- (void)setBackgroundColorAlpha:(CGFloat)alpha {
    [_backgroundColorView setAlpha:alpha];
}

- (void)setTitleHidden:(BOOL)isHidden {
    _titleLabel.hidden = isHidden;
}

@end
