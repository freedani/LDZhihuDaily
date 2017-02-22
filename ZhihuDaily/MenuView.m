//
//  MenuView.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/15.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "MenuView.h"
#import "SQLiteManager.h"

@interface MenuView ()

@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    [self setBackgroundColor:[UIColor colorWithRed:35/255.0 green:42/255.0 blue:50/255.0 alpha:1]];
    [self initUserButton];
    [self initTopView];
    [self initTableView];
    [self initBottomView];
    
    // add constrant here ?
}

- (void)initUserButton {
    
    _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _userButton.frame = CGRectMake(10.0f, statuBarHeight, kScreenWidth / 2 - 20.0f, statuBarHeight + tableViewHeaderHeight);
    [_userButton setImage:[UIImage imageNamed:@"Menu_Avatar"] forState:UIControlStateNormal];
//    [_userButton setImage:[UIImage imageNamed:@"Menu_Avatar"] forState:UIControlStateHighlighted];
    [_userButton setTitle:@"请登录" forState:UIControlStateNormal];
    [_userButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_userButton setTitleColor:[UIColor colorWithRed:148/255.0f green:153/255.0f blue:157/255.0f alpha:1] forState:UIControlStateNormal];
    [self addSubview:_userButton];
    [_userButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_userButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_userButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userButton)]];
    
    /*
     UIButton image and title layout
     */
    [_userButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _userButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)initTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 74.0f, kScreenWidth / 2, 54.0f)];
    [self addSubview:_topView];
    [_topView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_userButton]-[_topView(==54)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userButton, _topView)]];

    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(0, 0, 54.0, 54.0);
    [collectButton setImage:[UIImage imageNamed:@"Menu_Icon_Collect"] forState:UIControlStateNormal];
    [collectButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [collectButton setTitleColor:[UIColor colorWithRed:148/255.0f green:153/255.0f blue:157/255.0f alpha:1] forState:UIControlStateNormal];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    collectButton.imageEdgeInsets = UIEdgeInsetsMake(-collectButton.imageView.bounds.size.height, collectButton.bounds.size.width/2 - collectButton.imageView.bounds.size.width/2, 0, 0);
    collectButton.titleEdgeInsets = UIEdgeInsetsMake(collectButton.titleLabel.bounds.size.height, collectButton.bounds.size.width/2 - collectButton.titleLabel.bounds.size.width/2 - collectButton.imageView.bounds.size.width, 0, 0);

    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(54.0, 0, 54.0, 54.0);
    [messageButton setImage:[UIImage imageNamed:@"Menu_Icon_Message"] forState:UIControlStateNormal];
    [messageButton setTitle:@"消息" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor colorWithRed:148/255.0f green:153/255.0f blue:157/255.0f alpha:1] forState:UIControlStateNormal];
    [messageButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [messageButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    messageButton.imageEdgeInsets = UIEdgeInsetsMake(-messageButton.imageView.bounds.size.height, messageButton.bounds.size.width/2 - messageButton.imageView.bounds.size.width/2, 0, 0);
    messageButton.titleEdgeInsets = UIEdgeInsetsMake(messageButton.titleLabel.bounds.size.height, messageButton.bounds.size.width/2 - messageButton.titleLabel.bounds.size.width/2 - messageButton.imageView.bounds.size.width, 0, 0);
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(108.0, 0, 54.0, 54.0);
    [settingButton setImage:[UIImage imageNamed:@"Menu_Icon_Setting"] forState:UIControlStateNormal];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor colorWithRed:148/255.0f green:153/255.0f blue:157/255.0f alpha:1] forState:UIControlStateNormal];
    [settingButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [settingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    settingButton.imageEdgeInsets = UIEdgeInsetsMake(-settingButton.imageView.bounds.size.height, settingButton.bounds.size.width/2 - settingButton.imageView.bounds.size.width/2, 0, 0);
    settingButton.titleEdgeInsets = UIEdgeInsetsMake(settingButton.titleLabel.bounds.size.height, settingButton.bounds.size.width/2 - settingButton.titleLabel.bounds.size.width/2 - settingButton.imageView.bounds.size.width, 0, 0);
    
    [_topView addSubview:collectButton];
    [_topView addSubview:messageButton];
    [_topView addSubview:settingButton];
}

- (void) initTableView {
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 124.0f, kScreenWidth/2, kScreenHeight - 182.0f) style:UITableViewStylePlain];
    [self addSubview:_menuTableView];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.backgroundColor = [UIColor colorWithRed:35/255.0 green:42/255.0 blue:50/255.0 alpha:1];
}

- (void) initBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kScreenHeight - 54.0f, kScreenWidth / 2, 54.0f)];
    [self addSubview:_bottomView];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(0.0f, 0.0f, kScreenWidth/4, 54.0f);
    [downloadButton setImage:[UIImage imageNamed:@"Menu_Download"] forState:UIControlStateNormal];
    [downloadButton setTitle:@"离线" forState:UIControlStateNormal];
    [downloadButton setTitleColor:[UIColor colorWithRed:148/255.0f green:153/255.0f blue:157/255.0f alpha:1] forState:UIControlStateNormal];
    [downloadButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    downloadButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0f, 0, 0);
    
    UIButton *nightStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nightStyleButton.frame = CGRectMake(kScreenWidth/4 , 0.0f, kScreenWidth/4, 54.0f);
    [nightStyleButton setImage:[UIImage imageNamed:@"Menu_Dark"] forState:UIControlStateNormal];
    [nightStyleButton setTitle:@"夜间" forState:UIControlStateNormal];
    [nightStyleButton setTitleColor:[UIColor colorWithRed:148/255.0f green:153/255.0f blue:157/255.0f alpha:1] forState:UIControlStateNormal];
    [nightStyleButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    nightStyleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0f, 0, 0);
    
    [_bottomView addSubview:downloadButton];
    [_bottomView addSubview:nightStyleButton];
    
}

/*
 
- (void) addClearButton {
     UIButton *clearStorageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 200, 100)];
     float byteSize = [[SQLiteManager sharedInstance] fileSize];
     CGFloat cacheSize = (float)byteSize/1024/1024;
     [clearStorageButton setTitle:[NSString stringWithFormat:@"缓存大小%.1fM",cacheSize] forState:UIControlStateNormal];
     [clearStorageButton setBackgroundColor:[UIColor blueColor]];
     [clearStorageButton addTarget:self.delegate action:@selector(ClickControlAction) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:clearStorageButton];
 }
 
 */

@end
