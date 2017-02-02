//
//  NewsDetailModel.m
//  ZhihuDaily
//
//  Created by 李达 on 16/10/1.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "NewsDetailModel.h"

@implementation NewsDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"body":@"body",
             @"image_source":@"image_source",
             @"title":@"title",
             @"image":@"image",
             @"share_url":@"share_url",
             @"js":@"js",
             @"images":@"images",
             @"type":@"type",
             @"storyID":@"id",
             @"css":@"css"
             };
}

@end
