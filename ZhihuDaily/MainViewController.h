//
//  mainViewController.h
//  ZhihuDaily
//
//  Created by 李达 on 16/11/2.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitlesViewController;
@class MenuViewController;

@interface MainViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, readwrite, nonatomic) TitlesViewController *contentViewController;
@property (strong, readwrite, nonatomic) MenuViewController *menuViewController;
@property (strong, readwrite, nonatomic) UIViewController *launchViewController;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;

- (id)initWithContentVC:(UIViewController *)contentVC
                 menuVC:(UIViewController *)menuVC;
- (void)showMenuViewController;
- (void)hideMenuViewController;
//- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end
