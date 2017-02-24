//
//  mainViewController.m
//  ZhihuDaily
//
//  Created by 李达 on 16/11/2.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "MainViewController.h"
#import "LaunchViewController.h"
#import "TitlesViewController.h"
#import "MenuViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *contentButton;
@property (strong, nonatomic) UIButton *menuButton;

@end

@implementation MainViewController

- (id) init {
    if (self = [super init]) {
        _menuView = [[UIView alloc] init];
        _contentView = [[UIView alloc] init];
        _animationDuration = 0.35f;
    }
    return self;
}

- (id) initWithContentVC:(TitlesViewController*) contentVC menuVC:(MenuViewController*) menuVC  {
    if (self = [self init]) {
        _contentViewController = contentVC;
        _menuViewController = menuVC;
//        contentVC.mainVC = self;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self addGesture];

//    [self initLaunchVC];
//
#warning dispatch time may be related to the network condition
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self removeLaunchVC];
//    });
}

- (void) initLaunchVC {
    self.launchViewController = [LaunchViewController new];
    [self addChildViewController:self.launchViewController];
    [self.view addSubview:self.launchViewController.view];
}

- (void) removeLaunchVC {
    [UIView animateWithDuration:.5 animations:^{
        _launchViewController.view.alpha = 0;
    }completion:^(BOOL finished){
        [_launchViewController.view removeFromSuperview];
        [_launchViewController removeFromParentViewController];
    }];
}

- (void) initUI {
    self.contentButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectNull];
        [button addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.contentView];
    [self.menuView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:CGRectGetWidth(self.view.bounds)/2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_menuView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuView)]];
    if (self.menuViewController) {
        [self addContainerConstraints:self.menuViewController container:self.menuView];
    }
    
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    
    if (self.contentViewController) {
        [self addContainerConstraints:self.contentViewController container:self.contentView];
    }
    [self.contentViewController.menuButton addTarget:self action:@selector(showMenuViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hideMenuViewController {
    [self hideMenuViewControllerAnimated:YES];
}

- (void)hideMenuViewControllerAnimated:(BOOL)animated{
    [self.menuViewController beginAppearanceTransition:NO animated:animated];
    
    [self.contentButton removeFromSuperview];
    
#warning to avoid ircular reference, self in block needs to replace by weakSelf
    
//    WEAK_REF(self)
    
    void (^animationBlock)(void) = ^{
//        STRONG_REF(self_)
//        if (!self__) {
//            return ;
//        }
        if (!self) {
            return;
        }
//        self__.contentViewContainer.transform = CGAffineTransformIdentity;
//        self__.menuViewContainer.transform = CGAffineTransformIdentity;
        self.contentView.transform = CGAffineTransformIdentity;
        self.menuView.transform = CGAffineTransformIdentity;
    };
    
    void (^completionBlock)(void) = ^{
//        STRONG_REF(self_)
//        if (!self__) {
//            return ;
//        }
//        [self__.menuViewController endAppearanceTransition];
        if (!self) {
            return;
        }
        [self.menuViewController endAppearanceTransition];
    };
    
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:self.animationDuration animations:^{
            animationBlock();
        }completion:^(BOOL finished){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            completionBlock();
        }];
    } else {
        animationBlock();
        completionBlock();
    }
    
}

- (void)hideViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void)showMenuViewController{
    if (!self.menuViewController) {
        return;
    }
    [self.menuViewController beginAppearanceTransition:YES animated:YES];
    [self.view.window endEditing:YES];
    [self addContentButton];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(CGRectGetMidX(self.view.bounds), 0);
        self.menuView.transform = self.contentView.transform;
    }completion:^(BOOL finished){
        [self.menuViewController endAppearanceTransition];
    }];
    
}

- (void)addContentButton
{
    if (self.contentButton.superview)
        return;
    
    [self.contentView addSubview:self.contentButton];
    
    [self.contentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentButton)]];
}

- (void)addContainerConstraints:(UIViewController *)controller container:(UIView *)container{
    [self addChildViewController:controller];
    [container addSubview:controller.view];
    
    UIView *view = controller.view;
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    [controller didMoveToParentViewController:self];
}

#pragma mark - Gesture

- (void) addGesture {
    self.view.multipleTouchEnabled = NO;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer{
    //need to know how it works
//    NSLog(@"menuView:%f",self.menuView.frame.origin.x);
//    NSLog(@"contentView:%f",self.contentView.frame.origin.x);
    CGPoint point = [recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.contentView.frame.origin.x == CGRectGetWidth(self.view.bounds)/2 && point.x > 0) {
            return;
        }
        
        if ((self.contentView.frame.origin.x <= 0 && point.x < 0) || self.contentView.frame.origin.x + point.x < 0) {
            self.contentView.transform = CGAffineTransformIdentity;
            self.menuView.transform = CGAffineTransformIdentity;
            return;
        }
        
        if (self.contentView.frame.origin.x + point.x > CGRectGetWidth(self.view.bounds)/2) {
            point.x = CGRectGetWidth(self.view.bounds)/2 - self.contentView.frame.origin.x;
        }
        
        [recognizer setTranslation:CGPointZero inView:self.view];
        
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, point.x, 0);
        self.menuView.transform = self.contentView.transform;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ((self.contentView.frame.origin.x > 0 && self.contentView.frame.origin.x < 60.0)){
            [self hideMenuViewController];
        }
        else if (self.contentView.frame.origin.x == 0) {
            [self hideMenuViewControllerAnimated:NO];
        }
        else{
            if ([recognizer velocityInView:self.view].x > 0) {
                [self showMenuViewController];
            }
            else {
                [self hideMenuViewController];
            }
        }
    }
}


@end
