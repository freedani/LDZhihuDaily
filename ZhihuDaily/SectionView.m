//
//  sectionView.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/12.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "SectionView.h"

@interface SectionView ()

@property (nonatomic, strong) UILabel *sectionLable;

@end

@implementation SectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [sectionLabel setFont:[UIFont systemFontOfSize:16]];
    [sectionLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:sectionLabel];
    _sectionLable = sectionLabel;
    /*
     设置居中
     */
    [sectionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:sectionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:sectionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self setBackgroundColor:[UIColor colorWithRed:24/255.0 green:144/255.0 blue:211/255.0 alpha:1]];
    
}

- (void)setViewWithDateString:(NSString *)dateString {
    self.sectionLable.text = [self formatDateStringWithString:dateString];
}

- (NSString *)formatDateStringWithString:(NSString *)string {
    
    NSDateFormatter *stringToDateFormatter = [[NSDateFormatter alloc] init];
    [stringToDateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [stringToDateFormatter dateFromString:string];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];

    NSString *weekday = [self weekdayStringFromDate:localeDate];
    
    NSDateFormatter *dateToStringFormatter = [[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:@"MM月dd日"];
    NSString *strDate = [dateToStringFormatter stringFromDate:localeDate];
    
    return [strDate stringByAppendingFormat:@" %@",weekday];
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end
