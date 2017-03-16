//
//  AppDelegate.m
//  ZhihuDaily
//
//  Created by 李达 on 16/9/7.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "AppDelegate.h"
#import "TitlesViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    TitlesViewController *viewController =[[TitlesViewController alloc] init];
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    MainViewController *mainViewController = [[MainViewController alloc] initWithContentVC:viewController menuVC:menuViewController];
    
    
//    mainViewController.contentViewController = viewController;
//    mainViewController.menuViewController = menuViewController;
    
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    
    return YES;
}

/**
 * Judge the reacheability status is WWAN(2/3/4G) or not.
 * return YES means the status is WWAN.
 */
- (BOOL)reachabilityStatusReachableViaWWAN {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

@end
