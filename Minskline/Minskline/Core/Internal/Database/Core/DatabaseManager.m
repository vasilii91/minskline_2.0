//
//  DatabaseManager.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "DatabaseManager.h"
#import "MORoute.h"
#import "MOStop.h"
#import "MOTimetable.h"

static NSString *fTransportNumber = @"transportNumber";
static NSString *fTypeOfTransport = @"typeOfTransport";
static NSString *fIsFavorite = @"isFavorite";
static NSString *fOrdinalNumberInRoute = @"ordinalNumberInRoute";
static NSString *fRouteName = @"routeName";
static NSString *fStopId = @"stopId";

@implementation DatabaseManager

static DatabaseManager *_sharedMySingleton = nil;

- (id)init
{
    self = [super init];
    if (self) {
        currentManagedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    
    return self;
}

+ (DatabaseManager *)sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[DatabaseManager alloc] init];
        }
    }
    
    return _sharedMySingleton;
}

- (NSManagedObject *)createEntityByClass:(Class)klass
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(klass) inManagedObjectContext:currentManagedObjectContext];
}

- (MORoute *)newRoute
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MORoute class]) inManagedObjectContext:currentManagedObjectContext];
}

- (MOStop *)newStop
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MOStop class]) inManagedObjectContext:currentManagedObjectContext];
}

- (MOTimetable *)newTimetable
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MOTimetable class]) inManagedObjectContext:currentManagedObjectContext];
}

- (void)saveAll
{
    NSError *error = nil;
    [currentManagedObjectContext save:&error];
}

- (NSArray *)allRoutes
{
    return [MORoute MR_findAll];
}

- (NSArray *)allNumbersByType:(TypeOfTransportEnum)typeOfTransport
{
    NSArray *routes = [MORoute MR_findByAttribute:fTypeOfTransport withValue:@(typeOfTransport) inContext:currentManagedObjectContext];
    
    NSMutableArray *setOfRouteNumbers = [NSMutableArray new];
    for (MORoute *route in routes) {
        if ([setOfRouteNumbers containsObject:route.transportNumber] == NO) {
            [setOfRouteNumbers addObject:route.transportNumber];
        }
    }
    
    return setOfRouteNumbers;
}

- (NSArray *)allRoutesByType:(TypeOfTransportEnum)typeOfTransport routeNumber:(NSString *)routeNumber
{
    NSArray *routes = nil;
    if (typeOfTransport == FAVORITIES) {
        routes = [MORoute MR_findByAttribute:fIsFavorite withValue:@(YES) inContext:currentManagedObjectContext];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@ and %K == %@", fTransportNumber, routeNumber, fTypeOfTransport, @(typeOfTransport)];
        routes = [MORoute MR_findAllWithPredicate:predicate inContext:currentManagedObjectContext];
    }
    return routes;
}

- (NSArray *)allStopsByRoute:(MORoute *)route
{
    return [[route.stops allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        MOStop *stop1 = (MOStop *)obj1;
        MOStop *stop2 = (MOStop *)obj2;
        
        return [stop1.ordinalNumberInRoute compare:stop2.ordinalNumberInRoute];
    }];
}

- (MOStop *)stopFromMainRouteByStopId:(NSString *)stopId
{
//    MORoute *mainRoute = [MORoute MR_findByAttribute:fRouteName withValue:MAIN_ROUTE][0];
//    for (MOStop *moStop in mainRoute.stops) {
//        if ([moStop.stopId isEqualToString:stopId]) {
//            return moStop;
//        }
//    }
//    return nil;
    
    NSArray *foundStops = [MOStop MR_findByAttribute:fStopId withValue:stopId];
    for (MOStop *stop in foundStops) {
        if ([stop.route.routeName isEqualToString:MAIN_ROUTE]) {
            return stop;
        }
    }
    return nil;
}

- (NSArray *)allMainRouteStops
{
    MORoute *mainRoute = [MORoute MR_findByAttribute:fRouteName withValue:MAIN_ROUTE][0];
    return [mainRoute.stops allObjects];
}

//
//- (NSArray *)allAttemptsByIsWasShown:(BOOL)isWasShown
//{
//    return [Attempts findByAttribute:@"isWasShown" withValue:@(isWasShown) inContext:currentManagedObjectContext];
//}
//
//- (NSArray *)allContacts
//{
//    BOOL isDecoy = [[UserSettings sharedSingleton] isDecoy];
//    NSArray *contacts = [Contacts findByAttribute:@"isDecoy" withValue:@(isDecoy) andOrderBy:@"orderNumber" ascending:YES inContext:currentManagedObjectContext];
//    
//    return contacts;
//}
//
//- (NSArray *)allNotes
//{
//    BOOL isDecoy = [[UserSettings sharedSingleton] isDecoy];
//    NSArray *notes = [Notes findByAttribute:@"isDecoy" withValue:@(isDecoy) andOrderBy:@"orderNumber" ascending:YES inContext:currentManagedObjectContext];
//    
//    return notes;
//}

@end
