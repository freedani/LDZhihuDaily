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
#import "MenuView.h"
#import "ThemesList.h"
#import "Theme.h"

@interface MenuViewController () <CacheDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) ThemesList *themesList;

- (void)ClickControlAction;

@end

@implementation MenuViewController

#pragma mark - Getter Method

-(ThemesList*)themesList {
    /*
     lazy initialization
     */
    
    if (!_themesList) {
        self.themesList = [ThemesList new];
        return self.themesList;
    }
    return _themesList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
//    [self initData];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    _menuView = [[MenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, kScreenHeight)];
    [self.view addSubview:_menuView];
    [self initData];
    _menuView.menuTableView.delegate = self;
    _menuView.menuTableView.dataSource = self;
}

- (void)initData {
    NSURLSessionTask __unused *task = [self.themesList getThemesListWithBlock:^(ThemesList *themesList, NSError *error) {
        if (!error) {
            _themesList = themesList;
            [self.menuView.menuTableView reloadData];
        }
    }];
    [task resume];
}

#pragma mark - CacheDelegate

- (void)ClickControlAction {
    
    float byteSize = [[SQLiteManager sharedInstance] fileSize];
    CGFloat cacheSize = (float)byteSize/1024/1024;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"缓存大小%.1fM",cacheSize] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SQLiteManager sharedInstance] clearFile];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"select row:%ld",indexPath.row);
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(__unused UITableView *)tableView
 numberOfRowsInSection:(__unused NSInteger)section
{
    return (NSInteger)[_themesList.themesListArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.frame = CGRectMake(0, 0, kScreenWidth/2, 20);
        cell.backgroundColor = [UIColor colorWithRed:35/255.0 green:42/255.0 blue:50/255.0 alpha:1];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu_Enter"]];
        cell.textLabel.textColor = [UIColor colorWithRed:148/255.0f green:153/255.0f blue:157/255.0f alpha:1];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor blackColor];
        bgColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView = bgColorView;
    }
    
    if (indexPath.row == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"Menu_Icon_Home"]];
        cell.textLabel.text = @"主页";
    } else {
        cell.textLabel.text = _themesList.themesListArray[indexPath.row - 1].themeName;
        [cell.imageView setImage:nil];
    }
    NSLog(@"row:%ld name:%@",indexPath.row, cell.textLabel.text);
    return cell;
}



@end
