//
//  TableViewCell.h
//  ZhihuDaily
//
//  Created by 李达 on 16/9/8.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Titles;

@interface TableViewCell : UITableViewCell

@property(strong,nonatomic) Titles *title;

+(CGFloat)heightForCellWithTitle:(Titles *)title;

@end
