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
    
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.numberOfLines = 2;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)setTitle:(Titles *)title {
    _title = title;
    
    self.textLabel.text = _title.text;
    
    /*
     How to add cache with the Image in the tableviewcell?
     */
    [self.imageView sd_setImageWithURL:_title.imageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
}

+ (CGFloat)heightForCellWithTitle:(Titles *)title {
    return (CGFloat)fmaxf(90.0f, (float)[self textHeight:title.text]);
}

+ (CGFloat)textHeight:(NSString *)text {
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(240.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil];
    return rectToFit.size.height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(285.0f, 15.0f, 75.0f, 60.0f);
    self.textLabel.frame = CGRectMake(15.0f, 15.0f, 245.0f, 0.0f);
    
    CGRect textLabelFrame = self.textLabel.frame;
//    CGRectOffset(self.textLabel.frame, 0.0f, 0.0f);
    CGFloat calculatedHeight = [[self class] textHeight:self.title.text];
    textLabelFrame.size.height = calculatedHeight;
    self.textLabel.frame = textLabelFrame;
    
}

@end
