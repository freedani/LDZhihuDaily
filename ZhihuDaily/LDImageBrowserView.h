//
//  LDImageBrowserView.h
//  ZhihuDaily
//
//  Created by 李达 on 2017/3/14.
//  Copyright © 2017年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDImageBrowserView : UIView

@property(nonatomic, strong) UIImageView *imageView;

- (void)showImageBrowser:(NSString *)imageUrl;
- (void)showImageBrowser:(NSString *)imageUrl completedBlock:(SDExternalCompletionBlock)block;

@end
