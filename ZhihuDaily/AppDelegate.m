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

@interface AppDelegate ()<SDWebImageManagerDelegate>

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
    
    [SDWebImageManager sharedManager].delegate = self;
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    
    return YES;
}

#pragma mark SDWebImageManagerDelegate

//- (BOOL)imageManager:(SDWebImageManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL {
//    
//    /*
//     check the network condition and the setting
//     */
//    
//    if ([self reachabilityStatusReachableViaWWAN]) {
//        /*
//         be care about what happen if reachability or setting change
//         */
////        return false;
//        return true;
//    }
//    
//    return true;
//}

- (BOOL)reachabilityStatusReachableViaWWAN {
//    switch([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
//        case AFNetworkReachabilityStatusUnknown:
//            NSLog(@"unknown");
//            break;
//        case AFNetworkReachabilityStatusNotReachable:
//            NSLog(@"not reachable");
//            break;
//        case AFNetworkReachabilityStatusReachableViaWWAN:
//            NSLog(@"2/3/4G");
//            return true;
//        case AFNetworkReachabilityStatusReachableViaWiFi:
//            NSLog(@"WiFi");
//            return false;
//    }
//    return true;
    
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

@end
