//
//  ThemesList.h
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/22.
//  Copyright © 2017年 李达. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Theme;

@interface ThemesList : NSObject

@property (nonatomic, strong) NSMutableArray<Theme *> *themesListArray;

+ (instancetype)sharedInstance;
- (NSURLSessionDataTask *)getThemesListWithBlock:(void (^)(ThemesList *themeList, NSError *error))block;

@end
