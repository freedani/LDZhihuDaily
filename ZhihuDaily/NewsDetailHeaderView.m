//
//  NewsDtailHeaderView.m
//  ZhihuDaily
//
//  Created by 李达 on 16/10/2.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "NewsDetailHeaderView.h"

@interface NewsDetailHeaderView()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *imageSourceLabel;
@property(nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation NewsDetailHeaderView

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

-(void) initUI {
    [self setClipsToBounds:YES];
    _titleImageView = [[UIImageView alloc] init];
    _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:_titleImageView];
    [_titleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleImageView)]];
    
    self.coverImageView = [UIImageView new];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_coverImageView setImage:[UIImage imageNamed:@"Home_Image_Mask"]];
    [self addSubview:_coverImageView];
    
    [_coverImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_coverImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_coverImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_coverImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_coverImageView)]];

    
    self.imageSourceLabel = [UILabel new];
    _imageSourceLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _imageSourceLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_imageSourceLabel];
    
    [_imageSourceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageSourceLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-16]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageSourceLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
    
    self.titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_titleLabel];
    
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_titleLabel]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-4-[_imageSourceLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel,_imageSourceLabel)]];
}

-(void)updateNewsWithModel:(NewsDetailModel *)model {
    
    [_titleImageView setImageWithURL:[NSURL URLWithString:model.image]];
    _titleLabel.text = model.title;
    _imageSourceLabel.text = [NSString stringWithFormat:@"来源:%@",model.image_source];
}

@end
