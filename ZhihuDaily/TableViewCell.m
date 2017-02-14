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
    [self initUI];
    return self;
}

- (void) initUI {
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine"]];
    [self.contentView addSubview:separatorLine];
    [separatorLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[separatorLine]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorLine(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorLine)]];
    
}

- (void)setTitle:(Titles *)title {
    _title = title;
    
    self.textLabel.text = _title.text;
    
    /*
     How to add cache with the Image in the tableviewcell?
     */
    
}

+ (CGFloat)heightForCellWithTitle:(Titles *)title {
    return (CGFloat)fmaxf(94.0f, (float)[self textHeight:title.text] + 5.0f);
}

+ (CGFloat)textHeight:(NSString *)text {
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(245.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil];
    return rectToFit.size.height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(285.0f, 17.0f, 75.0f, 60.0f);
    self.textLabel.frame = CGRectMake(17.0f, 17.0f, 245.0f, 0.0f);
    
    CGRect textLabelFrame = self.textLabel.frame;
    CGFloat calculatedHeight = [[self class] textHeight:self.title.text];
    textLabelFrame.size.height = calculatedHeight;
    self.textLabel.frame = textLabelFrame;
    
}

@end
