//
//  LaunchViewController.m
//  ZhihuDaily
//
//  Created by 李达 on 2016/11/21.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "LaunchViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>

@interface LaunchViewController ()

@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void) initUI {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.view.backgroundColor = [UIColor grayColor];
    self.imageView = [UIImageView new];
    NSString *imageURLString = @"https://pic1.zhimg.com/v2-af3c66f37f9e31d7815f0b196b5865ec.jpg";
    NSURL *imageURL = [[NSURL alloc] initWithString:imageURLString];
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"launchImage"]];
    [self.view addSubview:self.imageView];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
