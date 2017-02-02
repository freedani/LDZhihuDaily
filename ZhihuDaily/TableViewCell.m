//
//  TableViewCell.m
//  ZhihuDaily
//
//  Created by 李达 on 16/9/8.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "TableViewCell.h"
#import "Titles.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)setTitle:(Titles *)title {
    _title = title;
    
    self.detailTextLabel.text = _title.text;
    [self.imageView sd_setImageWithURL:_title.imageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
}

+ (CGFloat)heightForCellWithTitle:(Titles *)title {
    return (CGFloat)fmaxf(70.0f, (float)[self detailTextHeight:title.text] + 45.0f);
}

+ (CGFloat)detailTextHeight:(NSString *)text {
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(240.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil];
    return rectToFit.size.height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(300.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(20.0f, 6.0f, 240.0f, 0.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 5.0f);
    CGFloat calculatedHeight = [[self class] detailTextHeight:self.title.text];
    detailTextLabelFrame.size.height = calculatedHeight;
    self.detailTextLabel.frame = detailTextLabelFrame;
    
}

@end
