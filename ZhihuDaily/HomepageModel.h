//
//  HomepageModel.h
//  ZhihuDaily
//
//  Created by 李达 on 16/10/8.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CircleViewModel;
@class Titles;
@class DailyNewsList;

@interface HomepageModel : NSObject

@property (nonatomic, strong) NSArray<CircleViewModel *> *topStoriesArray;
@property (nonatomic, strong) NSMutableArray<DailyNewsList*> *storiesArray;
@property (nonatomic, strong) NSString *currentDate;

+ (instancetype)sharedInstance;
- (NSURLSessionDataTask *)getLatestStoriesWithBlock:(void (^)(HomepageModel *model, NSError *error))block;
- (NSURLSessionDataTask *)getPreviousStoriesWithBlock:(void (^)(DailyNewsList *model, NSError*error))block andDate:(NSString *)date;
- (BOOL)getPreviousNewsWithSection:(NSInteger *)section currentID:(NSInteger *)currentID;
- (BOOL) getNextNewsWithSection:(NSInteger *)section currentID:(NSInteger *)currentID;

@end
