//
//  MenuView.h
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/15.
//  Copyright © 2017年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CacheDelegate <NSObject>

- (void)ClickControlAction;

@end

@interface MenuView : UIView

@property (nonatomic ,weak) id<CacheDelegate> delegate;
@property (nonatomic, strong) UITableView *menuTableView;

@end
