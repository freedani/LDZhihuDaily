//
//  NavigationBar.h
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/13.
//  Copyright © 2017年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBar : UIView

@property (nonatomic, weak) NSLayoutConstraint *backgroundHeightConstraint;

- (void)setBackgroundColorAlpha:(CGFloat)alpha;
- (void)setCircleWithProgress:(CGFloat)progress;
- (void)setCircleHidden:(BOOL)isHidden;
- (void)setTitleHidden:(BOOL)isHidden;
- (void)setActivityViewStart;
- (void)setActivityViewStop;

@end
