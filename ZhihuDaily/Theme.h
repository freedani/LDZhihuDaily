//
//  Theme.h
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/22.
//  Copyright © 2017年 李达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

@property (nonatomic, assign) NSInteger themeID;
@property (nonatomic, strong) NSString *themeName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
