//
//  TimetableManager.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimetableManager : NSObject
{
    NSMutableArray *timetable;
}

+ (TimetableManager *)sharedMySingleton;

- (void)processTimetableFromURL:(NSString *)URL;
- (NSMutableArray *)timetable;
- (NSString *)timetableInStringFormat;
+ (NSMutableArray *)timetableInIntegerFormat:(NSString *)timetableInStringFormat;
+ (NSMutableArray *)timetableInIntegerFormatFull:(NSString *)timetableInStringFormat;
+ (NSInteger)getCurrentDayOfWeek;
+ (NSString *)getCurrentDate;
+ (NSComparisonResult)compareOneDate:(NSString *)firstDateString withAnother:(NSString *)secondDateString;
+ (NSInteger)getCurrentTimeInMinutes;

@end
