//
//  SRMCalendarTool.h
//  Cal
//
//  Created by Sorumi on 16/7/26.
//  Copyright © 2016年 Sorumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRMCalendarTool : NSObject

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

+ (instancetype)tool;

- (NSInteger)yearOfDate:(NSDate *)date;
- (NSInteger)monthOfDate:(NSDate *)date;
- (NSInteger)dayOfDate:(NSDate *)date;
- (NSInteger)weekdayOfDate:(NSDate *)date;
- (NSInteger)weekOfDate:(NSDate *)date;
- (NSInteger)hourOfDate:(NSDate *)date;
- (NSInteger)miniuteOfDate:(NSDate *)date;
- (NSInteger)secondOfDate:(NSDate *)date;

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)weeksFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)hoursFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)minutesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSDate *)dateByAddingYears:(NSInteger)years toDate:(NSDate *)date;
- (NSDate *)dateByAddingMonths:(NSInteger)months toDate:(NSDate *)date;
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks toDate:(NSDate *)date;
- (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date;
- (NSDate *)dateByAddingHours:(NSInteger)hours toDate:(NSDate *)date;

- (NSDate *)beginningOfMonthOfDate:(NSDate *)date;
- (NSDate *)beginningOfWeekOfDate:(NSDate *)date;
- (NSDate *)beginningOfDayOfDate:(NSDate *)date;
- (NSInteger)dayCountOfMonthofDate:(NSDate *)date;

- (BOOL)date:(NSDate *)date1 isEqualToDate:(NSDate *)date2;

- (NSString *)dateAndTimeFormat:(NSDate *)date;
- (NSString *)dateFormat:(NSDate *)date;
- (NSString *)timeFormat:(NSDate *)date;
- (NSString *)weekdayFormat:(NSDate *)date;

- (NSDate *)dateOnHour:(NSDate *)date;

@end
