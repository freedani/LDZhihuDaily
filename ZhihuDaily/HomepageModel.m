//
//  HomepageModel.m
//  ZhihuDaily
//
//  Created by 李达 on 16/10/8.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "HomepageModel.h"
#import "AFAppDotNetAPIClient.h"
#import "CircleViewModel.h"
#import "Titles.h"
#import "DailyNewsList.h"

@interface HomepageModel ()

@property(nonatomic, assign) BOOL isLoading;

@end

@implementation HomepageModel

//static id _instance = nil;
//单例方法

+(instancetype)sharedInstance {
    static HomepageModel *sharedHomepageModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHomepageModel = [[super allocWithZone:NULL] init];
    });
    return sharedHomepageModel;
}
////alloc会调用allocWithZone:

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


-(instancetype)init {
    self = [super init];
    if (!self) {
        _isLoading = NO;
        self.currentDate = nil;
    }
    return self;
}

- (NSURLSessionDataTask *)getLatestStoriesWithBlock:(void (^)(HomepageModel *model, NSError *error))block {
    return [[AFAppDotNetAPIClient sharedClient] GET:@"news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        HomepageModel *model = [[HomepageModel alloc] init];
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"top_stories"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            CircleViewModel *title = [[CircleViewModel alloc] initWithAttributes:attributes];
            [mutablePosts addObject:title];
        }
        NSArray *latestStoriesFromResponse = [JSON valueForKeyPath:@"stories"];
        DailyNewsList *dailyNewsList = [[DailyNewsList alloc] init];
        NSMutableArray *mutableLatestNews = [NSMutableArray arrayWithCapacity:[latestStoriesFromResponse count]];
        for (NSDictionary *attributes in latestStoriesFromResponse) {
            Titles *title = [[Titles alloc] initWithAttributes:attributes];
            [mutableLatestNews addObject:title];
        }
        model.currentDate = [JSON valueForKeyPath:@"date"];
        dailyNewsList.dailyNewsList = [[NSArray alloc] initWithArray:mutableLatestNews];
        dailyNewsList.date = model.currentDate;
        model.storiesArray = [NSMutableArray new];
        [model.storiesArray insertObject:dailyNewsList atIndex:0];
        model.topStoriesArray = mutablePosts;
        if (block) {
            block(model, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([HomepageModel new], error);
        }
    }];
}


- (NSURLSessionDataTask *)getPreviousStoriesWithBlock:(void (^)(DailyNewsList *model, NSError *error))block andDate: (NSString*)date {
    if (_isLoading) {
        return nil;
    } else {
        NSString *stringForHTTP = [NSString stringWithFormat:@"news/before/%@",date];
        self.isLoading = YES;
        return [[AFAppDotNetAPIClient sharedClient] GET:stringForHTTP parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
            DailyNewsList *model = [DailyNewsList new];
            NSArray *latestStoriesFromResponse = [JSON valueForKeyPath:@"stories"];
            NSMutableArray *mutableLatestNews = [NSMutableArray arrayWithCapacity:[latestStoriesFromResponse count]];
            for (NSDictionary *attributes in latestStoriesFromResponse) {
                Titles *title = [[Titles alloc] initWithAttributes:attributes];
                [mutableLatestNews addObject:title];
            }
            model.dailyNewsList = mutableLatestNews;
            model.date = [JSON valueForKeyPath:@"date"];
            if (block) {
                block(model, nil);
                self.isLoading = NO;
            }
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
            if (block) {
                block([DailyNewsList new], error);
                self.isLoading = NO;
            }
        }];
    }
}

- (BOOL)getPreviousNewsWithSection:(NSInteger *)section currentID:(NSInteger *)currentID {
    
    DailyNewsList *model = _storiesArray[*section];
    
    __block NSInteger previousNews = -1;
    
    [model.dailyNewsList enumerateObjectsUsingBlock:^(Titles *title, NSUInteger idx, BOOL *stop){
        if (title.titleID == *currentID) {
            *stop = YES;
        }
        else
            previousNews = title.titleID;
    }];
    
    if (previousNews > 0) {
        *currentID = previousNews;
        return true;
    }
    
    if (*section - 1 >= 0) {
        previousNews = [_storiesArray[*section - 1].dailyNewsList lastObject].titleID;
        *section -= 1;
        *currentID = previousNews;
        return true;
    }
    return false;
}

@end
