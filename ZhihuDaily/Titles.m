//
//  titles.m
//  ZhihuDaily
//
//  Created by 李达 on 16/9/7.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "Titles.h"
#import "AFAppDotNetAPIClient.h"

@interface Titles ()

@property (readwrite, nonatomic, copy) NSString *imageURLString;

@end

@implementation Titles 

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.titleID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.text = [attributes valueForKeyPath:@"title"];
    NSArray *stringArray = [attributes valueForKeyPath:@"images"];
    self.imageURLString = [stringArray objectAtIndex:0];
    
    return self;
}

- (NSURL *)imageURL {
    return [NSURL URLWithString:self.imageURLString];;
}

@end
