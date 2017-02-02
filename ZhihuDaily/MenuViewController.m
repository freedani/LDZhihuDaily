//
//  menuViewController.m
//  ZhihuDaily
//
//  Created by 李达 on 16/11/4.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "MenuViewController.h"
#import "SQLiteManager.h"
#import <SDWebImage/SDImageCache.h>

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    NSLog(@"initMenuUI");
    UIButton *clearStorageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 200, 100)];
    float byteSize = [[SQLiteManager sharedInstance] fileSize];
    CGFloat cacheSize = (float)byteSize/1024/1024;
    [clearStorageButton setTitle:[NSString stringWithFormat:@"缓存大小%.1fM",cacheSize] forState:UIControlStateNormal];
    [clearStorageButton setBackgroundColor:[UIColor blueColor]];
    [clearStorageButton addTarget:self action:@selector(ClickControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearStorageButton];
}

- (void)ClickControlAction {
//    int byteSize = (int)[SDImageCache sharedImageCache].getSize;
    float byteSize = [[SQLiteManager sharedInstance] fileSize];
    //M大小
    CGFloat cacheSize = (float)byteSize/1024/1024;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"缓存大小%.1fM",cacheSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"缓存大小%.1fM",cacheSize] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SQLiteManager sharedInstance] clearFile];
        //        [[SDImageCache sharedImageCache] clearDisk];
        //        [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSLog(@"cache clear");
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
