//
//  DailyNewsList.h
//  ZhihuDaily
//
//  Created by 李达 on 16/10/15.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Titles.h"

@interface DailyNewsList : NSObject

@property (nonatomic, strong) NSArray<Titles*> *dailyNewsList;
@property (nonatomic, copy) NSString *date;

@end
