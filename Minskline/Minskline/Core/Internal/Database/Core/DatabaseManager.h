//
//  DatabaseManager.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MORoute, MOStop, MOTimetable;

@interface DatabaseManager : NSObject
{
    NSManagedObjectContext *currentManagedObjectContext;
}

+ (DatabaseManager *)sharedMySingleton;
- (NSManagedObject *)createEntityByClass:(Class)klass;
- (MORoute *)newRoute;
- (MOStop *)newStop;
- (MOTimetable *)newTimetable;

- (void)saveAll;
- (NSArray *)allRoutes;
- (NSArray *)allNumbersByType:(TypeOfTransportEnum)typeOfTransport;
- (NSArray *)allRoutesByType:(TypeOfTransportEnum)typeOfTransport routeNumber:(NSString *)routeNumber;
- (NSArray *)allStopsByRoute:(MORoute *)route;
- (MOStop *)stopFromMainRouteByStopId:(NSString *)stopId;
- (NSArray *)allMainRouteStops;

@end
