//
//  ThemesList.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/22.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "ThemesList.h"
#import "Theme.h"
#import "AFAppDotNetAPIClient.h"

@implementation ThemesList

+(instancetype)sharedInstance {
    static ThemesList *sharedThemesList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedThemesList = [[super allocWithZone:NULL] init];
    });
    return sharedThemesList;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (NSURLSessionDataTask *)getThemesListWithBlock:(void (^)(ThemesList *themeList, NSError *error))block {
    return [[AFAppDotNetAPIClient sharedClient] GET:@"themes" parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        ThemesList *themeList = [[ThemesList alloc] init];
        NSArray *themesFromResponse = [JSON valueForKeyPath:@"others"];
        themeList.themesListArray = [NSMutableArray arrayWithCapacity:[themesFromResponse count]];
        for (NSDictionary *attributes in themesFromResponse) {
            Theme *theme = [[Theme alloc] initWithAttributes:attributes];
            [themeList.themesListArray addObject:theme];
        }
        if (block) {
            block(themeList, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([ThemesList new], error);
        }
    }];
}



@end
