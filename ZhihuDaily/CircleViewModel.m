//
//  CircleViewModel.m
//  ZhihuDaily
//
//  Created by 李达 on 16/10/4.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "CircleViewModel.h"
#import "AFAppDotNetAPIClient.h"

@interface CircleViewModel()

@property (nonatomic, copy) NSString *imageURLString;

@end

@implementation CircleViewModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.titleID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.text = [attributes valueForKeyPath:@"title"];
//    NSArray *stringArray = [attributes valueForKeyPath:@"images"];
    self.imageURLString = [attributes valueForKeyPath:@"image"];
    
    return self;
}

- (NSURL *)imageURL {
    return [NSURL URLWithString:self.imageURLString];;
}

@end
