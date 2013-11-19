//
//  DownloadManager.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "DownloadManager.h"
#import "TypeOfTransport.h"
#import "MORoute.h"
#import "MOStop.h"
#import "MOTimetable.h"
#import "DatabaseManager.h"
#import "TimetableManager.h"

@implementation DownloadManager

static DownloadManager *_sharedMySingleton = nil;


#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        databaseManager = [DatabaseManager sharedMySingleton];
        timetableManager = [TimetableManager sharedMySingleton];
    }
    
    return self;
}

+ (DownloadManager *)sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[DownloadManager alloc] init];
        }
    }
    
    return _sharedMySingleton;
}


#pragma mark - Public methods

- (void)downloadTimetableFromMinsktrans
{
    NSLog(@"START");
    [self mergeStopsWithDatabase];
    
    [self downloadAllStopsFromMinsktrans];
#warning Вычитать все остановки и соотнести их со всеми маршрутами
    
#warning Возвращает nil
//    [self sendRequestForLastModifiedHeadersForURLString:@"http://www.minsktrans.by/pda/index.php?RouteNum=2с&StopID=68811&RouteType=A%3EB&day=1&Transport=Autobus"];
    
    @autoreleasepool {
        // get info about all stops from core-URL
        //    [self getInfoAboutAllStopsAndSaveToDatabase];
        
        // с - \U0441
        // д - \U0434
        // т - \U0442
        // э - \U044d
        // в - \U0432
        // г - \U0433
        // а - \U0430
        // б - \U0431
        // A memory will be clear automatically because we don't use alloc and init
        NSArray* letters = [NSArray arrayWithObjects:@"а", @"б", @"в", @"г",
                            @"д", @"с", @"т", @"э", nil];
        NSArray* unicodeLetters = [NSArray arrayWithObjects:@"U0430", @"U0431", @"U0432", @"U0433",
                                   @"U0434", @"U0441", @"U0442", @"U044d", nil];
        
        NSDictionary *dictionaryWithLetters = [NSDictionary dictionaryWithObjects:letters forKeys:unicodeLetters];
        
        NSString *urlString = @"http://www.minsktrans.by/city/minsk/routes.txt";
        
        NSMutableDictionary *dictionaryOfHeaders = [[NSMutableDictionary alloc] init];
        
        NSString *webpage = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *lines = [webpage componentsSeparatedByString: @"\n"];
        
        if ([lines count] != 0) {
            NSArray *headers = [[lines objectAtIndex:0] componentsSeparatedByString:@";"];
            
            for (int i = 0; i < 15; i++) {
                NSString *line = [headers objectAtIndex:i];
                NSNumber *number = [NSNumber numberWithInt: i + 1];
                [dictionaryOfHeaders setObject:line forKey:number];
            }
            
            int i;
            NSString* previousRouteNumber = nil;
            NSString* routeNumber = nil;
            NSString* typeOfTransport = nil;
            NSString *typeOfTransport0 = nil;
            TypeOfTransportEnum typeOfTransportEnum;
            NSString* routeType = nil;
            NSString* routeId = nil;
            
            NSInteger countOfProceededURLs = 0;
            
//            countOfProceededURLs = 9819;
//            typeOfTransport0 = @"bus";
//            for (i = 588; i < [lines count]; i++)
            for (i = 1; i < [lines count]; i++)
            {
                MORoute *route = [databaseManager newRoute];
                NSString *oneRouteString = [lines objectAtIndex:i];
                NSArray *oneRouteArray = [oneRouteString componentsSeparatedByString:@";"];
                
                routeNumber = [oneRouteArray objectAtIndex:0];
                
                if ([routeNumber isEqual:@""]) {
                    routeNumber = previousRouteNumber;
                }
                else {
                    previousRouteNumber = routeNumber;
                }
                
                NSUInteger backslashLocation = [previousRouteNumber rangeOfString:@"U"].location;
                if (backslashLocation != NSIntegerMax) {
                    NSMutableString* correctRouteNumber = [NSMutableString stringWithString:[previousRouteNumber substringToIndex:backslashLocation - 1]];
                    NSString* unicodeLetter = [previousRouteNumber substringFromIndex: backslashLocation];
                    [correctRouteNumber appendFormat:@"%@%@", correctRouteNumber, [dictionaryWithLetters objectForKey:unicodeLetter]];
                    previousRouteNumber = correctRouteNumber;
                }
                
                //----------------------------------------------//
                route.transportNumber = previousRouteNumber;
                //----------------------------------------------//
                
                // get type of transport. Words "bus", "tram", "metro", "trol" meet once in source.
                
                NSString *temp = [oneRouteArray objectAtIndex:3];
                if (![temp isEqualToString:@""]) {
                    typeOfTransport0 = temp;
                }
                
                if ([typeOfTransport0 isEqualToString:@"bus"]) {
                    typeOfTransport = @"Autobus";
                    typeOfTransportEnum = BUS;
                }
                else if ([typeOfTransport0 isEqualToString:@"tram"]) {
                    typeOfTransport = @"Tramway";
                    typeOfTransportEnum = TRAMWAY;
                }
                else if ([typeOfTransport0 isEqualToString:@"trol"]) {
                    typeOfTransport = @"Trolleybus";
                    typeOfTransportEnum = TROLLEYBUS;
                }
                else if ([typeOfTransport0 isEqualToString:@"metro"]) {
                    typeOfTransport = @"Metro";
                    typeOfTransportEnum = METRO;
                }
                
                //----------------------------------------------//
                route.typeOfTransport = @(typeOfTransportEnum);
                //----------------------------------------------//
                
                routeType = [oneRouteArray[8] stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
                
                //----------------------------------------------//
                route.routeName = oneRouteArray[10];
                //----------------------------------------------//
                
                NSString *weekdays = oneRouteArray[11];
                NSMutableArray *weekdaysAsArray = [[NSMutableArray alloc] init];
                
                // Need only Monday-schedule, Saturday-schedule and Sunday-schedule
                NSArray *patternArray = @[@"1", @"6", @"7"];
                
                for (NSString *patternString in patternArray) {
                    if ([weekdays rangeOfString:patternString].location != NSNotFound) {
                        [weekdaysAsArray addObject:patternString];
                    }
                }
                
                routeId = [oneRouteArray objectAtIndex:12];
                
                //----------------------------------------------//
                route.routeId = @([routeId intValue]);
                //----------------------------------------------//
                
                NSArray *routeStopsAsArray = [oneRouteArray[14] componentsSeparatedByString:@","];
                
                int i = 0;
                for (NSString* stopId in routeStopsAsArray) {
                    
                    MOStop *stop = [databaseManager newStop];
                    stop.stopId = stopId;
                    stop.ordinalNumberInRoute = @(i++);
                    
                    for (NSString* weekday in weekdaysAsArray) {
                        NSString *stopURL = [NSString stringWithFormat: @"http://www.minsktrans.by/pda/index.php?RouteNum=%@&StopID=%@&RouteType=%@&day=%@&Transport=%@", previousRouteNumber, stopId, routeType, weekday, typeOfTransport];
                        
                        NSDate *lastModifiedDate = [self sendRequestForLastModifiedHeadersForURLString:stopURL];
                        
                        if (lastModifiedDate) {
                            
                            NSString* escapedStopURL = [stopURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            [timetableManager processTimetableFromURL:escapedStopURL];
                            
                            //----------------------------------------------//
                            MOTimetable *timetable = [databaseManager newTimetable];
                            timetable.dayOfWeek = @([weekday intValue]);
                            timetable.lastModifiedDate = lastModifiedDate;
                            timetable.time = [timetableManager timetableInStringFormat];
                            timetable.urlToTimetable = stopURL;
                            //----------------------------------------------//
                            
                            if (timetable.time) {
                                [stop addTimetablesObject:timetable];
                                countOfProceededURLs++;
                                NSLog(@"URLs - %i", countOfProceededURLs);
                            }
                        }
                    }
                    
                    if ([[stop timetables] count] > 0) {
                        [route addStopsObject:stop];
                    }
                }
                
                if ([[route stops] count] > 0) {
                    [route.managedObjectContext MR_saveToPersistentStoreAndWait];
                    
                    NSArray *routes = [[DatabaseManager sharedMySingleton] allRoutes];
                    LOG(@"Proceeded routes - %d; i = %d", [routes count], i);
                }
                else {
                    [route.managedObjectContext rollback];
                }
            }
            
        }
        
        NSLog(@"FINISH");
    }
}

- (void)downloadAllStopsFromMinsktrans
{
    NSString *urlString = @"http://www.minsktrans.by/city/minsk/stops.txt";
    NSMutableDictionary *dictionaryOfHeaders = [[NSMutableDictionary alloc] init];
    
    NSString *webpage = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]encoding:NSUTF8StringEncoding error:nil];
    
	NSArray *allStops = [webpage componentsSeparatedByString: @"\n"];
    
    if ([allStops count] != 0) {
        NSArray *line = [[allStops objectAtIndex:0] componentsSeparatedByString:@";"];
        for (int i = 1; i < [line count]; i++) {
            NSNumber *number = [NSNumber numberWithInt: i];
            [dictionaryOfHeaders setObject:[line objectAtIndex:i - 1] forKey:number];
        }
        
        NSString *ID = nil;
        NSString *city = nil;
        NSString *area = nil;
        NSString *street = nil;
        NSString *name = nil;
        NSString *info = nil;
        NSString *longitude = nil;
        NSString *latitude = nil;
        
        MORoute *route = [databaseManager newRoute];
        route.routeName = MAIN_ROUTE;
        
        for (int i = 1; i <= [allStops count]; i++) {
            
            if (i >= [allStops count])
                break;
            
            NSArray *stopAsArray = [[allStops objectAtIndex:i] componentsSeparatedByString:@";"];
            if ([stopAsArray count] != 10)
                break;
            int k = 0;
            
            ID = [stopAsArray objectAtIndex:k++];
            city = [stopAsArray objectAtIndex:k++];
            area = [stopAsArray objectAtIndex:k++];
            street = [stopAsArray objectAtIndex:k++];
            
            NSString *tempName = [stopAsArray objectAtIndex:k++];
            name = [tempName isEqualToString:@""] ? name : tempName;;
            
            info = [stopAsArray objectAtIndex:k++];
            
            longitude = [stopAsArray objectAtIndex:k++];
            latitude = [stopAsArray objectAtIndex:k++];
            
            //----------------------------------------------//
            MOStop *oneStop = [databaseManager newStop];
            oneStop.stopId = ID;
            oneStop.stopName = name;
            oneStop.latitude = @([latitude floatValue]);
            oneStop.longitude = @([longitude floatValue]);
            
            [route addStopsObject:oneStop];
        }
        
        [route.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
}


#pragma mark - Private methods

- (NSDate *)sendRequestForLastModifiedHeadersForURLString:(NSString *)urlString
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if ([response respondsToSelector:@selector(allHeaderFields)])
    {
        NSDictionary *dictionary = [response allHeaderFields];
        NSString *lastUpdated = [dictionary valueForKey:@"Date"];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"EEE, dd MMM yyyy HH:mm:ss zzz"];
        NSDate * result = [dateFormatter dateFromString:lastUpdated];
        
        return result;
        
    } else {
        return nil;
    }
}

- (void)mergeStopsWithDatabase
{
    LOG(@"%d", [[databaseManager allMainRouteStops] count]);
    int i = 0;
    
    for (MOStop *stop in [databaseManager allMainRouteStops]) {
        
        for (MORoute *route in [databaseManager allRoutes]) {
            
            for (MOStop *stopInRoute in route.stops) {
                if ([stop.stopId isEqualToString:stopInRoute.stopId]) {
                    stopInRoute.latitude = stop.latitude;
                    stopInRoute.longitude = stop.longitude;
                    stopInRoute.stopName = stop.stopName;
                }
            }
            
            [route.managedObjectContext MR_saveToPersistentStoreAndWait];
        }
        LOG(@"%d", i++);
    }
}

@end
