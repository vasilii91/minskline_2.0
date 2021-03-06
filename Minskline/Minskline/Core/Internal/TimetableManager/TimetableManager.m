//
//  TimetableManager.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "TimetableManager.h"

static NSInteger PERIOD_OF_TIME_IN_MINUTES = 25;

@implementation TimetableManager


#pragma mark - Initialization

static TimetableManager *_sharedMySingleton = nil;

+ (TimetableManager *)sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[TimetableManager alloc] init];
        }
    }
    
    return _sharedMySingleton;
}


#pragma mark - Public methods

- (void)processTimetableFromURL:(NSString *)URL
{
    NSString *urlString = URL;
    
    NSString *webpage = [NSString stringWithContentsOfURL:[NSURL URLWithString: urlString]
                                                 encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsCyrillic)
                                                    error:nil];
    
	NSArray *lines = [webpage componentsSeparatedByString: @"<b>"];
    timetable = [[NSMutableArray alloc] init];
    
    // если второй символ - это буква, то формат html неверный и тогда нужно начинать не с третьей
    // строки, а с четвертой
    
    NSInteger indexToStart = 0;
    NSInteger toCheck = [lines count] > 2 ? [[lines objectAtIndex:2] characterAtIndex:0] : 100;
    if (toCheck >= 48 && toCheck <= 58) {
        indexToStart = 2;
    }
    else {
        indexToStart = 3;
    }
    
    for (int i = indexToStart; i < [lines count]; i++) {
        NSArray *oneLine = [[lines objectAtIndex:i] componentsSeparatedByString:@" "];
        NSMutableArray *newOneLine = nil;
        newOneLine = [oneLine mutableCopy];
        
        for (int k = 0; k < [oneLine count]; k++) {
            NSString *fromItString = [oneLine objectAtIndex:k];
            fromItString = [self deleteNotNeedElements:fromItString andDeletingString:@"<u>"];
            [newOneLine replaceObjectAtIndex:k withObject:fromItString];
        }
        int hour = [[[newOneLine objectAtIndex:0] substringWithRange: NSMakeRange(0, 2)] intValue];
        if (hour == 0) {
            hour = 24;
        }
        
        int minute = 0;
        NSNumber *minutesFormat = nil;
        for (int j = 3; j < [newOneLine count]; j++) {
            @try {
                minute = [[[newOneLine objectAtIndex:j] substringWithRange: NSMakeRange(0, 2)] intValue];
                minutesFormat = [NSNumber numberWithInt: (60 * hour + minute)];
                [timetable addObject:minutesFormat];
            }
            @catch (NSException *e) {
                NSLog(@"Exception %@", e);
            }
            @finally {
                continue;
            }
        }
    }
}

- (NSMutableString*)deleteNotNeedElements:(NSString *)fromItString andDeletingString:(NSString *)deletingString
{
    NSMutableString *temp = [NSMutableString stringWithString: fromItString];
    NSRange deletingRange = [temp rangeOfString: deletingString];
    if (deletingRange.location != NSIntegerMax) {
        [temp deleteCharactersInRange: deletingRange];
    }
    return temp;
}

- (NSMutableArray *)timetable
{
    return timetable;
}

- (NSString *)timetableInStringFormat
{
    NSMutableString *result = nil;
    for (int i = 0; i < [timetable count]; i++) {
        NSNumber *minutesFormat = [timetable objectAtIndex:i];
        result = [NSMutableString stringWithFormat:@"%@%i;", result, [minutesFormat intValue]];
    }
    
    return result;
}

+ (NSMutableArray *)timetableInIntegerFormat:(NSString *)timetableInStringFormat
{
    NSInteger activeInterval = PERIOD_OF_TIME_IN_MINUTES;
    UserSettings *settings = [UserSettings sharedSingleton];
    activeInterval = [settings interval] == 0 ? activeInterval : [settings interval];
    
    NSArray *source = [timetableInStringFormat componentsSeparatedByString:@";"];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSInteger currentTimeInMinutes = [self getCurrentTimeInMinutes];
    for (NSString *minutes in source) {
        NSInteger minute = [minutes intValue];
        NSInteger difference = minute - currentTimeInMinutes;
        // записываем в результирующий массив сразу разницу, т.е.
        // время, через которое будут появляться маршрутные средства
        if (difference > 0 && difference <= activeInterval) {
            [result addObject:[NSNumber numberWithInt: difference]];
        }
    }
    
    return result;
}

+ (NSMutableArray *)timetableInIntegerFormatFull:(NSString *)timetableInStringFormat
{
    // в начале почему-то лежит (null) поэтому начинаем с 6 символа
    timetableInStringFormat = [timetableInStringFormat substringFromIndex:6];
    NSArray *source = [timetableInStringFormat componentsSeparatedByString:@";"];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *minutes in source) {
        NSInteger minute = [minutes intValue];
        [result addObject:[NSNumber numberWithInt: minute]];
    }
    
    return result;
}

+ (NSInteger)getCurrentTimeInMinutes
{
    NSDate *myDateHere = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSMinuteCalendarUnit | NSHourCalendarUnit) fromDate:myDateHere];
    NSInteger hour = [dateComponents hour];
    NSInteger minutes = [dateComponents minute];
    
    // если время перешло за полночь, то считаем, что еще текущий день
    hour = hour == 0 ? 24 : hour;
    hour = hour == 1 ? 25 : hour;
    
    NSInteger timeInMinutes = hour * 60 + minutes;
    
    return timeInMinutes;
}

// 0 - если даты одинаковы; -1 - если вторая дата позже первой; 1 - если первая позже второй
+ (NSComparisonResult)compareOneDate:(NSString *)firstDateString withAnother:(NSString *)secondDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    
    NSDate *dateFromString1 = [dateFormatter dateFromString:firstDateString];
    NSDate *dateFromString2 = [dateFormatter dateFromString:secondDateString];
    
    NSComparisonResult result = [dateFromString1 compare:dateFromString2];
    
    return result;
}

+ (NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return strDate;
}

+(NSInteger)getCurrentDayOfWeek
{
    // узнаем текущую дату, чтобы выбрать из базы актуальную инфу, соответствующую
    // дню недели. В базе есть дни: 1 - будние, 6 - суббота, 7 - воскресенье
    NSDate *myDateHere = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit) fromDate:myDateHere];
    NSInteger hour = [dateComponents hour];
    //    NSInteger day = [dateComponents day];
    // непонятно почему, но день возвращается на единицу больше, поэтому приходится отымать единицу
    
    NSInteger dayOfWeek = [dateComponents weekday];
    
    // т.к. стоит американская культура, а как поставить русскую я не знаю, то возвращает
    // единицу в воскресенье, т.е. в Америке неделя начинается с воскресенья.
    // поэтому делаем вот так:
    dayOfWeek = (dayOfWeek + 5) % 7 + 1;
    
    //    NSLog(@"Day of week = %i, day = %i, hour = %i", dayOfWeek, day, hour);
    
    // если уже больше двух часов ночи, то считаем, что это еще текущий день. Т.к. транспорт
    // в основном ходит до 1-2 ночи.
    if (hour <= 2) {
        dayOfWeek -= 1;
    }
    
    if (dayOfWeek >= 1 && dayOfWeek <= 5) {
        dayOfWeek = 1;
    }
    else if (dayOfWeek == 0) {
        dayOfWeek = 7;
    }
    return dayOfWeek;
}

@end
