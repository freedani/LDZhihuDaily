//
//  newsDetailView.h
//  ZhihuDaily
//
//  Created by 李达 on 16/9/22.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsDetailModel.h"

@protocol SwitchNewsDelegate <NSObject>

- (void)switchToPreviousNews;
- (void)switchToNextNews;
- (void)popViewController;
- (void)handleWebViewClickedWithURL:(NSURL *)url;

@end

@class NewsDetailBottomBarView;

@interface NewsDetailView : UIView

@property (nonatomic, weak) id<SwitchNewsDelegate> delegate;

@property (nonatomic, strong) NewsDetailBottomBarView *bottomBarView;

- (void)updateNewsWithModel:(NewsDetailModel *)model;
- (void)setContentOffset:(CGPoint)point animated:(BOOL)animated;

@end
