//
//  titles.h
//  ZhihuDaily
//
//  Created by 李达 on 16/9/7.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Titles : NSObject

@property (nonatomic, assign) NSUInteger titleID;
@property(nonatomic, copy) NSString *text;
@property (readonly, nonatomic, unsafe_unretained) NSURL *imageURL;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
