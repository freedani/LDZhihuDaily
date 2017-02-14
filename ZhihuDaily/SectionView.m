//
//  sectionView.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/12.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "SectionView.h"

@interface SectionView ()

@property (nonatomic, strong) UILabel *sectionLable;

@end

@implementation SectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [sectionLabel setFont:[UIFont systemFontOfSize:14]];
    [sectionLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:sectionLabel];
    _sectionLable = sectionLabel;
    /*
     设置居中
     */
    [sectionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:sectionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:sectionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    
}

- (void)setViewWithDateString:(NSString *)dateString {
    self.sectionLable.text = dateString;
}

@end
