//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupCoverView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupCoverView
{
    UIImageView *coverImageView = [UIImageView new];
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [coverImageView setImage:[UIImage imageNamed:@"Home_Image_Mask"]];
    [self.contentView addSubview:coverImageView];
    [coverImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[coverImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coverImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[coverImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coverImageView)]];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFit];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"%@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.sd_width - 34.0f;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 17.0f;
        CGFloat titleLabelY = self.sd_height - titleLabelH - 22.0f;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}

@end
