//
//  mainViewController.h
//  ZhihuDaily
//
//  Created by 李达 on 16/11/2.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, readwrite, nonatomic) UIViewController *contentViewController;
@property (strong, readwrite, nonatomic) UIViewController *menuViewController;
@property (strong, readwrite, nonatomic) UIViewController *launchViewController;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;

- (id)initWithContentVC:(UIViewController *)contentVC
                 menuVC:(UIViewController *)menuVC;
- (void)showMenuViewController;
- (void)hideMenuViewController;
//- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end
