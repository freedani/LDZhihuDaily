//
//  Theme.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/22.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "Theme.h"

@implementation Theme

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.themeID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.themeName = [attributes valueForKeyPath:@"name"];
    return self;
}

@end
